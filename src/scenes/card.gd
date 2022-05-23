tool
extends Control

const suit_colors = [
	Color("d21414"),
	Color("1e37a9"),
	Color("5b2588"),
	Color("d9890d")
]

export var suit := 0 setget set_suit
export var value := 0 setget set_value
export var metal_value := 0 setget set_metal_value
export var is_face_down := false setget set_face_down


func _ready():
	set_suit(suit)
	set_value(value)
	set_metal_value(metal_value)


func set_suit(v):
	suit = v
	if get_child_count() == 0: return
		
	$"color".self_modulate = suit_colors[v]
	$"l/metal_value".self_modulate = suit_colors[v]
	$"l/suit".frame = v + 12
	if value == 11:
		$"special".frame = suit


func set_value(v):
	value = v
	if get_child_count() == 0: return
	
	if value == 11:
		$"special".frame = suit
		$"special".visible = true
		
	else:
		$"special".visible = false
		
	$"l/value".frame = v


func set_metal_value(v):
	metal_value = v
	if get_child_count() == 0: return
	
	if v > 0:
		$"l/metal_bg".visible = true
		$"l/metal_value".visible = true
		$"l/metal_value".frame = v

	else:
		$"l/metal_bg".visible = false
		$"l/metal_value".visible = false


func set_face_down(v):
	is_face_down = v
	$"back".visible = v
