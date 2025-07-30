class_name CameraShake
extends Node

@export var decay: int = 4
@export var max_offset := Vector2(50,50) 
@export var max_roll: float = 0.0
@export var noise: FastNoiseLite

var noise_y: float = 0.0

var trauma: float = 0.0
var trauma_pwr: int = 6

@onready var camera = get_parent()

func _ready():
	randomize()
	noise.seed = randi()


func add_trauma(amount: float):
	trauma = min(trauma + amount, 1.0)


func _physics_process(delta):
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()
	elif camera.offset.x != 0 or camera.offset.y != 0 or camera.rotation != 0:
		lerp(camera.offset.x, 0.0, 1)
		lerp(camera.offset.y, 0.0, 1)
		lerp(camera.rotation, 0.0, 1)


func shake(): 
	var amt = pow(trauma, trauma_pwr)
	noise_y += 1
	camera.rotation = max_roll * amt * noise.get_noise_2d(0, noise_y)
	camera.offset.x = max_offset.x * amt * noise.get_noise_2d(1000, noise_y)
	camera.offset.y = max_offset.y * amt * noise.get_noise_2d(2000, noise_y)
