extends CharacterBody2D
signal hit

@export var speed = 300
@export var dash_speed = 3000
#var screen_size
var current_velocity = Vector2.ZERO
@export var state = "normal"

func my_type():
	return "Player"
	
# Called when the node enters the scene tree for the first time.
func _ready():
	#screen_size = get_viewport_rect().size
	hide()

# Called every frame
# Parameters :
#	delta - int - time elapsed from previous call (in ms)
#ETODO Decompose - слишком много всего в одном методе, как минимум 3 доп. метода напрашиваются
func _process(_delta):
	if Input.is_action_pressed("player_dash"):
		$Dash.execute(self)
	var speed_used = (dash_speed if state == "dashing" else speed)
	
	if state == "normal":
		calculate_current_velocity()
	else:
		current_velocity = current_velocity.normalized() * speed_used
	
	#position += current_velocity * _delta
	#position = position.clamp(Vector2.ZERO, screen_size)
	
		
	velocity = current_velocity
	move_and_slide()
	player_animation()
	
func player_animation():
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false

#ETODO Annotation
func calculate_current_velocity():
	var x_move = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_move = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	var move = Vector2(x_move,y_move)
	current_velocity = move.normalized() * speed
	

func _on_body_entered(_body):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

