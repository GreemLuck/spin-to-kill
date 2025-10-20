extends RigidBody2D

@export var k_pos: float = 40.0
@export var k_vel: float = 6.0
@export var lin_damping: float = 8.0
@export var max_force: float = 4000.0
@export var max_speed: float = 900.0

@export var spin_torque: float = 1500.0

# Knockback
@export var base_impulse: float = 700.0
@export var rel_vel_factor: float = 0.8
@export var impulse_max: float = 1600.0
@export var hit_stun: float = 0.12

var _prev_mouse: Vector2 = Vector2.ZERO
var _mouse_vel: Vector2 = Vector2.ZERO
var _mouse_init: bool = false
var _hit_timer: float = 0.0
@export var restitution: float = 0.95  # 0..1 (1 = rebond parfait, 0 = inélastique)


func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 8
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	_hit_timer = maxf(_hit_timer - delta, 0.0)

	# Spin continu
	#apply_torque(spin_torque)

	# Suivi souris désactivé pendant le hit-stun
	if _hit_timer <= 0.0:
		var mouse: Vector2 = get_global_mouse_position()
		if not _mouse_init:
			_prev_mouse = mouse
			_mouse_init = true

		_mouse_vel = (mouse - _prev_mouse) / maxf(delta, 0.000001)
		_prev_mouse = mouse

		var to_target: Vector2 = mouse - global_position
		var force: Vector2 = to_target * k_pos + _mouse_vel * k_vel - linear_velocity * lin_damping
		if force.length() > max_force:
			force = force.normalized() * max_force
		apply_force(force)

	# Clamp vitesse
	if linear_velocity.length() > max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed

	# Orientation
	if linear_velocity.length() > 0.01:
		rotation = linear_velocity.angle()

func _on_body_entered(other: Node) -> void:
	if other is RigidBody2D and other != self:
		var other_rb := other as RigidBody2D
		if other_rb == null:
			return

		# normale (de l'autre vers moi) — proche de la normale de contact
		var n: Vector2 = (global_position - other_rb.global_position).normalized()
		if n == Vector2.ZERO:
			return

		# vitesses actuelles
		var v1: Vector2 = linear_velocity
		var v2: Vector2 = other_rb.linear_velocity

		# vitesse relative projetée sur la normale
		var vrel_n: float = (v1 - v2).dot(n)

		# si déjà en séparation, ne pas "re-cogner"
		if vrel_n >= 0.0:
			return

		# masses (Godot 4: propriété mass directe)
		var m1: float = mass
		var m2: float = other_rb.mass

		# impulsion scalaire selon la conservation de quantité de mouvement + restitution
		var e: float = clampf(restitution, 0.0, 1.0)
		var j: float = - (1.0 + e) * vrel_n / (1.0/m1 + 1.0/m2)

		# appliquer l'impulsion (symétrique)
		var J: Vector2 = j * n
		apply_impulse(J * 2)               # à moi (direction n)
		other_rb.apply_impulse(-J)     # à l'autre (direction -n)

		# optionnel: un très bref "hit-stun" pour lisibilité, mais plus besoin de forcer la poussée
		_hit_timer = hit_stun
