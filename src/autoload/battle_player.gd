extends Timer

signal card_drawn(card_just_drawn, hand, limit)
signal turn_ended(hand, limit_left, power)

var between_runs_data := preload("res://assets/other/player_characters/fool.tres")
var data : BattlerData
var state : BattlerState
var rival
var hand_data := CardHandData.new()

var hp := 60
var limit_used := 0

var view_node : Control
var drawn_this_turn = 0


func _ready():
	randomize()
	run_start()
	rival = BattleEnemy


func run_start():
	state = BattlerState.new(self)

	data = between_runs_data.duplicate()
	hp = data.hpmax

	data.deck = CardDeck.new()
	data.deck.stringified = between_runs_data.deck.stringified
	data.deck.initialize()

	data.spells = data.spells.duplicate()


func battle_start():
	view_node.update_all()
	data.deck.battle_start()
	start_turn()


func battle_end():
	pass


func draw_from_deck():
	var new_card = data.deck.draw_from_deck()
	view_node.node_hand.add_card(new_card)
	
	limit_used = hand_data.sum
	drawn_this_turn += 1

	emit_signal("card_drawn", new_card, hand_data, data.limit - limit_used)
	view_node.update_hand()

	if drawn_this_turn > 2 && limit_used > data.limit:
		view_node.overloaded()
		view_node.node_hand.discard_all(1)
		end_turn(true)


func end_turn(forced = false):
	emit_signal("turn_ended", hand_data, data.limit - limit_used, hand_data.sum_power)
	view_node.update_hand()
	view_node.set_draw_available(false)
	view_node.set_endturn_available(false)


func start_turn():
	if BattleManager.last_turn_outcome != BattleManager.TurnOutcome.PLAYER_OVERLOAD:
		view_node.node_hand.discard_all()
	
	drawn_this_turn = 0
	state.start_turn()
	data.deck.turn_start()

	start(1.0)
	yield(self, "timeout")
	draw_from_deck()

	start(0.2)
	yield(self, "timeout")
	draw_from_deck()

	view_node.set_draw_available(true)
	view_node.set_endturn_available(true)
