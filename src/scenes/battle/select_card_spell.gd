extends ColorRect

onready var node_playerview := $".."
onready var node_handview := $"../hand"
onready var node_spellview := $"spell"

var spell_casting : SpellData
var spell_idx_in_list := -1
var picked_cards := []


func open(spell_data, spell_idx):
	visible = true
	spell_data.display_on_spell_node($"spell")
	spell_casting = spell_data
	spell_idx_in_list = spell_idx
	
	for i in node_handview.used_card_nodes.size():
		var node = node_handview.used_card_nodes[i]
		if spell_data.card_selectable(node_handview.hand_data.cards[i]):
			node.connect("gui_input", self, "card_input", [node_handview.hand_data.cards[i], i])
		
		else:
			node.modulate = Color(0.25, 0.25, 0.25, 1.0)

	picked_cards = []
	node_playerview.set_draw_available(false)
	node_playerview.set_endturn_available(false)
	update_picks()


func submit():
	close()
	spell_casting.cast(BattlePlayer, picked_cards)
	BattlePlayer.state.spell_cooldowns[spell_idx_in_list] = spell_casting.cooldown
	$"../spells".update_cooldowns()
	
	node_playerview.update_all()


func cancel():
	close()
	node_playerview.update_all()


func close():
	visible = false
	node_playerview.set_endturn_available(true)
	for node in node_handview.used_card_nodes:
		node.disconnect("gui_input", self, "card_input")
		node.modulate = Color.white
		node.get_node("border").self_modulate = Color.black


func update_picks():
	$"button_continue".disabled = !(picked_cards.size() >= spell_casting.cost_min && spell_casting.can_cast_with_selection(picked_cards))


func card_input(event, card, idx):
	if event is InputEventMouseButton && event.is_pressed():
		if picked_cards.has(card):
			node_handview.used_card_nodes[idx].get_node("border").self_modulate = Color.black
			picked_cards.erase(card)
			
		elif picked_cards.size() < spell_casting.cost_max:
			node_handview.used_card_nodes[idx].get_node("border").self_modulate = Color.white
			picked_cards.append(card)
		
		update_picks()


func icon_mouse_entered():
	TooltipDisplayer.show_spell_tooltip(node_spellview, spell_casting.spell_id)
	
	
func icon_mouse_exited():
	TooltipDisplayer.hide_tooltip()
