extends Node

var game_speed: float = 1.0
var camera: Camera2D
var player: Player
var player_can_move: bool = true
var can_pause: bool = true


func shake_camera(trauma: float) -> void:
	if camera != null:
		camera.shake.add_trauma(trauma)


func pause_game():
	get_tree().paused = true


func resume_game():
	get_tree().paused = false


func set_camera(new_camera: Camera2D):
	camera = new_camera


func set_game_speed(value) -> void:
	game_speed = value


func get_game_speed() -> float:
	return game_speed
