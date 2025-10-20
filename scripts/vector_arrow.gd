@tool
extends Node2D

@onready var back_node = $Back
@onready var shaft_node = $Shaft
@onready var tip_node = $Tip

@export_range(0.01, 10.0) var arrow_scale: float = 1.0
@export var color_ramp: Gradient
		
var previous_scale: float
var shaft_px : Vector2

func _ready():
	shaft_px = _sprite_rect_size(shaft_node)
	previous_scale = arrow_scale
	print(shaft_px)

func _process(delta):
	
	# Moves the shaft and arrow tip based on the difference in scale between changes
	var scale_delta = arrow_scale - previous_scale
	if scale_delta != 0.0:
		var offset_x = shaft_px.x * scale_delta
		shaft_node.scale.x = arrow_scale;
		shaft_node.move_local_x(offset_x/2.0)
		tip_node.move_local_x(offset_x)
		_update_color(arrow_scale)
		
		previous_scale = arrow_scale
		print(shaft_node.texture.get_size())
		
func _update_color(scale:float) -> void:
	var t = clamp(scale / 10.0, 0.0, 1.0)
	var col = color_ramp.sample(t)
	$Back.modulate = col
	$Shaft.modulate = col
	$Tip.modulate = col


func _sprite_rect_size(s: Sprite2D) -> Vector2:
	var rect = s.get_rect()
	if rect == null:
		return Vector2.ZERO
	var base = rect.size
	if s.region_enabled:
		base = s.region_rect.size
	return base
