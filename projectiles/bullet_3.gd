extends "res://projectiles/projectile.gd"

var kill_count = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass



func _on_body_entered_bullet3(body):
	if (kill_count > 0):
		linear_velocity *= -3.3
		kill_count -=1;
		add_collision_exception_with(body)
	else:
		hide()
		queue_free()