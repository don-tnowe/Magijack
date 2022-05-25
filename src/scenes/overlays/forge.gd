extends OverlayBase

var choices_left = 5
var selected_card_data = []


func reopen_overlay():
	.reopen_overlay()
	update_gui()


func update_gui():
	$"button_upgrade1".visible = false
	$"button_upgrade2".visible = false
		
	if selected_card_data.size() > 0:
		$"card".visible = true
		selected_card_data[0].display_on_card_node($"card")
		
		if choices_left <= 0:
			$"choices_left".visible = false
			$"button_close/label".text = "menu_continue"
			$"button_close/label"._ready()
			return
		
		if can_upgrade1(selected_card_data[0]):
			$"button_upgrade1".visible = true
			$"button_upgrade1/desc2".text = str(selected_card_data[0].value) + " -> " + str(selected_card_data[0].value - 1)
			
		if can_upgrade2(selected_card_data[0]):
			$"button_upgrade2".visible = true
			$"button_upgrade2/desc2".text = "+" + str(selected_card_data[0].metal_value) + " -> +" + str(selected_card_data[0].metal_value + 1)
	
	$"choices_left".text = tr("victory_choices_left") + str(choices_left)


func choose_card():
	$"desc".visible = false
	selected_card_data.pop_back()
	OverlayStack.open("select_card", [
		BattlePlayer.data.deck.cards_parsed,
		"choose_card_title", selected_card_data, 0, 1,
		funcref(self, "can_any_upgrade")
		])


func can_any_upgrade(card):
	return can_upgrade1(card) || can_upgrade2(card)


func can_upgrade1(card):
	if card.special_index > 0: return false
	if card.value >= 11: return false
	if card.value <= 1: return false
	
	return true


func can_upgrade2(card):
	if card.special_index > 0: return false
	if card.value >= 10: return false
	
	return true


func upgrade1():
	if choices_left <= 0: return  # Just in case
	if !can_upgrade1(selected_card_data[0]): return
	selected_card_data[0].value -= 1
	choices_left -= 1
	$"anim".play("upgrade1")
	update_gui()


func upgrade2():
	if choices_left <= 0: return
	if !can_upgrade2(selected_card_data[0]): return
	selected_card_data[0].metal_value += 1
	choices_left -= 1
	$"anim".play("upgrade2")
	update_gui()
