extends Control


func _ready():
	connect("mouse_entered", self, "mouse_entered")
	connect("mouse_exited", self, "mouse_exited")


func mouse_entered():
	TooltipDisplayer.show_unique_node_tooltip(self)


func mouse_exited():
	TooltipDisplayer.hide_tooltip(self)
