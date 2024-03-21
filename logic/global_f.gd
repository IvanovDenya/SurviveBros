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
	
	
#Returns a position in dispercity range (pixels) from position
func randomize_position(position, dispercity):
	var randomAngle = randf() * 2 * PI
	var randomDistance = randf() * dispercity
	#we look for a position located at randomDistance pixels from position, at randomAngle degrees from it
	var x_shift = sin(randomAngle) * randomDistance
	var y_shift = cos(randomAngle) * randomDistance
	return Vector2(position.x + x_shift, position.y + y_shift)
	
	
#Returns - float - random angle in radians from 0 to 2 * PI
func get_random_rotation_radians():
	return deg_to_rad(get_random_rotation_degrees())

#Returns - float - random angle in degrees from 0 to 360
func get_random_rotation_degrees():
	return randf() * 360
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


