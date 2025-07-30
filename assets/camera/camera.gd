class_name MainCamera
extends Camera2D

@export var target: Node2D
@export var speed: float = 10

@onready var shake = $CameraShake


func _ready():
	Globals.set_camera(self)


func _physics_process(delta):
	if target != null:
		global_position = lerp(global_position, target.global_position, speed * delta)
