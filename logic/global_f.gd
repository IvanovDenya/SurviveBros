extends Node

#Checks if value is between 2 ends
#Parameters:
#	value - name desc
#	low_end - name desc
#	high_end - name desc
#	include_low_end - does value == low_end return true
#	include_high_end - does value == high_end return true
#Returns
#	Boolean
func is_between(value, low_end, high_end, include_low_end = false, include_high_end = false):
	if (include_low_end and value == low_end):
		return true
	if (include_high_end and value == high_end):
		return true
	return (value > low_end and value < high_end)

#Checks if value is striclty between 2 ends
#Parameters:
#	value - name desc
#	low_end - name desc
#	high_end - name desc
#Returns
#	Boolean
func is_strictly_between(value, low_end, high_end):
	return is_between(value,low_end,high_end)

#Checks if value is non-striclty between 2 ends
#Parameters:
#	value - name desc
#	low_end - name desc
#	high_end - name desc
#Returns
#	Boolean
func is_non_strictly_between(value, low_end, high_end):
	return is_between(value,low_end,high_end, true, true)
	
#Checks if value is outside of 2 ends
#Parameters:
#	value - name desc
#	low_end - name desc
#	high_end - name desc
#	include_low_end - does value == low_end return false
#	include_high_end - does value == high_end return false
#Returns
#	Boolean
func is_outside(value, low_end, high_end, include_low_end = false, include_high_end = false):
	return not is_between(value, low_end, high_end, include_low_end, include_high_end)
	
#Checks if value is striclty between 2 ends
#Parameters:
#	value - name desc
#	low_end - name desc
#	high_end - name desc
#Returns
#	Boolean
func is_strictly_outside(value, low_end, high_end):
	return not is_non_strictly_between(value,low_end,high_end)

#Checks if value is non-striclty between 2 ends
#Parameters:
#	value - name desc
#	low_end - name desc
#	high_end - name desc
#Returns
#	Boolean
func is_non_strictly_outside(value, low_end, high_end):
	return not is_strictly_between(value,low_end,high_end)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


