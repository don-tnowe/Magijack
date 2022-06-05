extends OverlayBase

var choices_left = 5
var selected_card_data = []


func reopen_overlay():
	.reopen_overlay()
	update_gui()


func update_gui():
	$"button_upgrade1".visible = false
	$"button_upgrade2".visible = false
	$"card".visible = false
	$"card2".visible = false
	$"card_count".visible = false
	
	if selected_card_data.size() > 0:
		$"card".visible = true
		selected_card_data[0].display_on_card_node($"card")
		
		if selected_card_data.size() > 1:
			$"card2".visible = true
			selected_card_data[1].display_on_card_node($"card2")
			$"card_count".visible = true
			$"card_count".text = "x" + str(selected_card_data.size())
		
		if choices_left <= 0:
			$"choices_left".visible = false
			$"button_close/label".text = "menu_continue"
			$"button_close/label"._ready()
			return
		
		var can_upgrade_count = [0, 0]
		
		for x in selected_card_data:
			if can_upgrade(x, 0):
				can_upgrade_count[0] += 1
			
			if can_upgrade(x, 1):
				can_upgrade_count[1] += 1
		
		if can_upgrade_count[0] > 0:
			$"button_upgrade1".visible = true
			$"button_upgrade1/desc2".text = str(selected_card_data[0].value) + " -> " + str(selected_card_data[0].value - 1)
			
		if can_upgrade_count[1] > 0:
			$"button_upgrade2".visible = true
			$"button_upgrade2/desc2".text = "+" + str(selected_card_data[0].metal_value) + " -> +" + str(selected_card_data[0].metal_value + 1)
	
	$"choices_left".text = tr("victory_choices_left") + str(choices_left)


func choose_card():
	$"desc".visible = false
	OverlayStack.open("select_card", [
		BattlePlayer.data.deck.cards_parsed,
		"choose_card_title", selected_card_data, 0, choices_left,
		funcref(self, "can_any_upgrade")
		])


func can_any_upgrade(card):
	return can_upgrade(card, 0) || can_upgrade(card, 1)


func can_upgrade(card, upgrade_type_idx):
	if choices_left <= 0: return false
	if card.special_index > 0: return false
	if upgrade_type_idx == 0:
		if card.value >= 11: return false
		if card.value <= 1: return false
		
		return true
	
	if card.metal_value >= 10: return false
	
	return true


func upgrade(upgrade_type_idx):
	if choices_left <= 0: return  # Just in case
	
	for x in selected_card_data:
		if !can_upgrade(x, upgrade_type_idx):
			continue
		
		choices_left -= 1
		if upgrade_type_idx == 0:
			x.value -= 1
			
		else:
			x.metal_value += 1
	
	$"anim".play("upgrade" + str(upgrade_type_idx))
	$"anim".seek(0)
	update_gui()

