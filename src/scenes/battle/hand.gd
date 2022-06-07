extends Control

export var is_players = true
export var card_scene : PackedScene

var card_spacing := 64
var card_h_offset := 0
var card_selected_v_offset := -96
var card_selected_idx_to_offset := -32

var owner_battler
var hand_data : CardHandData
var used_card_nodes = []
var selected_card_idx := -1


func _ready():
	for i in 32:
		var new_node = card_scene.instance()
		new_node.visible = false
		add_child(new_node)
	
	hand_data = (BattlePlayer if is_players else BattleEnemy).hand_data


func _process(delta):
	var selection_offset = 0 if selected_card_idx == -1 else card_selected_idx_to_offset * (selected_card_idx - used_card_nodes.size() * 0.5)
	for i in used_card_nodes.size():
		var selection_distance_offset = 48 * sign(i - selected_card_idx)  # Move cards away from selected card to see it better
		used_card_nodes[i].rect_position = lerp(
			used_card_nodes[i].rect_position,
			get_card_target_position(i, selection_offset + selection_distance_offset),
			0.2
		)


func get_card_target_position(card_idx, common_offset):
	return Vector2(
		card_idx * card_spacing 
		- used_card_nodes.size() * 0.5 * card_spacing 
		+ card_h_offset 
		+ common_offset,
		card_selected_v_offset if selected_card_idx == card_idx else 0
		) - used_card_nodes[card_idx].rect_size * 0.5


func add_card(card_data, is_face_down = false):
	var new_node = find_unused_card()
	var new_idx = hand_data.add_card(card_data, get_limit())
	used_card_nodes.append(new_node)
	for x in used_card_nodes:
		x.raise()  # Keep 'em ordered.
	
	new_node.visible = true
	new_node.rect_position = Vector2(-640, -128)
	new_node.rect_rotation = 0
	new_node.set_face_down(is_face_down)
	selected_card_idx = -1
	hand_data.cards[new_idx].display_on_card_node(new_node)
	
	$"../tween".interpolate_property(
		new_node, "rect_scale:x",
		0.2, 1, 0.5,
		Tween.TRANS_CUBIC, Tween.EASE_OUT
	)
	$"../tween".start()
	
	$"../sound_draw".pitch_scale = 0.5 * pow(2, hand_data.cards.size() / 6.0)
	$"../sound_draw".play()
		
	if is_players:
		new_node.connect("mouse_entered", self, "card_mouse_entered", [new_node])
		get_parent().added_card(
			get_card_target_position(new_idx, 0) + rect_global_position + Vector2(96, 48), 
			card_data.get_value(new_idx, hand_data, BattlePlayer.data.limit),
			card_data.get_power(new_idx, hand_data, BattlePlayer.data.limit)
			)
		
		if card_data.metal_value > 0:
			$"../sound_draw_sharpen".play()


func find_unused_card():
	for x in get_children():
		if !x.visible: return x


func discard_card(card_data, animation = 0):
	var idx = hand_data.discard_card(card_data, get_limit())
	discard_card_animation(idx, animation)


func discard_all(animation = 0):
	hand_data.discard_all()
	for i in used_card_nodes.size():
		discard_card_animation(0, animation)


func discard_card_animation(card_idx, animation = 0):
	var node = used_card_nodes.pop_at(card_idx)
	if is_players:
		node.disconnect("mouse_entered", self, "card_mouse_entered")
	
	match animation:
		0:
			$"../tween".interpolate_property(
				node, "rect_position:y",
				node.rect_position.y, 512.0, 0.5,
				Tween.TRANS_BACK, Tween.EASE_IN
			)
			$"../tween".interpolate_property(
				node, "visible",
				true, false, 1
			)
		1:
			$"../tween".interpolate_property(
				node, "rect_position:y",
				node.rect_position.y, 1024.0 + randf() * 1024.0, 1,
				Tween.TRANS_BACK, Tween.EASE_IN
			)
			$"../tween".interpolate_property(
				node, "rect_position:x",
				node.rect_position.x, node.rect_position.x + (randf() - 0.5) * 64.0, 0.75
			)
			$"../tween".interpolate_property(
				node, "rect_rotation",
				node.rect_rotation, (randf() - 0.5) * 1440.0, 0.75
			)
			$"../tween".interpolate_property(
				node, "visible",
				true, false, 1.5
			)
	$"../tween".start()  # Didn't forget.	
	selected_card_idx = -1


func display_all():
	for i in used_card_nodes.size():
		hand_data.cards[i].display_on_card_node(used_card_nodes[i])


func reveal_all():
	for x in used_card_nodes:
		x.set_face_down(false)


func card_mouse_entered(new_node):
	selected_card_idx = used_card_nodes.find(new_node)


func get_limit():
	return (BattlePlayer if is_players else BattleEnemy).data.limit
