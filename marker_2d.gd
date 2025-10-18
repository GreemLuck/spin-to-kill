extends Marker2D

func _process(delta):
	#look_at(get_global_mouse_position())
	rotate(get_angle_to(get_global_mouse_position()))
