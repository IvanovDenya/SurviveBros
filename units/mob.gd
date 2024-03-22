extends CharacterBody2D

@export var max_hp = 1000
@export var movement_speed = 100
@export var xp_dropped = 3

@onready var player = get_tree().get_first_node_in_group("player")



func _on_area_2d_area_entered(area):
	var body = area.owner
	if body.is_in_group("player_projectiles"):
		$HpController.modify_hp(body.damage, GlobalInfo.HP_modifier_type.Flat)
	


#Mob dead
func _on_hp_controller_hp_zero():
	var to_spawn = $XpSpawner.get_spawning_xp_objects(xp_dropped, position, 50)
	for spawning_object in to_spawn:
		var main_scene = get_tree().get_first_node_in_group("main")
		main_scene.call_deferred("add_child", spawning_object)
	queue_free()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var direction = global_position.direction_to(player.global_position)
	var speed_modifier = (1 + GlobalInfo.mob_movespeed_increase_per_second_percents * GlobalInfo.accumulated_time / 100.0)
	velocity = direction * movement_speed * speed_modifier
	
	mob_animation()
	move_and_slide()

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])
	$HpController.set_initial_hp($HpBar, max_hp)


func mob_animation():
	if velocity.length() > 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false










