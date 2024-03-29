extends RigidBody2D

var max_hp = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $Sprite.sprite_frames.get_animation_names()
	$Sprite.play(mob_types[randi() % mob_types.size()])
	$HpController.set_initial_hp($HpBar, max_hp)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_body_entered(body):
	$HpController.modify_hp(body.damage, GlobalInfo.HP_modifier_type.Flat)
#Mob dead
func _on_hp_controller_hp_zero():
	queue_free()
