extends Label

export var margin := 16.0


func _ready():
	call_deferred("align_to_parent")


func align_to_parent():
	if rect_size.x > get_parent().rect_size.x - margin:
		rect_scale = ((get_parent().rect_size.x - margin) / rect_size.x) * Vector2.ONE
		rect_position.x = margin * 0.5
		
	rect_position.y = (get_parent().rect_size.y - rect_size.y * rect_scale.y) * 0.5
	
