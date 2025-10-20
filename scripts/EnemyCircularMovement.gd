extends MovementController
class_name EnemyCircularMovement
## Applies a perpendicular force to the velocity so the body turns at a constant angular speed. 
##

@export var clockwise: bool = true
@export var starting_force: float = 100000.0
@export var central_force: float = 2000

func get_starting_force(owner: Node) -> Vector2:
	return Vector2.RIGHT * starting_force

func get_desired_force(owner, delta) -> Vector2:
	var v: Vector2 = owner.linear_velocity
	# Normal perpendicular to linear velocity
	var n: Vector2 = Vector2(-v.y, v.x).normalized()
	if clockwise:
		n = -n

	return n * central_force
