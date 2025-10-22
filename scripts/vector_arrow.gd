@tool
extends Node2D
signal scale_updated
signal offset_updated

@onready var back_node = $Back
@onready var shaft_node = $Shaft
@onready var tip_node = $Tip

@export_range(0.01, 10.0) var arrow_scale: float = 1.0:
	set(new_arrow_scale):
		arrow_scale = new_arrow_scale
		scale_updated.emit(new_arrow_scale)
		
@export var arrow_offset: float = 0.0:
	set(new_offset):
		arrow_offset = new_offset
		offset_updated.emit(new_offset)

@export var color_ramp: Gradient

var back_original_x : float
var shaft_original_x : float
var tip_original_x : float
		
var previous_scale: float
var shaft_px : Vector2

func _ready():
	shaft_px = _sprite_rect_size(shaft_node)
	previous_scale = arrow_scale
	
	back_original_x = back_node.position.x
	shaft_original_x = shaft_node.position.x
	tip_original_x = tip_node.position.x
		
func update_scale(new_scale: float) -> void:
	arrow_scale = new_scale


func _update_color() -> void:
	var t = clamp(arrow_scale / 10.0, 0.0, 1.0)
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


func _on_scale_updated(new_scale: float) -> void:
	var scale_delta = new_scale - previous_scale
	if scale_delta != 0.0:
		var offset_x = shaft_px.x * scale_delta
		shaft_node.scale.x = new_scale;
		shaft_node.move_local_x(offset_x/2.0)
		tip_node.move_local_x(offset_x)
		_update_color()
		
		previous_scale = new_scale


func _on_offset_updated(new_offset: float) -> void:
	back_node.position.x = back_original_x + new_offset
	shaft_node.position.x = shaft_original_x + new_offset
	tip_node.position.x = tip_original_x + new_offset
