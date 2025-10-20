extends MovementController
class_name PlayerController

var _prev_mouse: Vector2 = Vector2.ZERO
var _mouse_vel: Vector2 = Vector2.ZERO
var _mouse_init: bool = false
var _hit_timer: float = 0.0

@export var k_pos: float = 40.0
@export var k_vel: float = 6.0
@export var lin_damping: float = 8.0

func get_desired_force(owner,delta):
	var mouse: Vector2 = owner.get_global_mouse_position()
	if not _mouse_init:
		_prev_mouse = mouse
		_mouse_init = true

	_mouse_vel = (mouse - _prev_mouse) / maxf(delta, 0.000001)
	_prev_mouse = mouse

	var to_target: Vector2 = mouse - owner.global_position
	var force: Vector2 = to_target * k_pos + _mouse_vel * k_vel - owner.linear_velocity * lin_damping
	return force
	
