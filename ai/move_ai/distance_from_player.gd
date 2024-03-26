extends Node
@onready var player = get_tree().get_first_node_in_group("player")
var user = null
var preferred_distance = 100.0
var speed_modifier_when_distancing = 2
const preffred_interval_coefficient = 1.2
func init(new_user, preferred_distance_px = 100.0, speed_modifier = 2):
	user = new_user
	preferred_distance = preferred_distance_px
	speed_modifier_when_distancing = speed_modifier

func get_velocity():
	var direction = user.global_position.direction_to(player.global_position)
	var distance = user.global_position.distance_to(player.global_position)
	var speed_modifier =  (1 + GlobalInfo.mob_movespeed_increase_per_second_percents * GlobalInfo.accumulated_time / 100.0)
	
		
	if distance < preferred_distance:
		direction *= -1
		speed_modifier *= speed_modifier_when_distancing
	elif distance / preffred_interval_coefficient < preferred_distance:
		#dont want to move in some interval to avoind moving back and forth
		speed_modifier = 0 
	
	return direction * user.movement_speed * speed_modifier
