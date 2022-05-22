extends Timer

signal card_drawn(card_just_drawn, hand, limit)
signal turn_ended(hand, limit_left, power)

var between_battles_data := preload("res://assets/other/player_characters/fool.tres")
var data : BattlerData
var hand_data := CardHandData.new()

var hp := 60
var limit_used := 0

var view_node : Control


func battle_start():
	randomize()
	between_battles_data.deck.initialize()
	data = between_battles_data.duplicate()
	view_node.update_all()


func draw_from_deck():
	var new_card = data.deck.draw_from_deck()
	view_node.node_hand.add_card(new_card, hand_data.add_card(new_card, data.limit))

	limit_used = hand_data.sum

	emit_signal("card_drawn", new_card, hand_data, data.limit - limit_used)
	view_node.update_hand()


func end_turn():
	emit_signal("turn_ended", hand_data, data.limit - limit_used, hand_data.sum_power)
	view_node.update_hand()
	view_node.set_draw_available(false)
	view_node.set_endturn_available(false)

	hand_data.discard_all()
	view_node.node_hand.discard_all()
	data.deck.turn_start()

	start(1.0)
	yield(self, "timeout")

	draw_from_deck()
	view_node.update_hand()

	start(0.2)
	yield(self, "timeout")

	draw_from_deck()
	view_node.update_hand()

	view_node.set_draw_available(true)
	view_node.set_endturn_available(true)
