extends Node
@onready var player = get_tree().get_first_node_in_group("player")
var user = null

func init(new_user):
	user = new_user

func get_velocity():
	var direction = user.global_position.direction_to(player.global_position)
	var speed_modifier = (1 + GlobalInfo.mob_movespeed_increase_per_second_percents * GlobalInfo.accumulated_time / 100.0)
	return direction * user.movement_speed * speed_modifier
