extends "res://autoattacks/a_autoattack.gd"
@export var bulletObj:Resource

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_cooldown_timeout():
	ready_attack.emit(self)
	
func objects_to_spawn():
	var spawn_arr = []
	#returns array of ready objects to add to main scene like bullets etc
	#number of objects is multiplied by attack_loop_count
	#attack_loop_count is increased if Cooldown.waittime shall become < 0.1 sec
	for i in attack_loop_count:
		var bullet = bulletObj.instantiate()
		bullet.position = user.get_global_position()
		var rng_rotation = GlobalF.get_random_rotation_radians()
		bullet.rotation = rng_rotation
		var velocity = Vector2(bullet.travel_speed, 0.0)
		bullet.linear_velocity = velocity.rotated(rng_rotation)
		spawn_arr.append(bullet)
	
	var estimated_wait_time =  base_cooldown_seconds*self_attack_speed_modifier/user.current_attack_speed
	if estimated_wait_time < 0.1:
		$Cooldown.wait_time = 0.1
		attack_loop_count = int(0.1 / estimated_wait_time)
	else:
		$Cooldown.wait_time = estimated_wait_time
		
	return spawn_arr
