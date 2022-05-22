extends Timer


var player_hand : CardHandData
var player_limit_left := 0
var player_hand_power := 0
var player_turn_ended := false

var enemy_hand : CardHandData
var enemy_limit_left := 0
var enemy_hand_power := 0
var enemy_turn_ended := false

func _ready():
	BattlePlayer.connect("turn_ended", self, "player_turn_ended")
	BattleEnemy.connect("turn_ended", self, "enemy_turn_ended")
	call_deferred("battle_start")


func battle_start():
	BattlePlayer.battle_start()
	BattlePlayer.start_turn()
	
	BattleEnemy.battle_start()
	BattleEnemy.start_turn()


func player_turn_ended(hand, limit_left, power):
	player_hand = hand 
	player_limit_left = limit_left 
	player_hand_power = power 
	player_turn_ended = true
	
	if enemy_turn_ended:
		apply_turn_outcome()


func enemy_turn_ended(hand, limit_left, power):
	enemy_hand = hand 
	enemy_limit_left = limit_left 
	enemy_hand_power = power 
	enemy_turn_ended = true

	if player_turn_ended:
		apply_turn_outcome()


func apply_turn_outcome():
	if enemy_limit_left < 0:
		BattleEnemy.hp -= BattlePlayer.data.greed_damage

	elif player_limit_left < 0:
		BattlePlayer.hp -= BattleEnemy.data.greed_damage

	elif player_hand_power > enemy_hand_power:
		BattleEnemy.hp -= BattlePlayer.data.damage
		if player_limit_left == 0:  # If at limit, crit. Enemies can't crit, for fairness.
			BattleEnemy.hp -= BattlePlayer.data.damage
	
	if player_hand_power < enemy_hand_power:
		BattlePlayer.hp -= BattleEnemy.data.damage

	BattlePlayer.view_node.update_all()
	BattleEnemy.view_node.update_all()
	player_turn_ended = false
	enemy_turn_ended = false
	BattlePlayer.start_turn()
	BattleEnemy.start_turn()
