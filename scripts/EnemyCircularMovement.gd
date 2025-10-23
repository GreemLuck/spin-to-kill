extends MovementController
class_name EnemyCircularMovement
## Applies a perpendicular force to the velocity so the body turns at a constant angular speed. 
##

@export var clockwise: bool = true
@export var starting_force: float = 100.0
@export var central_force: float = 1000.0

func init(owner: RigidBody2D):
	super(owner)
	_self.apply_impulse(Vector2.RIGHT * starting_force)

func movement(delta):
	var v: Vector2 = _self.linear_velocity
	# Normal perpendicular to linear velocity
	var n: Vector2 = Vector2(-v.y, v.x).normalized()
	if clockwise:
		n = -n

	_self.apply_force(n * central_force)
