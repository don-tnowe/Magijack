extends OverlayBase


func reopen_overlay():
	.reopen_overlay()
	BattleEnemy.data = BattleEnemy.data.duplicate()
	BattleManager.battle_start()
	close()
