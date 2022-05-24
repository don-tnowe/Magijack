extends "res://src/scenes/overlays/view_deck.gd"

var output_array : Array
var choices_min := 0
var choices_max := 1

var all_cards : Array
var condition : FuncRef
var picked_indices := []


func initialize(params):
	all_cards = params[0]
	$"title".text = params[1]
	output_array = params[2]
	choices_min = params[3]
	choices_max = params[4]
	if params.size() > 5: 
		condition = params[5] 
	
	var last_card_pos = Vector2()
	for i in params[0].size():
		var x = params[0][i]
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
		if condition == null || condition.call_func(x):
			node.connect("gui_input", self, "card_input", [i])
		
		else:
			node.modulate = Color(0.25, 0.25, 0.25, 1.0)

	node_card_container.rect_min_size.y = last_card_pos.y
	get_tree().paused = true
	update_picks()


func close():
	var picked_datas = []
	picked_datas.resize(picked_indices.size())
	for i in picked_indices.size():
		picked_datas[i] = all_cards[picked_indices[i]]
		
	output_array.append_array(picked_datas)
	.close()


func update_picks():
	while picked_indices.size() > choices_max:
		node_card_container.get_child(picked_indices.pop_front()).get_node("border").self_modulate = Color.black
		
	if choices_max == 1:
		$"choices_left".visible = false
	
	$"choices_left".text = tr("victory_choices_left") + str(choices_max - picked_indices.size())
	$"button_close".visible = picked_indices.size() >= choices_min


func card_input(event, idx):
	if event is InputEventMouseButton && event.is_pressed():
		if picked_indices.has(idx):
			node_card_container.get_child(idx).get_node("border").self_modulate = Color.black
			picked_indices.erase(idx)
			
		else:
			node_card_container.get_child(idx).get_node("border").self_modulate = Color.white
			picked_indices.append(idx)
		
		update_picks()
