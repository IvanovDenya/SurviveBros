extends Node

var current_xp = 0
var current_lvl = 0
var current_threshold = 0
var lvl_thresholds = []
signal lvl_up

# Called when the node enters the scene tree for the first time.
func _ready():
	lvl_thresholds.append(5)
	lvl_thresholds.append(10)
	lvl_thresholds.append(15)
	lvl_thresholds.append(20)
	lvl_thresholds.append(25)
	lvl_thresholds.append(30)
	lvl_thresholds.append(35)
	lvl_thresholds.append(9999999)
	current_threshold = lvl_thresholds[0]
	current_lvl = 0
	current_xp = 0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

#Adds xp, checks for lvl-ups, prints lvl ups
func add_xp(xp_value):
	current_xp += xp_value
	if (current_xp > current_threshold):
		handle_lvl_up()
		
func handle_lvl_up():
	current_xp -= current_threshold
	current_lvl += 1
	print ("YOU REACHED LVL " + str(current_lvl + 1))
	current_threshold = lvl_thresholds[current_lvl]
	lvl_up.emit()
