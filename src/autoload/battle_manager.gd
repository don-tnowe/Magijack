extends Timer

enum TurnOutcome { 
	ENEMY_OVERLOAD,
	PLAYER_OVERLOAD,
	PLAYER_CRIT,
	PLAYER_WIN,
	ENEMY_WIN,
	DRAW,
	DEATH_BY_SPELL
	}

signal turn_started()
signal battle_started()
signal battle_ended()

var battles_completed := 0
var area_features := ["hp_mp_upgrade", "library", "forge"]
var area_progress := 0

var player_hand : CardHandData
var player_limit_left := 0
var player_hand_power := 0
var player_turn_ended := false

var enemy_hand : CardHandData
var enemy_limit_left := 0
var enemy_hand_power := 0
var enemy_turn_ended := false

var last_turn_outcome := -1
var view_node : Control

var enemy_encounter_count = {}


func _ready():
	BattlePlayer.connect("turn_ended", self, "player_turn_ended")
	BattleEnemy.connect("turn_ended", self, "enemy_turn_ended")
	connect("battle_started", BattlePlayer, "battle_start")
	connect("battle_started", BattleEnemy, "battle_start")
	connect("battle_ended", BattlePlayer, "battle_end")
	connect("battle_ended", BattleEnemy, "battle_end")

	call_deferred("run_start")


func run_start():
	enemy_encounter_count = {}
	battles_completed = 0
	BattlePlayer.run_start()
	OverlayStack.open("select_next_area")
	OverlayStack.stack[OverlayStack.stack.size() - 1].close()


func battle_start():
	emit_signal("battle_started")


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
	if last_turn_outcome == TurnOutcome.DEATH_BY_SPELL:
		pass

	elif enemy_limit_left < 0:
		BattleEnemy.hp -= max(BattlePlayer.data.greed_damage, 0)
		view_node.enemy_overload(-enemy_limit_left, BattleEnemy.data.limit)
		last_turn_outcome = TurnOutcome.ENEMY_OVERLOAD

	elif player_limit_left < 0:
		BattlePlayer.hp -= max(BattleEnemy.data.greed_damage, 0)
		view_node.player_overload(-player_limit_left, BattlePlayer.data.limit)
		last_turn_outcome = TurnOutcome.PLAYER_OVERLOAD

	elif player_limit_left == 0:  # If at limit, guaranteed hit with x2 damage. Enemies can't crit, for fairness.
		BattleEnemy.hp -= max(BattlePlayer.data.damage * 2, 0)
		view_node.player_crit()
		last_turn_outcome = TurnOutcome.PLAYER_CRIT

	elif player_hand_power > enemy_hand_power:
		BattleEnemy.hp -= max(BattlePlayer.data.damage, 0)
		view_node.player_win(player_hand_power, enemy_hand_power)
		last_turn_outcome = TurnOutcome.PLAYER_WIN
	
	elif player_hand_power < enemy_hand_power:
		BattlePlayer.hp -= max(BattleEnemy.data.damage, 0)
		view_node.enemy_win(player_hand_power, enemy_hand_power)
		last_turn_outcome = TurnOutcome.ENEMY_WIN

	else:
		view_node.tie(player_hand_power, enemy_hand_power)
		last_turn_outcome = TurnOutcome.DRAW
		
	player_turn_ended = false
	enemy_turn_ended = false

	if BattleEnemy.hp <= 0:
		victory()
		return

	if BattlePlayer.hp <= 0:
		defeat()
		return

	emit_signal("turn_started")


func victory():
	emit_signal("battle_ended")
	start(2)
	yield(self, "timeout")

	if BattleEnemy.data.enemy_name == "owleer": Metaprogression.artisan_unlocked = true

	OverlayStack.open("select_next_area")

	if area_progress >= 3:
		OverlayStack.open("bonfire")
		area_progress = 0
		area_features.shuffle()

	else:
		OverlayStack.open(area_features[area_progress])
		area_progress += 1

	OverlayStack.open("victory_card", [BattleEnemy.data])
	battles_completed += 1


func defeat():
	emit_signal("battle_ended")
	start(2)
	yield(self, "timeout")
#	OverlayStack.open("select_next_area")
	OverlayStack.open("select_companion_card", [BattleEnemy.data])
	OverlayStack.open("select_character")
	OverlayStack.open("defeat")
	Metaprogression.run_ended()
