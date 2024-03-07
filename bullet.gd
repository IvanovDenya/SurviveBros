extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_local_x(delta * 400)

func _on_area_2d_area_entered(_area):
	#if(area.get_collision_layer_bit(2)):
	queue_free()
