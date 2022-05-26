extends "res://src/scenes/overlays/victory_card.gd"


export(Resource) var companion_call_spell


func update_picks():
	$"button_close".disabled = picked.size() != 1


func button_pressed():
	var card = choices[picked[0]]
	Metaprogression.companion_card = card
	Metaprogression.companion_card_stringified = (
		str(CardDeck.suit_names[card.suit])
		+ " " + str(card.value if card.value != 11 else "flawless")
		+ (" +" + str(card.metal_value) if card.metal_value > 0 else "")
	)
	BattlePlayer.add_spell(companion_call_spell)
	BattlePlayer.battle_start()
	.close()
