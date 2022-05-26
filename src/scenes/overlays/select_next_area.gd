extends OverlayBase


export(Resource) var enemy_pool


func reopen_overlay():
	.reopen_overlay()
	close()


func close():
	var level = BattleManager.battles_completed
	var enemy = enemy_pool.get_random_enemy(level, BattleManager.enemy_encounter_count).duplicate()

	BattleManager.enemy_encounter_count[enemy.enemy_name] = BattleManager.enemy_encounter_count.get(enemy.enemy_name, 0) + 1

	# TODO: add more enemy types so this is irrelevant
	enemy.hpmax += floor(enemy.hpmax * (level * 0.1))
	enemy.damage += floor(enemy.damage * (level * 0.15))
	enemy.greed_damage += floor(enemy.greed_damage * (level * 0.05))
	enemy.limit += floor(level * 0.25)

	enemy.spells = enemy.spells.duplicate()

	BattleEnemy.set_enemy(enemy)
	BattleManager.battle_start()
	.close()

