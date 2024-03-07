extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.kills = 0
	Global.currentStage = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_quit_pressed():
	get_tree().quit()


func _on_start_pressed():
	get_tree().change_scene_to_file("game_root.tscn")
