extends OverlayBase


var selected_card_data := []
var healing := 0
var removals := 0


func _ready():
	healing = min(ceil(BattlePlayer.data.hpmax * 0.33), BattlePlayer.data.hpmax - BattlePlayer.hp)
	removals = min(3, BattlePlayer.data.deck.cards_parsed.size() - 3)

	$"choice1/desc".text = tr("bonfire_heal_desc") % healing
	$"choice2/desc".text = tr("bonfire_remove_card_desc") % removals


func choose1():
	BattlePlayer.hp += healing
	close()


func choose2():
	selected_card_data.resize(0)
	OverlayStack.open("select_card", [
		BattlePlayer.data.deck.cards_parsed,
		"bonfire_remove_card_title", selected_card_data, 
		0, removals
		])


func reopen_overlay():
	.reopen_overlay()
	if selected_card_data.size() > 0:
		BattlePlayer.data.deck.remove_cards(selected_card_data)
		close()
