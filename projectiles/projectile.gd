extends CharacterBody2D

@export var travel_speed = 0
@export var damage = 0


func _physics_process(_delta):
	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
