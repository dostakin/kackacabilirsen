extends CanvasLayer

# Notifies 'Main' node that the button has been pressed
signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass


func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Oyun Bitti!")
	
	await $MessageTimer.timeout
	
	$Message.text = "Kaç Kaçabilirsen!"
	$Message.show()
	# Make a one-shot timer and wiat for it to finish
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	$TouchScreenButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_start_button_pressed():
	$StartButton.hide()
	$TouchScreenButton.hide()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()


func _on_touch_screen_button_pressed():
	$TouchScreenButton.hide()
	$StartButton.hide()
	start_game.emit()
