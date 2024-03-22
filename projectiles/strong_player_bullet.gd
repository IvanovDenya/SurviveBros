extends "res://projectiles/projectile.gd"

var target = null

func _physics_process(_delta):
	if target != null:
		var direction = global_position.direction_to(target.global_position)
		velocity = direction * travel_speed
	move_and_slide()

func _on_target_detection_area_area_entered(_area):
	queue_free()
