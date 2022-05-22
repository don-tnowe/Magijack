extends Button

export(int, "Own run", "Own drawpile", "Enemy") var type := 0


func _on_button_deck_pressed():
	var params = null
	match type:
		0:
			params = [BattlePlayer.data.deck.cards_battle, "deckview_title"]
		1:
			params = [BattlePlayer.data.deck.cards_draw, "deckview_title_drawpile"]
		2:
			params = [BattleEnemy.data.deck.cards_battle, "deckview_title_enemy"]
			
	OverlayStack.open("view_deck", params)
