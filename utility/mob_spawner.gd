extends Node2D

@export var mob_spawn_records: Array[Mob_spawn_info] = []

@onready var player = get_tree().get_first_node_in_group("player")

@export var accumulated_time = 0



func can_mob_be_spawned(mob_spawn_info):
	#Cant be spawned because not time to start yet
	if GlobalF.is_strictly_outside(accumulated_time, mob_spawn_info.time_start, mob_spawn_info.time_end):
		return false
	#Cant spawn because of the delay
	if mob_spawn_info.spawn_delay_counter < mob_spawn_info.mob_spawn_delay:
		return false
	return true

func get_random_position():
	var vpr = get_viewport_rect().size * randf_range(1.1,1.4)
	var top_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y - vpr.y/2)
	var top_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y - vpr.y/2)
	var bottom_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y + vpr.y/2)
	var bottom_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y + vpr.y/2)
	var pos_side = ["up","down","right","left"].pick_random()
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO
	
	match pos_side:
		"up":
			spawn_pos1 = top_left
			spawn_pos2 = top_right
		"down":
			spawn_pos1 = bottom_left
			spawn_pos2 = bottom_right
		"right":
			spawn_pos1 = top_right
			spawn_pos2 = bottom_right
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = bottom_left
	
	var x_spawn = randf_range(spawn_pos1.x, spawn_pos2.x)
	var y_spawn = randf_range(spawn_pos1.y,spawn_pos2.y)
	return Vector2(x_spawn,y_spawn)

func handle_spawn_delay_counter(mob_spawn_info):
	if mob_spawn_info.spawn_delay_counter < mob_spawn_info.mob_spawn_delay:
		mob_spawn_info.spawn_delay_counter += 1	

func _on_timer_timeout():
	accumulated_time += 1
	for mob_spawn_info in mob_spawn_records:
		#increase counter until it reaches the delay
		handle_spawn_delay_counter(mob_spawn_info)
		#check if a mob can be spawned
		if can_mob_be_spawned(mob_spawn_info):
			spawn_mob(mob_spawn_info)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func spawn_mob(mob_spawn_info):
	var mobs = get_tree().get_nodes_in_group("Mobs")
	if mobs.size() > GlobalInfo.max_mob_count:
		return
	
	mob_spawn_info.spawn_delay_counter = 0
	var new_mob = mob_spawn_info.mob	
	var base_num = mob_spawn_info.mob_num
	var final_num = base_num + floor(base_num *  GlobalInfo.mob_spawn_rate_increase_per_second_percents * accumulated_time / 100.0)
	final_num = min(GlobalInfo.max_spawn_rate_percents / 100.0 * base_num, final_num)
	
	print("Mobs spawning : " + str(final_num))
	for i in final_num:
		var mob = new_mob.instantiate()
		mob.global_position = get_random_position()
		add_child(mob)

