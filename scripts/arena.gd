extends Area2D

@export var restitution: float = 0.95
@export var snap_padding: float = 2.0

func _ready() -> void:
	body_exited.connect(_on_body_exited)

func _on_body_exited(body: Node) -> void:
	if not (body is RigidBody2D):
		return
	var rb := body as RigidBody2D

	var rect := ($CollisionShape2D.shape as RectangleShape2D)
	if rect == null:
		return
	var hx := rect.size.x * 0.5
	var hy := rect.size.y * 0.5

	# Position du body en local de l'arène
	var p_local := (rb.global_position - global_position).rotated(-global_rotation)

	# Détermine le côté le plus "débordé"
	var dx := p_local.x - clampf(p_local.x, -hx, hx)
	var dy := p_local.y - clampf(p_local.y, -hy, hy)

	var n_local := Vector2.ZERO
	if absf(dx) > absf(dy):
		n_local = Vector2( signf(dx), 0.0 )   # mur gauche/droite
	else:
		n_local = Vector2( 0.0, signf(dy) )   # mur bas/haut

	# Repose le body juste à l'intérieur
	var p_fix := p_local
	if n_local.x != 0.0:
		p_fix.x = signf(p_local.x) * (hx - snap_padding)
	if n_local.y != 0.0:
		p_fix.y = signf(p_local.y) * (hy - snap_padding)

	# Reconvertit en global
	var rot := global_rotation
	rb.global_position = global_position + p_fix.rotated(rot)

	# Normale en global
	var n_global := n_local.rotated(rot)

	# Réflexion de la vitesse sur la normale
	var v := rb.linear_velocity
	var vn := v.dot(n_global)
	if vn > 0.0:
		rb.linear_velocity = v - (1.0 + restitution) * vn * n_global
