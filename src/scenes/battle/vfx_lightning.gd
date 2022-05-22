tool
extends Polygon2D

export var back_color = Color.cornflower
export var processing = true setget set_processing


func _process(delta):
	texture_offset.x -= 512.0 * delta
	$"lghtn".texture_offset.x = randf() * 682.65
	$"lghtn".color = back_color


func set_processing(v):
	processing = v
	visible = v
	texture_offset.x = randf() * 512.0
	set_process(v)
