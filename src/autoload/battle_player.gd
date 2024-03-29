extends Timer

signal card_drawn(card_just_drawn, hand, limit)
signal turn_started()
signal turn_ended(hand, limit_left, power)
signal new_spell_acquired()

var between_runs_data := preload("res://assets/other/player_characters/fool.tres")
var data : BattlerData
var state : BattlerState
var rival
var hand_data := CardHandData.new()

var hp := 60 setget set_hp
var limit_used := 0

var view_node : Control
var drawn_this_turn = 0


func _ready():
	randomize()
	state = BattlerState.new(self)
	rival = BattleEnemy
	BattleManager.connect("turn_started", self, "start_turn")


func run_start():
	state.clear()
	data = between_runs_data.duplicate()
	hp = data.hpmax

	data.deck = CardDeck.new()
	data.deck.stringified = between_runs_data.deck.stringified
	data.deck.initialize()

	if data.character_id == 2:  # If it's Artisan
		data.deck.random_sharpen(5)

	data.spells = data.spells.duplicate()


func battle_start():
	data.deck.battle_start()
	start_turn()


func battle_end():
	data.deck.battle_end()


func draw_from_deck():
	var new_card = data.deck.draw_from_deck()
	view_node.node_hand.add_card(new_card)
	
	drawn_this_turn += 1
	hand_changed()
	emit_signal("card_drawn", new_card, hand_data, data.limit - limit_used)

	if drawn_this_turn > 2 && limit_used > data.limit:
		view_node.overloaded()
		view_node.node_hand.discard_all(1)
		end_turn(true)


func discard_cards(cards):
	for x in cards:
		view_node.node_hand.discard_card(x)	
		
	hand_changed()


func discard_all():
	view_node.node_hand.discard_all()
	hand_changed()


func hand_changed():
	hand_data.modified_hand(data.limit)
	limit_used = hand_data.sum
	view_node.node_hand.display_all()
	view_node.update_hand()


func set_hp(v):
	view_node.taken_damage(hp - v)
	hp = v
	view_node.update_all()


func end_turn(forced = false):
	emit_signal("turn_ended", hand_data, data.limit - limit_used, hand_data.sum_power + data.power_bonus)
	view_node.update_hand()
	view_node.set_draw_available(false)
	view_node.set_endturn_available(false)


func start_turn():
	view_node.node_hand.discard_all()
	
	drawn_this_turn = 0
	data.deck.turn_start()
	emit_signal("turn_started")
	view_node.update_all()

	start(1.0)
	yield(self, "timeout")
	
	while true:
		draw_from_deck()
		if hand_data.cards.size() >= 2: break
		start(0.2)
		yield(self, "timeout")
	
	view_node.update_all()
	view_node.set_draw_available(true)
	view_node.set_endturn_available(true)


func add_spell(spell):
	data.spells.append(spell)
	emit_signal("new_spell_acquired")
