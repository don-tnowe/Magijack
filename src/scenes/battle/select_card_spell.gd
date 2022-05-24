extends ColorRect

onready var node_playerview := $".."
onready var node_handview := $"../hand"
onready var node_spellview := $"spell"

var choices_min := 1
var choices_max := 1

var spell_casting : SpellData
var picked_cards := []


func open(spell_data, spell_cost_params):
	visible = true
	spell_data.display_on_spell_node($"spell")
	spell_casting = spell_data

	choices_min = spell_cost_params[1]
	choices_max = spell_cost_params[2]
	
	for i in node_handview.used_card_nodes.size():
		var node = node_handview.used_card_nodes[i]
		if spell_data.card_selectable(node_handview.hand_data.cards[i]):
			node.connect("gui_input", self, "card_input", [node_handview.hand_data.cards[i], i])
		
		else:
			node.modulate = Color(0.25, 0.25, 0.25, 1.0)

	node_playerview.set_draw_available(false)
	node_playerview.set_endturn_available(false)
	get_tree().paused = true
	update_picks()


func submit():
	spell_casting.cast(BattlePlayer, picked_cards)
	node_playerview.update_all()
	close()


func cancel():
	node_playerview.update_all()
	close()


func close():
	visible = false
	for node in node_handview.used_card_nodes:
		node.modulate = Color.white
		node.get_node("border").self_modulate = Color.black


func update_picks():
	$"button_continue".visible = picked_cards.size() >= choices_min && spell_casting.can_cast_with_selection(picked_cards)


func card_input(event, card, idx):
	if event is InputEventMouseButton && event.is_pressed():
		if picked_cards.has(card):
			node_handview.used_card_nodes[idx].get_node("border").self_modulate = Color.black
			picked_cards.erase(card)
			
		elif picked_cards.size() < choices_max:
			node_handview.used_card_nodes[idx].get_node("border").self_modulate = Color.white
			picked_cards.append(card)
		
		update_picks()
