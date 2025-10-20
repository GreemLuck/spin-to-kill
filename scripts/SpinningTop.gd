extends RigidBody2D

## Controller script that dictates movement of the entity
@export var controller : MovementController

@export var max_force: float = 4000.0
@export var max_speed: float = 900.0

@export var torque_speed: float = 500.0;


func _ready() -> void:
	add_constant_torque(torque_speed)
	apply_force(controller.get_starting_force(self))

func _physics_process(delta: float) -> void:
	# Apply forces from controller
	var desired_force = controller.get_desired_force(self, delta)
	if desired_force.length() > max_force:
		desired_force = desired_force.normalized() * max_force
	apply_force(desired_force)
	
	# Clamp vitesse
	if linear_velocity.length() > max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed
