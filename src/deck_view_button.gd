extends GenericButton

export(int, "Own run", "Own drawpile", "Enemy") var type := 0


func button_pressed():
	.button_pressed()
	var params = null
	match type:
		0:
			params = [BattlePlayer.data.deck.cards_battle, "deckview_title", BattlePlayer.data.deck.cards_draw]
		1:
			params = [BattlePlayer.data.deck.cards_draw, "deckview_title_drawpile"]
		2:
			params = [BattleEnemy.data.deck.cards_battle, "deckview_title_enemy"]
			
	OverlayStack.open("view_deck", params)
