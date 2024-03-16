extends CharacterBody2D
signal hit

@export var speed = 300
@export var dash_speed = 3000
var current_velocity = Vector2.ZERO
@export var state = "normal"



#Не нашел такой сигнал в базе CharacterBody, возможно вообще не нужен
func _on_body_entered(_body):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	$Area2D/CollisionShape2D.set_deferred("disabled", true)

func _process(_delta):
	move_and_slide()
	player_animation()
	player_dash()

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

#ETODO Annotation
func calculate_current_velocity():
	var x_move = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_move = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	var move = Vector2(x_move,y_move)
	current_velocity = move.normalized() * speed

func my_type():
	return "Player"

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

func player_dash():
	if Input.is_action_pressed("player_dash"):
		$Dash.execute(self)
	var speed_used = (dash_speed if state == "dashing" else speed)

	if state == "normal":
		calculate_current_velocity()
	else:
		current_velocity = current_velocity.normalized() * speed_used
	
	velocity = current_velocity

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

