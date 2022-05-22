extends Timer


func _ready():
	call_deferred("battle_start")


func battle_start():
	BattlePlayer.battle_start()
