extends Area2D
signal hit

@export var speed = 400
@export var dash_speed = 2000
var screen_size
var current_velocity = Vector2.ZERO
@export var state = "normal"

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()

# Called every frame
# Parameters :
#	delta - int - time elapsed from previous call (in ms)
#ETODO Decompose - слишком много всего в одном методе, как минимум 3 доп. метода напрашиваются
func _process(delta):
	if Input.is_action_pressed("player_dash"):
		$Dash.execute(self)
	
	if state == "normal":
		current_velocity = Vector2.ZERO
		if Input.is_action_pressed("move_right"):
			current_velocity.x += 1
		if Input.is_action_pressed("move_left"):
			current_velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			current_velocity.y += 1
		if Input.is_action_pressed("move_up"):
			current_velocity.y -= 1
	
	var speed_used = (dash_speed if state == "dashing" else speed)
	if current_velocity.length() > 0:
		current_velocity = current_velocity.normalized() * speed_used
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	position += current_velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	if current_velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
	# See the note below about boolean assignment.
		$AnimatedSprite2D.flip_h = current_velocity.x < 0
	elif current_velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = current_velocity.y > 0

func _on_body_entered(_body):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

