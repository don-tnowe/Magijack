extends Control


func _process(delta):
	if $"../bar_mp".value == 0:
		$"../bar_mp/label".rect_position = Vector2(0, 32) + Vector2(
			randf() - 0.5,
			randf() - 0.5
		) * 8
