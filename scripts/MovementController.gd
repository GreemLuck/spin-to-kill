extends Resource
class_name MovementController
## This is an interface for entities movement

var _self : RigidBody2D

## Initialize the controller
## [br]
## [param owner] : The Node to which the force will be applied [br]
func init(owner: RigidBody2D) -> void:
	_self = owner


## Dictates the logic of movement for the controller [br]
## [br]
## [param delta] : Time delta from physic process
func movement(delta: float) -> void:
	pass


## Returns the currently applied force as Vector2 [br]
func get_applied_force() -> Vector2:
	return Vector2.ZERO
