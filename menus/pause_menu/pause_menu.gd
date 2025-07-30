extends Control

var active: bool = false


func _ready() -> void:
	hide()


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		if active:
			leave()
		else:
			popup()


func popup():
	if Globals.can_pause:
		active = true
		show()
		Globals.pause_game()


func leave():
	active = false
	hide()
	Globals.resume_game()


func _on_resume_pressed() -> void:
	leave()


func _on_options_pressed() -> void:
	print("Bring up options menu")


func _on_quit_pressed() -> void:
	print("Go to main menu")
