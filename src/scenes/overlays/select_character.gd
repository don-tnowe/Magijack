extends OverlayBase

export(Array, Resource) var characters
# so i made a field called "enemy_name" so i cant make a "player_name" because the class extends the other so enemies will have a player name too but i dont wanna eit places where its enemy_name
export(Array, Resource) var character_names = ["fool", "arsonist", "artisan"]

var selected_idx = -1


func _ready():
	for i in $"buttons".get_child_count():
		var node = $"buttons".get_child(i)
		node.connect("pressed", self, "select_option", [i])
		node.get_child(0).text = tr("char_" + character_names[i])
		node.get_child(0)._ready()


func select_option(idx):
	selected_idx = idx
	$"name".text = tr("char_" + character_names[idx])
	$"desc".text = tr("char_" + character_names[idx] + "_desc")
	if is_char_unlocked(idx):
		$"button_close".visible = true
		$"condition".text = ""
	
	else:
		$"button_close".visible = false
		$"condition".text = tr("char_" + character_names[idx] + "_req")
		
	BattlePlayer.data.deck = characters[selected_idx].deck
	BattlePlayer.data.deck.initialize()
	BattlePlayer.data.deck.battle_start()


func is_char_unlocked(idx):
	match idx:
		0:
			return true
		1:
			return Metaprogression.battles_completed_highscore >= 4
		2:
			return Metaprogression.artisan_unlocked


func close():
	BattlePlayer.between_runs_data = characters[selected_idx]
	BattleManager.run_start()
	.close()
