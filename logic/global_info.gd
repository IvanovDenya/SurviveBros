extends Node
enum HP_modifier_type {
	Flat,
	CurrentHPPercentage,
	MaxHPPercantage
}
enum Unit_state {
	Idle,
	Normal,
	Dead,
	Dash
}

const mob_spawn_rate_increase_per_second_percents = 5
const max_spawn_rate_percents = 2000
const player_atk_speed_increase_rate_per_lvl_percents = 20
const player_max_atk_speed = 40.0
const mob_movespeed_increase_per_second_percents = 2
const player_movespeed_increase_per_lvl_percents = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
