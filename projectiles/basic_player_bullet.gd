extends "res://projectiles/projectile.gd"

func _physics_process(_delta):
	move_and_slide()


func _on_target_detection_area_area_entered(_area):
	queue_free()
	

