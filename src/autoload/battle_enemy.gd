extends Timer

signal card_drawn(card_just_drawn, hand, limit)
signal turn_ended(hand, limit_left, power)

var data
var state : BattlerState
var rival
var hand_data := CardHandData.new()

var hp := 60 setget set_hp
var limit_used := 0

var view_node : Control
var drawn_this_turn = 0


func _ready():
	BattleManager.connect("turn_started", self, "start_turn")
	BattlePlayer.connect("card_drawn", self, "player_card_drawn")
	BattlePlayer.connect("turn_ended", self, "player_turn_ended")
	rival = BattlePlayer
	state = BattlerState.new(self)


func set_enemy(enemy):
	data = enemy
	view_node.set_enemy(enemy)


func battle_start():
	state.clear()
	hp = data.hpmax

	var strgf = data.deck.stringified
	data.deck = CardDeck.new()
	data.deck.stringified = strgf
	data.deck.initialize()
	data.deck.battle_start()
	
	state.start_battle()
	start_turn()


func battle_end():
	data.deck.battle_end()


func draw_from_deck(face_up = false):
	var new_card = data.deck.draw_from_deck()
	view_node.node_hand.add_card(new_card, !face_up && drawn_this_turn >= data.cards_face_up)
	
	drawn_this_turn += 1
	hand_changed()
	emit_signal("card_drawn", new_card, hand_data, data.limit - limit_used)

	if drawn_this_turn > 2 && limit_used > data.limit:
		BattlePlayer.end_turn(true)
		end_turn(true)


func hand_changed():
	hand_data.modified_hand(data.limit)
	limit_used = hand_data.sum
	view_node.update_all()


func start_turn():
	view_node.node_hand.discard_all()

	drawn_this_turn = 0
	data.deck.turn_start()
	view_node.update_all()

	start(1.0)
	yield(self, "timeout")
	draw_from_deck()

	start(0.2)
	yield(self, "timeout")
	draw_from_deck()

	# Prevent confusing 2-turn-in-a-row insta-hits.
	if BattleManager.last_turn_outcome == BattleManager.TurnOutcome.ENEMY_OVERLOAD: return

	while randf() < data.start_draw_chance:
		start(0.2)
		yield(self, "timeout")
		if !try_safe_draw():
			break

# If diddn't draw, returns false.
func try_safe_draw(face_up = false) -> bool:
	var overload_chance = data.deck.get_crit_overload_chance(hand_data, data.limit)[1]
	if overload_chance > data.risk_max:
		return false
	
	if randf() < overload_chance * data.risk_chance_mult:
		return false
	
	draw_from_deck(face_up)
	return limit_used < data.limit


func player_card_drawn(card, hand, limit):
	if BattlePlayer.drawn_this_turn > 2 && randf() < data.player_draw_response_chance:
		try_safe_draw()


func set_hp(v):
	view_node.taken_damage(hp - v)
	hp = v
	view_node.update_all()
	if hp <= 0 && !BattleManager.player_turn_ended:
		BattleManager.last_turn_outcome = BattleManager.TurnOutcome.DEATH_BY_SPELL
		BattlePlayer.end_turn()


func player_turn_ended(hand, limit_left, power):
	view_node.node_hand.reveal_all()

	while randf() > data.end_draw_stop_chance:
		if limit_left <= 0: break
		if limit_used >= data.limit: break
		if !try_safe_draw(true): break
		start(0.5)
		yield(self, "timeout")
	
	end_turn()


func end_turn(forced = false):
	emit_signal("turn_ended", hand_data, data.limit - limit_used, hand_data.sum_power + data.power_bonus)
