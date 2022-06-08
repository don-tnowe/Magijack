extends OverlayBase


export var card_size := Vector2()
export var cards_per_row := 18
export var cardview_scene : PackedScene

onready var node_card_container := $"ctr/ctr/ctr"


func initialize(params):
	var last_card_pos = Vector2()
	var dont_darken = params[2] if params.size() > 2 else null
	for x in params[0]:
		last_card_pos.x += card_size.x
		if last_card_pos.x > card_size.x * cards_per_row:
			last_card_pos.x = card_size.x
			last_card_pos.y += card_size.y

		var node = cardview_scene.instance()
		node_card_container.add_child(node)
		node.anchor_top = 0
		node.anchor_bottom = 0
		node.rect_position = last_card_pos
		x.display_on_card_node(node)
		
		if dont_darken != null && !dont_darken.has(x):
			node.modulate = Color(0.25, 0.25, 0.25, 1.0)

	node_card_container.rect_min_size.y = last_card_pos.y + card_size.y
	$"title".text = params[1]
	get_tree().paused = true
