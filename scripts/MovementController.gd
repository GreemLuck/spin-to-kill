extends Resource
class_name MovementController
## This is an interface for entities movement

## Returns the force computed by the controller that will be applied only once when the owner is instantiated
## [br]
## [param owner] : The Node to which the force will be applied [br]
func get_starting_force(owner: Node) -> Vector2:
	return Vector2.ZERO 


## Returns the force computed by the controller that will be applied to the entity [br]
## [br]
## [param owner] : The Node to which the force will be applied [br]
## [param delta] : Time delta from physic process
func get_desired_force(owner: Node, delta: float) -> Vector2:
	return Vector2.ZERO
