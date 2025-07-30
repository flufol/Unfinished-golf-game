class_name Player
extends CharacterBody2D

const MOUSE_POWER_MAX = 100.0
const POWER_STEP = 12.5

@export var speed: float = 7.0
@export var deceleration: int = 3

var move_direction := Vector2()
var power: float
var tile_friction: float = 1.0

@onready var ball_sprite := $Ball
@onready var arrow := $Arrow
@onready var mouse_start := $MouseStart 


func _ready() -> void:
	Globals.player = self

	LevelManager.hole_started.connect(_hole_started)
	LevelManager.current_hole_completed.connect(_current_hole_completed)


func _physics_process(delta) -> void:
	delta *= Globals.get_game_speed()
	
	if not Globals.player_can_move:
		return
	
	update_arrow()
	
	if Input.is_action_pressed("shot_hold"):
		power = get_power()
	
	if Input.is_action_just_pressed("shot_hold"):
		Globals.set_game_speed(0.1)
		mouse_start.show()
		mouse_start.global_position = get_global_mouse_position()
	elif Input.is_action_just_released("shot_hold"):
		Globals.set_game_speed(1.0)
		mouse_start.hide()
		Globals.shake_camera(power / 100)
		
		if power > 0:
			Events.player_stroke.emit()
			move_direction = get_move_direction()
			velocity = -move_direction * (power * speed)
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		
		var scale_vector = Vector2(clamp(abs(velocity.y) * 0.01, 0.5, 1.5),\
		clamp(abs(velocity.x) * 0.01, 0.5, 1.5))
		var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property(ball_sprite, "scale", scale_vector, 0.2)
		tween.tween_property(ball_sprite, "scale", Vector2.ONE, 0.1)
		
		var shake_value = abs(velocity.x) if abs(velocity.x) > abs(velocity.y) else abs(velocity.y)
		Globals.shake_camera(shake_value)
		
	velocity = lerp(velocity, Vector2.ZERO, (deceleration * tile_friction) * delta)


func update_arrow() -> void:
	var frame = floorf(power / POWER_STEP) - 1
	if frame == -1:
		arrow.hide()
	else:
		arrow.show()
		arrow.frame = floorf(power / POWER_STEP) - 1
	
	if not Input.is_action_pressed("shot_hold"):
		arrow.hide()
	
	arrow.rotation = get_move_direction().angle()


func get_move_direction() -> Vector2:
	#if InputHelper.device == InputHelper.DEVICE_KEYBOARD:
	return mouse_start.global_position.direction_to(get_global_mouse_position())
	#else:
		#var direction = Input.get_vector("left_joy_axis_right", "left_joy_axis_left", "left_joy_axis_down", "left_joy_axis_up")
		#return direction


func get_distance() -> float:
	#if InputHelper.device == InputHelper.DEVICE_KEYBOARD:
	return mouse_start.global_position.distance_to(get_global_mouse_position())
	#else:
		#var direction = Input.get_vector("left_joy_axis_right", "left_joy_axis_left", "left_joy_axis_down", "left_joy_axis_up")
		#var distance = abs(direction.x) + abs(direction.y)
		#return distance * 100


func get_power() -> float:
	var new_power: float
	new_power = get_distance()
	new_power = clampf(new_power, 0.0, MOUSE_POWER_MAX)
	new_power = snappedf(new_power, POWER_STEP)
	return new_power


func _hole_started(start_pos: Vector2):
	Globals.player_can_move = true
	global_position = start_pos
	velocity = Vector2.ZERO
	ball_sprite.scale = Vector2.ONE


func _current_hole_completed(hole_pos: Vector2):
	Globals.player_can_move = false
	velocity = Vector2.ZERO
	ball_sprite.scale = Vector2.ONE
	move_direction = Vector2.ZERO
	power = 0.0
