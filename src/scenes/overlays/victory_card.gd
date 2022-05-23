extends OverlayBase

onready var node_card_parent := $"cards"

var card_width := 161.0

var enemy_data
var choices = []
var picked = []

func initialize(params):
	enemy_data = params[0]
	var card = node_card_parent.get_child(0)
	node_card_parent.remove_child(card)
	var choice_count = enemy_data.loot_choice_min + randi() % (enemy_data.loot_choice_max - enemy_data.loot_choice_min + 1)
	var stringified_cards = Array(enemy_data.loot_cards.split("\n"))
	stringified_cards.shuffle()
	
	for i in choice_count:
		var new_card = card.duplicate()
		node_card_parent.add_child(new_card)
		new_card.rect_position.x = i * card_width - (choice_count - 1) * card_width * 0.5
		new_card.connect("gui_input", self, "card_input", [i])
		choices.append(enemy_data.deck.create_stringified_card(stringified_cards[i]))
		choices[i].display_on_card_node(new_card)
		
	update_picks()
	card.queue_free()


func card_input(event, idx):
	if event is InputEventMouseButton && event.is_pressed():
		if picked.has(idx):
			node_card_parent.get_child(idx).get_node("border").self_modulate = Color.black
			picked.erase(idx)
			
		else:
			node_card_parent.get_child(idx).get_node("border").self_modulate = Color.white
			picked.append(idx)
		
		update_picks()


func update_picks():
	$"choices_left".text = tr("victory_choices_left") + str(enemy_data.loot_player_choice - picked.size())
	$"button_close".disabled = picked.size() > enemy_data.loot_player_choice


func button_pressed():
	var picked_datas = []
	picked_datas.resize(picked.size())
	for i in picked.size():
		picked_datas[i] = choices[picked[i]]
	
	BattlePlayer.data.deck.add_cards(picked_datas)
	.close()
