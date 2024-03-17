extends CanvasLayer

# Notifies `Main` node that the button has been pressed



func _on_message_timer_timeout():
	$Message.hide()



func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout


func update_score(score):
	$ScoreLabel.text = str(score)




