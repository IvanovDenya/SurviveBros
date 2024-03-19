extends Node
enum GameState {Start, Running, GameOver }

var bulletObj = null
var score
var current_game_state = GameState.Start
var shoot_loop_count = 1

func _ready():
	new_game()

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_shoot_timer_timeout():
	#add a bullet in random direction with random speed
	for i in shoot_loop_count:
		bulletObj = load(get_path_to_current_projectile())
		var bullet = bulletObj.instantiate()
		bullet.position = $Player.get_global_position()
		var rng_rotation = get_random_rotation_radians()
		bullet.rotation = rng_rotation
		var velocity = Vector2(bullet.travel_speed, 0.0)
		bullet.linear_velocity = velocity.rotated(rng_rotation)
		add_child(bullet)

	
	var estimated_wait_time =  1.0/$Player.current_attack_speed
	if estimated_wait_time < 0.1:
		$Shoot_Timer.wait_time = 0.1
		shoot_loop_count = int(0.1 / estimated_wait_time)
	

func _on_start_timer_timeout():
	$Player.start($StartPosition.position)
	$ScoreTimer.start()
	$Shoot_Timer.start()
	$Music.play()
	$MobSpawner/MobTimer.start()
	if (current_game_state == GameState.Start):
		current_game_state = GameState.Running		



func game_over():
	$ScoreTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$Shoot_Timer.stop()
	$DeathSound.play()
	$MobSpawner/MobTimer.stop()
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("player_projectiles", "queue_free")
	
func _on_death_sound_finished():
	get_tree().change_scene_to_file("res://menu/menu.tscn")

	
#Increases timers time by 2% and returns it
#Stops increasing past 0.5s
func get_increased_time(base_time, increase_ratio):
	const max_time = 0.5 #sec
	if (base_time > max_time):
		return max_time
	return base_time * increase_ratio

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

func new_game():
	score = 0
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")	
	$Shoot_Timer.wait_time = 1.0/$Player.base_attack_speed












