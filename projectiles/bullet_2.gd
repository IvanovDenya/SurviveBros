extends "res://projectiles/projectile.gd"

var target = null
func _ready():
	pass
	

func _physics_process(_delta):
	if target == null:
		return
	var direction = global_position.direction_to(target.global_position)
	linear_velocity = direction * travel_speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass






func _on_body_entered_bullet2(_body):
	hide()
	queue_free()
