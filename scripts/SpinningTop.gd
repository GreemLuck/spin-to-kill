extends RigidBody2D

## Preloading the force vector arrow scene
const ArrowScene := preload("res://scenes/vector_arrow.tscn")

## Controller script that dictates movement of the entity
@export var controller : MovementController
@export var max_force: float = 4000.0
@export var max_speed: float = 900.0
@export var torque_speed: float = 500.0
@export var enable_force_arrows: bool = false
@export var force_arrow_offset: float = 0.0

@onready var force_arrow: Node2D = ArrowScene.instantiate()

var force_is_applied = true

func _ready() -> void:
	if enable_force_arrows:
		add_child(force_arrow)
		force_arrow.z_index = -1
		force_arrow.position = Vector2.ZERO
		force_arrow.arrow_offset = 10.0

	controller.init(self) 
	
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

	# Movement
	controller.movement(delta)
	
	# Set the arrow vector
	if enable_force_arrows:
		var applied_force = controller.get_applied_force()
		var v_len = applied_force.length()
		var v_angle = applied_force.angle()
		force_arrow.arrow_scale = (v_len / max_force) * 10.0
		force_arrow.set_global_rotation(v_angle)
	
	# Clamp vitesse
	if linear_velocity.length() > max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed
