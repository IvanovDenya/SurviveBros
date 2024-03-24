extends Area2D
@export var xp_value = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_entered(_area):
	GlobalVar.current_xp_objects -= 1
	GlobalVar.current_visible_xp_objects -= 1
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered():
	GlobalVar.current_visible_xp_objects += 1


func _on_visible_on_screen_notifier_2d_screen_exited():
	GlobalVar.current_visible_xp_objects -= 1
