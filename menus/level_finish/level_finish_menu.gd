extends Control

var active: bool = false


func _ready() -> void:
	hide()


func popup():
	Globals.can_pause = false
	active = true
	show()
	Globals.pause_game()


func leave():
	Globals.can_pause = true
	active = false
	hide()
	Globals.resume_game()


func _on_continue_pressed() -> void:
	leave()
	SceneManager.change_scene("res://menus/main_menu/main_menu.tscn")


func _on_restart_pressed() -> void:
	leave()
	LevelManager.restart_current_level()
