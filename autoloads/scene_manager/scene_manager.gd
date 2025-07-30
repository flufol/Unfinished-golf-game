extends Node

signal load_finished

var loading: bool = false
var _current_scene
var _load_scene: String = ""

@onready var canvas := $Canvas
@onready var anim_player :AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	_current_scene = get_tree().current_scene
	set_process(false)
	_fade_out()


func _process(delta: float) -> void:
	if ResourceLoader.THREAD_LOAD_LOADED:
		load_finished.emit()
		add_loaded_scene_to_scene_tree()
		loading = false
		_fade_out()
		set_process(false)


func change_scene(scene, fade_in: bool = true):
	assert(scene is PackedScene or scene is String, "Scene is not a PackedScene or String")
	set_process(true)
	_fade_in()
	
	if LevelManager.current_level != "":
		LevelManager.destroy_current_level()
	
	if scene is String:
		_load_scene = scene
	elif scene is PackedScene:
		_load_scene = scene.resource_path
	
	if ResourceLoader.has_cached(_load_scene):
		ResourceLoader.load_threaded_get(_load_scene)
	else:
		ResourceLoader.load_threaded_request(_load_scene)
	
	if _current_scene != null:
		_current_scene.queue_free()
	loading = true


func add_loaded_scene_to_scene_tree() -> void:
	if _load_scene != "":
		var scene_resource = ResourceLoader.load_threaded_get(_load_scene) as PackedScene
		#if scene_resource:
		var scene = scene_resource.instantiate()
		scene.scene_file_path = _load_scene
		var root = get_tree().get_root()
		root.add_child(scene)
		_current_scene = scene
		_load_scene = ""


func _fade_in():
	canvas.show()
	anim_player.play("fade_in")
	await anim_player.animation_finished


func _fade_out():
	anim_player.play("fade")
	await anim_player.animation_finished
	canvas.hide()
