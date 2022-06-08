extends Label

export var margin := 16.0


func _ready():
	text = tr(text)  # Do it right now!!!
	rect_size.x = 0
	call_deferred("align_to_parent")


func align_to_parent():
	if rect_size.x > get_parent().rect_size.x - margin:
		rect_scale = ((get_parent().rect_size.x - margin) / rect_size.x) * Vector2.ONE
		rect_position.x = margin * 0.5
		
	else:
		rect_position.x = margin * 0.5 + (get_parent().rect_size.x - rect_size.x - margin) * 0.5
		
	rect_position.y = (get_parent().rect_size.y - rect_size.y * rect_scale.y) * 0.5
	
