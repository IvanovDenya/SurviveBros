extends Node
enum GameState {Start, Running, GameOver }

@export var mob_scene: PackedScene
var bulletObj = null
var score
var current_game_state = GameState.Start

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")	
	

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$Shoot_Timer.stop()
	$DeathSound.play()
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("player_projectiles", "queue_free")
	
func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	$Shoot_Timer.start()
	$Music.play()
	if (current_game_state == GameState.Start):
		current_game_state = GameState.Running
		

#ETODO Decompose - выбор скорости и направления моба это важные изменяемые вещи, точно стоит вынести
func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	
	var sprite = mob.find_child("Sprite", false)
	sprite.rotation = direction
	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func _on_shoot_timer_timeout():
	#add a bullet in random direction with random speed
	bulletObj = load(get_path_to_current_projectile())
	var bullet = bulletObj.instantiate()
	bullet.position = $Player.get_global_position()
	var rng_rotation = get_random_rotation_radians()
	bullet.rotation = rng_rotation
	var velocity = Vector2(bullet.travel_speed, 0.0)
	bullet.linear_velocity = velocity.rotated(rng_rotation)
	add_child(bullet)
	#lowering the attack speed 
	$Shoot_Timer.wait_time = get_increased_time($Shoot_Timer.wait_time)


#Increases timers time by 2% and returns it
#Stops increasing past 0.5s
func get_increased_time(base_time):
	const max_time = 0.5 #sec
	if (base_time > max_time):
		return max_time
	return base_time * 1.02

#Currently, this returns static path to bullet_1
#Later, this will return objects based on current weapon, etc
#Returns - String - path to scene
func get_path_to_current_projectile():
	return "res://projectiles/bullet_1.tscn"

#Returns - float - random angle in radians from 0 to 2 * PI
func get_random_rotation_radians():
	return deg_to_rad(get_random_rotation_degrees())
	
#Returns - float - random angle in degrees from 0 to 360
func get_random_rotation_degrees():
	return randf() * 360


