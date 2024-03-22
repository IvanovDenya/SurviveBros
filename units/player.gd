extends CharacterBody2D
signal hit
signal spawn_something(to_spawn)

@onready var ram_anim = $AnimationPlayer
@onready var ram_sprite = $Rambro
#Базовая скорость
@export var speed = 300
#Скорость в деше
@export var dash_speed = 1500
#Базовая скорость атак - атак в секунду
@export var base_attack_speed = 2


var current_velocity = Vector2.ZERO
var current_speed = 0
var state = GlobalInfo.Unit_state.Idle
var current_attack_speed = base_attack_speed
#I-фреймы
var hitboxes_enabled = false
#Множитель скорости
var move_speed_modifier = 1

var current_lvl = 0
#Массив сцен автоатак
var autoattacks = []

#Вызывается при контакте с другими Area2D. Пока что - бочки, потом ещё доп. бро
func _on_detection_area_area_entered(area):
	if area.is_in_group("xp_objects"):
		$XpController.add_xp(area.xp_value)
		return
	if area.owner.is_in_group("mobs") and hitboxes_enabled:
		die()

#Вызывается при лвл-апе, повышает статы
func _on_xp_controller_lvl_up():
	current_attack_speed *= 1 + GlobalInfo.player_atk_speed_increase_rate_per_lvl_percents / 100.0
	current_attack_speed = min (GlobalInfo.player_max_atk_speed, current_attack_speed)
	current_lvl+= 1
	move_speed_modifier = (1 + GlobalInfo.player_movespeed_increase_per_lvl_percents * current_lvl / 100.0)
	
func _physics_process(_delta):
	
	if (state == GlobalInfo.Unit_state.Idle):
		pass
	if (state == GlobalInfo.Unit_state.Dead):
		pass
	#Эта функция ТОЛЬКО устанавливает состояние игрока
	player_dash()
	
	#i-фреймы от деша
	if (state == GlobalInfo.Unit_state.Dash) and hitboxes_enabled:
		set_hitboxes(false)
	if (state == GlobalInfo.Unit_state.Normal) and not hitboxes_enabled:
		set_hitboxes(true)
				
	#Расчет velocity игрока исходя из состояния
	player_movement()
	#Анимация игрока исходя из velocity
	player_animation()
	
	#Завершить процесс движением body
	move_and_slide()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

#Вызывается при каждом откате автоатаки, получает от автоатаки список готовых пуль и передаёт их в Main
func _on_autoattack_ready(autoattack):
	var to_spawn = autoattack.objects_to_spawn()
	spawn_something.emit(to_spawn)
	ram_anim.play("rambro_shoot")
	

#handles player death
func die():
	ram_anim.play("rambro_death")
	#hide()
	hit.emit()
	set_hitboxes(false)
	state = GlobalInfo.Unit_state.Dead

#Функция заполняет дефолтные автоатаки. У каждого бро по идее свой набор
func autofill_autoattacks():	
	for autoattack in autoattacks:
		autoattack.queue_free()
	autoattacks.clear()
	add_autoattack("res://autoattacks/random_anti_mob_bullet_attack.tscn")
	#add_autoattack("res://autoattacks/piercing_bullet_attack.tscn")
	add_autoattack("res://autoattacks/mob_targeted_bullet.tscn")
		
#Добавляет автоатаку в массив атак бро
func add_autoattack(autoattack_path):
	var autoattack = load(autoattack_path)
	var autoattack_obj = autoattack.instantiate()
	autoattack_obj.user = self
	autoattack_obj.ready_attack.connect(_on_autoattack_ready)
	autoattack_obj.set_cooldown(autoattack_obj.get_default_cooldown()/current_attack_speed)
	autoattacks.append(autoattack_obj)
	add_child(autoattack_obj)

#Вычисляет current_velocity исходя из состояния
func calculate_current_velocity():
	#В нормальном состоянии считаем велосити из инпута
	if state == GlobalInfo.Unit_state.Normal:
		var x_move = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		var y_move = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		var move = Vector2(x_move,y_move)
		
		current_velocity = move.normalized() * current_speed * move_speed_modifier
	#При Деше сохраняем направление постоянным
	elif state == GlobalInfo.Unit_state.Dash:
		current_velocity = current_velocity.normalized() * current_speed * move_speed_modifier
	#Если мертвы - не двигаемся
	else:
		current_velocity = Vector2.ZERO

#Отключает все автоатаки
func disable_autoattacks():
	for autoattack in autoattacks:
		autoattack.disable_attack()
		
#Включает все автоатаки
func enable_autoattacks():
	for autoattack in autoattacks:
		autoattack.enable_attack()

#Занимается анимациями. Можно менять как угодно
func player_animation():
	#var h_direction = Input.get_axis("move_left","move_right")
	if current_velocity.length() > 0:
	#if h_direction:
		#velocity.x = h_direction * speed
		if state == GlobalInfo.Unit_state.Normal:
			ram_anim.play("rambro_run")
		elif state == GlobalInfo.Unit_state.Dash:
			ram_anim.play("rambro_dash")
		
		if sign(ram_sprite.scale.x) != sign (velocity.x) and velocity.x != 0:
			ram_sprite.scale.x *= -1
	else:
		#velocity.x = move_toward(velocity.x, 0, speed)
		ram_anim.stop()
	

#Задаёт плееру velocity исходя из состояния
func player_movement():
	current_speed = (dash_speed if state == GlobalInfo.Unit_state.Dash else speed)
	calculate_current_velocity()
	velocity = current_velocity


func player_dash():
	if Input.is_action_pressed("player_dash"):
		$Dash.execute(self)

#Начало деятельности игрока
func start(pos):
	position = pos
	state = GlobalInfo.Unit_state.Normal
	show()
	set_hitboxes(true)

#Переключает хитбоксы для i-фреймов
func set_hitboxes(value):
	hitboxes_enabled = value
