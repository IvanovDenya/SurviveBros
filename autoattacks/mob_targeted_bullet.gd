extends "res://autoattacks/a_autoattack.gd"
@export var bulletObj:Resource

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func objects_to_spawn():
	var spawn_arr = []
	#returns array of ready objects to add to main scene like bullets etc
	#number of objects is multiplied by attack_loop_count
	#attack_loop_count is increased if Cooldown.waittime shall become < 0.1 sec
	for i in attack_loop_count:
		var bullet = bulletObj.instantiate()
		bullet.position = user.get_global_position()
		var velocity = Vector2(bullet.travel_speed, 0.0)
		var target = find_closest_mob(bullet)
		if target == null:
			var random_totation = GlobalF.get_random_rotation_radians()
			bullet.velocity = velocity.rotated(random_totation);
			bullet.rotation = random_totation
		else:
			var direction = bullet.global_position.direction_to(target.global_position)
			bullet.velocity = direction * bullet.travel_speed
			bullet.rotation = bullet.global_position.angle_to_point(target.global_position)
			bullet.target = target
		spawn_arr.append(bullet)
	
	var base_wait_time = base_cooldown_seconds/ user.base_attack_speed
	var user_as_mod = (user.current_attack_speed / user.base_attack_speed) - 1
	var estimated_wait_time = base_wait_time / (1 + user_as_mod * ext_attack_speed_modifier)
	if estimated_wait_time < 0.1:
		$Cooldown.wait_time = 0.1
		attack_loop_count = int(0.1 / estimated_wait_time)
	else:
		$Cooldown.wait_time = estimated_wait_time
		
	return spawn_arr

func find_closest_mob(from_body):
	var min_distance = 10000000.0
	var mobs = get_tree().get_nodes_in_group("mobs")
	var target = null
	for mob in mobs:
		if from_body.global_position.distance_to(mob.global_position) < min_distance:
			min_distance = from_body.global_position.distance_to(mob.global_position)
			target = mob
	return target
