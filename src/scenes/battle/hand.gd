extends Control

export var is_players = true
export var card_scene : PackedScene
export(Resource) var deck

var card_spacing := 64
var card_h_offset := 0
var card_selected_v_offset := -96
var card_selected_idx_to_offset := -32

var hand_data : CardHandData
var used_card_nodes = []
var selected_card_idx := -1


func _ready():
	for i in 32:
		var new_node = card_scene.instance()
		new_node.visible = false
		add_child(new_node)


func _process(delta):
	var selection_offset = 0 if selected_card_idx == -1 else card_selected_idx_to_offset * (selected_card_idx - used_card_nodes.size() * 0.5)
	for i in used_card_nodes.size():
		var selection_distance_offset = 48 * sign(i - selected_card_idx)  # Move cards away from selected card to see it better
		used_card_nodes[i].rect_position = lerp(
			used_card_nodes[i].rect_position,
			Vector2(
				i * card_spacing 
				- used_card_nodes.size() * 0.5 * card_spacing 
				+ card_h_offset 
				+ selection_offset 
				+ selection_distance_offset,
				card_selected_v_offset if selected_card_idx == i else 0
				) - used_card_nodes[i].rect_size * 0.5,
			0.2
		)


func add_card(card_data, new_idx, is_face_down = false):
	var new_node = find_unused_card()
	used_card_nodes.append(new_node)
	for x in used_card_nodes:
		x.raise()  # Keep 'em ordered.
	
	new_node.visible = true
	new_node.rect_position = Vector2(0, 256)
	new_node.set_face_down(is_face_down)

	if is_players:
		new_node.connect("mouse_entered", self, "card_mouse_entered", [new_idx])

	hand_data.cards[new_idx].display_on_card_node(new_node)
	selected_card_idx = -1


func find_unused_card():
	for x in get_children():
		if !x.visible: return x


func discard_card(card_idx, animation = 0):
	var node = used_card_nodes.pop_at(card_idx)
	if is_players:
		node.disconnect("mouse_entered", self, "card_mouse_entered")

	$"../tween".interpolate_property(
		node, "rect_position:y",
		node.rect_position.y, 512.0, 0.5,
		Tween.TRANS_BACK, Tween.EASE_IN
	)
	$"../tween".interpolate_property(
		node, "visible",
		true, false, 1
	)
	$"../tween".start()  # Didn't forget.	
	selected_card_idx = -1


func discard_all(animation = 0):
	for i in used_card_nodes.size():
		discard_card(0, animation)


func display_all():
	for i in get_child_count():
		hand_data.cards[i].display_on_card_node(get_child(i))


func reveal_all():
	for x in used_card_nodes:
		x.set_face_down(false)


func card_mouse_entered(card_idx):
	selected_card_idx = card_idx
