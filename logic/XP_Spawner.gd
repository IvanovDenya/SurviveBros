extends Node
@export var XP_objects : Array[Resource]
# Called when the node enters the scene tree for the first time.
func _ready():
	XP_objects.sort_custom(sort_by_amount_decreasing)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func sort_by_amount_decreasing(a, b):
	return (a.xp_value > b.xp_value)
	
#spawns xp objetcs with total amount of xp = amount on set position
func get_spawning_xp_objects (amount, position, dispercity):
	var amount_left = amount
	var exp_objects = []
	while amount_left > 0:
		var random_element = XP_objects[randi()% XP_objects.size()]
		var exp_object = random_element.instantiate()
		exp_object.global_position = GlobalF.randomize_position(position, dispercity)
		exp_objects.append(exp_object)
		amount_left -= exp_object.xp_value
	return exp_objects
