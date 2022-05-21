extends Control

export var card_scene : PackedScene
export(Resource) var deck

var card_spacing := 64
var card_h_offset := 64
var card_selected_v_offset := -96
var card_selected_idx_to_offset := -32

var hand_data : CardHandData
var selected_card_idx := -1


func _ready():
	BattlePlayer.view_parent = get_parent()
	for i in hand_data.cards.size():
		add_card(hand_data.cards[i], i)


func _process(delta):
	var count = get_child_count()
	var selection_offset = 0 if selected_card_idx == -1 else card_selected_idx_to_offset * (selected_card_idx - count * 0.5)
	for i in count:
		var selection_distance_offset = 48 * sign(i - selected_card_idx)  # Move cards away from selected card to see it better
		get_child(i).rect_position = lerp(
			get_child(i).rect_position,
			Vector2(
				i * card_spacing - count * 0.5 * card_spacing + card_h_offset + selection_offset + selection_distance_offset,
				card_selected_v_offset if selected_card_idx == i else 0
				) - get_child(i).rect_size * 0.5,
			0.2
		)


func add_card(card_data, new_idx):
	var new_node = card_scene.instance()
	add_child(new_node)
	new_node.rect_position = Vector2(0, 256)
	new_node.connect("mouse_entered", self, "card_mouse_entered", [new_idx])
	hand_data.cards[new_idx].display_on_card_node(new_node)


func display_all():
	for i in get_child_count():
		hand_data.cards[i].display_on_card_node(get_child(i))


func card_mouse_entered(card_idx):
	selected_card_idx = card_idx
