extends RigidBody2D

## Preloading the force vector arrow scene
const ArrowScene := preload("res://scenes/vector_arrow.tscn")

## Controller script that dictates movement of the entity
@export var controller : MovementController
@export var max_force: float = 4000.0
@export var max_speed: float = 900.0
@export var torque_speed: float = 500.0
@export var force_arrow_offset: float = 0.0

@onready var force_arrow: Node2D = ArrowScene.instantiate()

var force_is_applied = true

func _ready() -> void:
	add_child(force_arrow)
	force_arrow.z_index = -1
	force_arrow.position = Vector2.ZERO
	force_arrow.arrow_offset = 10.0

	add_constant_torque(torque_speed)
	apply_force(controller.get_starting_force(self))
	
	#Permet de détecter les collisions avec _integrate_forces
	contact_monitor = true
	max_contacts_reported = 4
	
	$DisabledTimer.timeout.connect(func(): force_is_applied = true)

func _integrate_forces(state):
	if state.get_contact_count() > 0:
		$DisabledTimer.start()
		force_is_applied = false


func _physics_process(delta: float) -> void:
	if not force_is_applied:
		return
	# Apply forces from controller
	var desired_force = controller.get_desired_force(self, delta)
	if desired_force.length() > max_force:
		desired_force = desired_force.normalized() * max_force
	apply_force(desired_force)
	
	# Set the arrow vector
	var v_len = desired_force.length()
	var v_angle = desired_force.angle()
	force_arrow.arrow_scale = (v_len / max_force) * 10.0
	force_arrow.set_global_rotation(v_angle)
	
	# Clamp vitesse
	if linear_velocity.length() > max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed
