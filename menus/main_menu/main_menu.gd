extends Control



func _on_play_pressed() -> void:
	SceneManager.change_scene("res://main.tscn")


func _on_options_pressed() -> void:
	print("Go to options menu")


func _on_quit_pressed() -> void:
	get_tree().quit()
