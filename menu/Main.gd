extends Node
enum GameState {Start, Running, GameOver }

var bulletObj = null
var score
var current_game_state = GameState.Start

func _ready():
	$Player.autofill_autoattacks()
	new_game()

func _on_player_spawn_something(to_spawn):
	for i in to_spawn:
		add_child(i)
	
func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)
	

func _on_start_timer_timeout():
	$Player.enable_autoattacks()
	$Player.start($StartPosition.position)
	$ScoreTimer.start()
	$Music.play()
	$MobSpawner/MobTimer.start()
	if (current_game_state == GameState.Start):
		current_game_state = GameState.Running		



func game_over():
	$Player.disable_autoattacks()
	$ScoreTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	$MobSpawner/MobTimer.stop()
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("xp_objects", "queue_free")
	get_tree().call_group("player_projectiles", "queue_free")
	
func _on_death_sound_finished():
	get_tree().change_scene_to_file("res://menu/menu.tscn")

func new_game():
	score = 0
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")	














