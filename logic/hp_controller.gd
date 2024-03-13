extends Node
signal hp_zero
var current_hp = 0
var max_hp = 0
#is set to true after set_initial_hp() call
var initialized = false 

var hp_bar_controlled = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

#If current_hp is zero or less, emits signal
func check_if_hp_zero():
	if (current_hp <= 0):
		hp_zero.emit()

#Changes current_hp based on value and type of hp-change
#Types are described in global_info.HP_modifier_type
#Parameters:
#	value - int/float - change value
#	modifier_type - Enum HP_modifier_type - type of HP change
func modify_hp(value, modifier_type):
	if !(initialized):
		pass
	if (modifier_type == GlobalInfo.HP_modifier_type.Flat):
		current_hp = current_hp - value
	if (modifier_type == GlobalInfo.HP_modifier_type.CurrentHPPercentage):
		current_hp = current_hp * (100 - value) / 100		
	if (modifier_type == GlobalInfo.HP_modifier_type.MaxHPPercantage):
		current_hp = current_hp - max_hp * value / 100
	current_hp = max(current_hp, 0)	
	self.hp_bar_controlled.value = current_hp
	check_if_hp_zero()

#Name-explained
func set_initial_hp(hp_bar, initial_hp):
	self.max_hp = initial_hp
	self.current_hp = initial_hp
	self.hp_bar_controlled = hp_bar
	self.hp_bar_controlled.max_value = initial_hp
	self.hp_bar_controlled.value = initial_hp
	initialized = true
