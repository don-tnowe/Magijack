class_name OverlayBase
extends ColorRect


func initialize(params):
	pass


func reopen_overlay():
	visible = true
	get_tree().paused = true


func hide_overlay():
	visible = false
	get_tree().paused = false


func close():
	visible = false
	get_tree().paused = false
	OverlayStack.pop()
