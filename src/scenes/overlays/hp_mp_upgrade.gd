extends OverlayBase

var upgrades_hp = 30
var upgrades_mp = 2


func _ready():
	upgrades_hp = BattlePlayer.data.hpmax + 30
	upgrades_mp = BattlePlayer.data.limit + 2
	$"choice1/numbers".text = str(BattlePlayer.data.hpmax) + " -> " + str(upgrades_hp)
	$"choice2/numbers".text = str(BattlePlayer.data.limit) + " -> " + str(upgrades_mp)
	$"choice3/numbers".text = str(BattlePlayer.hp) + " -> " + str(BattlePlayer.data.hpmax)


func choose1():
	BattlePlayer.data.hpmax = upgrades_hp
	close()


func choose2():
	BattlePlayer.data.limit = upgrades_mp
	close()


func choose3():
	BattlePlayer.hp = BattlePlayer.data.hpmax
	close()
