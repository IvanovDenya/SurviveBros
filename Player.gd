extends Node2D

const RATE_OF_FIRE = 5.0
const MAX_VERTICAL_MOVEMENT = 200

var PlayerSpeed = 150
var VerticalMovement = 0
var bulletObj = null
var dying = false
var mouse_left_down = false
@onready var shotCooldown = $Timer
@onready var explode = preload("res://explosion.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	bulletObj = load("res://bullet.tscn")
	shotCooldown.wait_time = 1.0 / RATE_OF_FIRE
	shotCooldown.one_shot = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(dying == true):
		get_node("/root/GameRoot").PlayerDied()
		queue_free()
	else:
		move_local_x(PlayerSpeed * delta)
		if(is_in_playing_zone(self.position.y)):
			move_local_y(VerticalMovement*delta)
		else:
			handle_bounce()
		if mouse_left_down:
			handle_player_shoot()
	

func stop():
	PlayerSpeed = 0

func _input(event):
	
	if (event.is_action("PLAYER_UP")):
		handle_player_up()
	if (event.is_action("PLAYER_DOWN")):
		handle_player_down()
	if event is InputEventMouseButton:
		
		if event.button_index == 1 and event.is_pressed():
			mouse_left_down = true
		elif event.button_index == 1 and not event.is_pressed():
			mouse_left_down = false

func explode_player():
	#Make sure we arent currently exploding!
	if explode:
		explode.set_position(self.get_position())
		get_parent().add_child(explode)
		Global.kills = Global.kills + 1
	shotCooldown.wait_time = 2.5
	shotCooldown.start()
	$PlayerSprite.visible = false
	dying = true
	PlayerSpeed = 0
	VerticalMovement = 0

func is_above_bot_boundary(position_y):
	return (position_y <= get_viewport_rect().size.y - 100)

func dead():
	get_node("/root/GameSceneRoot").PlayerDied()

func is_below_top_boundary(position_y):
	return (position_y > 100)

func is_in_playing_zone(position_y):
	return (is_below_top_boundary(position_y) && is_above_bot_boundary(position_y))

func handle_bounce():
	if !(is_below_top_boundary(self.position.y)):
		move_local_y(20) #Bounce off top
		VerticalMovement = 0
	if !(is_above_bot_boundary(self.position.y)): 
		move_local_y(-20) #Bounce off bottom
		VerticalMovement = 0

func handle_player_up():
	#if moving down, stop
	if (VerticalMovement > 0):
		VerticalMovement = -100
	else:
		if(VerticalMovement >= -MAX_VERTICAL_MOVEMENT):
			VerticalMovement-= 20

func handle_player_down():
	#if moving up, stop
	if (VerticalMovement < 0):
		VerticalMovement = 100
	else:
		if(VerticalMovement <= MAX_VERTICAL_MOVEMENT):
			VerticalMovement+= 20

func handle_player_shoot():
	print ("shoota")
	if(shotCooldown.time_left == 0):
		var bullet = bulletObj.instantiate()
		bullet.position = self.get_position()
		bullet.position.x = bullet.position.x + 100
		bullet.position.y = bullet.position.y
		get_node("/root/GameRoot").add_child(bullet)
		shotCooldown.start()

func _on_Area2D_area_entered(_area):
	#Layer 2 is another enemy
	explode_player()
	
