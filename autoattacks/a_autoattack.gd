extends Node
signal ready_attack(link)
var attack_loop_count = 1
var user = null
@export var ext_attack_speed_modifier = 1.0
@export var base_cooldown_seconds = 1.0
@export var attack_amount = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_cooldown_timeout():
	ready_attack.emit(self)

func objects_to_spawn():
	#returns array of ready objects to add to main scene like bullets etc
	#number of objects is multiplied by attack_loop_count
	#attack_loop_count is increased if Cooldown.waittime shall become < 0.1 sec
	return null

func enable_attack():
	$Cooldown.start()

func disable_attack():
	$Cooldown.stop()

func get_default_cooldown():
	return base_cooldown_seconds

func set_default_cooldown():
	$Cooldown.wait_time = base_cooldown_seconds
	
func set_cooldown(value):
	$Cooldown.wait_time = value
