extends "res://projectiles/projectile.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_body_entered_bullet1(_body):
	hide()
	queue_free()
