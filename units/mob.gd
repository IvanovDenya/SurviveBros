extends CharacterBody2D

@export var max_hp = 1000
@export var movement_speed = 100
@export var xp_dropped = 2
var current_velocity = Vector2.ZERO

var move_ai = null

func _on_area_2d_area_entered(area):
	var body = area.owner
	if body.is_in_group("player_projectiles"):
		$HpController.modify_hp(body.damage, GlobalInfo.HP_modifier_type.Flat)
	


#Mob dead
func _on_hp_controller_hp_zero():
	die()

func die(drop_xp = true):
	if drop_xp:
		var to_spawn = $XpSpawner.get_spawning_xp_objects(xp_dropped, position, 50)
		for spawning_object in to_spawn:
			var main_scene = get_tree().get_first_node_in_group("main")
			main_scene.call_deferred("add_child", spawning_object)
	GlobalVar.current_mobs -= 1
	queue_free()

func _on_update_move_timer_timeout():
	
	current_velocity = move_ai.get_velocity()
	mob_animation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	velocity = current_velocity
	move_and_slide()

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])
	$HpController.set_initial_hp($HpBar, max_hp)
	
	set_move_ai()


func mob_animation():
	if velocity.length() > 10: #more than 10 px a sec
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false



func set_move_ai():
	#var move_ai_path = load("res://ai/move_ai/face_attacker.tscn")
	var move_ai_path = load("res://ai/move_ai/distance_from_player.tscn")
	move_ai = move_ai_path.instantiate()
	#move_ai.init(self)
	move_ai.init(self, 400)
	add_child(move_ai)



#despawn logic


func _on_visible_on_screen_notifier_2d_screen_entered():
	$DespawnTimer.stop()
	



func _on_visible_on_screen_notifier_2d_screen_exited():
	$DespawnTimer.start()


func _on_despawn_timer_timeout():
	die(false)
