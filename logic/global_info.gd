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

@export var mob_spawn_rate_increase_per_second_percents = 5
@export var max_spawn_rate_percents = 2000
@export var player_atk_speed_increase_rate_per_lvl_percents = 100
@export var player_max_atk_speed = 40.0
@export var mob_movespeed_increase_per_second_percents = 1
@export var player_movespeed_increase_per_lvl_percents = 10
@export var max_mob_count = 500
var accumulated_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
