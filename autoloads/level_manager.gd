extends Node

signal level_started
signal hole_started
signal current_level_completed
signal current_hole_completed(hole_pos)
signal level_changed(level: PackedScene)
signal level_restarted()

var levels: Dictionary = {"level_1": preload("res://levels/level_1/level_1.tscn"), "level_2": preload("res://levels/level_1/level_2.tscn")}

var current_level: String = ""
var current_level_scene: PackedScene


func change_level(new_level: String):
	assert(levels.has(new_level), "that level is not in the level dictionary")
	
	level_changed.emit(new_level)
	
	if current_level != "":
		destroy_current_level()
	
	current_level = new_level
	current_level_scene = levels.get(new_level)
	
	instantiate_current_level()


func instantiate_current_level():
	var instance = current_level_scene.instantiate()
	add_child(instance)
	instance.name = current_level


func destroy_current_level():
	var level = get_node_or_null(current_level)
	remove_child(level)
	level.queue_free()
	current_level = ""
	current_level_scene = null


func restart_current_level():
	level_restarted.emit()
	change_level(current_level)
