extends Node2D


onready var node_top = $"top"
onready var node_bottom = $"bottom"
onready var node_tween = $"tween"

const colors = [Color("70D6FF"), Color("FF70B7"), Color("FFFFFF")]


func initialize(type, text, move_time = 0.0, jump_time = 1.0, jump = 96.0, move_destination = Vector2.ZERO, scale = 1.25):
	$"label".text = text
	node_top.frame = type
	node_bottom.frame = type
	node_top.self_modulate = colors[type]
	if type != 2: node_bottom.scale = Vector2(1.05, 1.05)
	
	var float_up_destination = global_position + Vector2.UP.rotated(rotation) * jump
	
	node_tween.interpolate_property(
		self, "global_position",
		global_position, float_up_destination, jump_time * 0.75,
		Tween.TRANS_QUAD, Tween.EASE_OUT
		)
	node_tween.interpolate_property(
		self, "scale",
		Vector2(0.6, 1.5) * scale, Vector2(1.3, 0.8) * scale, 0.25, 
		Tween.TRANS_QUAD, Tween.EASE_OUT
		)
	node_tween.interpolate_property(
		self, "scale",
		Vector2(1.3, 0.8) * scale, Vector2.ONE * scale, 0.25, 
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT, 0.25
		)
	
	if move_time > 0:
		node_tween.interpolate_property(
			self, "global_position",
			float_up_destination, move_destination, move_time,
			Tween.TRANS_QUAD, Tween.EASE_IN, jump_time
			)
	
	node_tween.interpolate_property(
		self, "scale",
		Vector2.ONE * scale, Vector2(2, 0) * scale, 0.25,
		Tween.TRANS_QUAD, Tween.EASE_OUT, jump_time + move_time
		)
	node_tween.interpolate_callback(
		$"sound", jump_time + move_time, "play"
	)
	node_tween.interpolate_callback(
		self, jump_time + move_time + 0.25, "queue_free"
	)
	
	node_tween.start()


func _process(delta):
	node_top.rotation -= delta * 2
	node_bottom.rotation += delta * 7
