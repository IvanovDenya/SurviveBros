extends CharacterBody2D
signal hit

@export var speed = 300
@export var dash_speed = 3000
var current_velocity = Vector2.ZERO
var current_speed = 0
var state = GlobalInfo.Unit_state.Idle
@export var base_attack_speed = 5
var current_attack_speed = 5

func _on_body_entered(body):
	if body.is_in_group("mobs"):
		die()
func _on_detection_area_area_entered(area):
	if area.is_in_group("xp_objects"):
		$XpController.add_xp(area.xp_value)
func _on_xp_controller_lvl_up():
	current_attack_speed *= 1.6
	current_attack_speed = min (20.0, current_attack_speed)
	print (current_attack_speed)
	
func _physics_process(_delta):
	
	if (state == GlobalInfo.Unit_state.Idle):
		pass
	if (state == GlobalInfo.Unit_state.Dead):
		pass
		
	player_dash()
	player_movement()
	player_animation()
	move_and_slide()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

#handles player death
func die():
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	$DetectionArea/CollisionShape2D.set_deferred("disabled", true)
	state = GlobalInfo.Unit_state.Dead
	
#ETODO Annotation
func calculate_current_velocity():
	if state == GlobalInfo.Unit_state.Normal:
		var x_move = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		var y_move = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		var move = Vector2(x_move,y_move)
		
		current_velocity = move.normalized() * current_speed
	elif state == GlobalInfo.Unit_state.Dash:
		current_velocity = current_velocity.normalized() * current_speed
	else:
		current_velocity = Vector2.ZERO


func player_animation():
	if current_velocity.length() > 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false

func player_movement():
	current_speed = (dash_speed if state == GlobalInfo.Unit_state.Dash else speed)
	calculate_current_velocity()
	velocity = current_velocity

func player_dash():
	if Input.is_action_pressed("player_dash"):
		$Dash.execute(self)

func start(pos):
	position = pos
	state = GlobalInfo.Unit_state.Normal
	show()
	$CollisionShape2D.disabled = false







