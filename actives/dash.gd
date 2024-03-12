extends Node

var user = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#Basic method for executing the ability 
#Paremeters:
#	user: user of the ability
func execute(user):
	self.user = user
	#Timer is not active, ability can be used
	if $AbilityTimer.time_left == 0:
		$AbilityTimer.start()
		user.state = "dashing"
		$EndDashTimer.start()
		
func _on_end_dash_timer_timeout():
	user.state = "normal"
