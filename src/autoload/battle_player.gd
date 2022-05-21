extends Node

var between_battles_data := preload("res://assets/other/player_characters/fool.tres")
var data : BattlerData
var hand_data := CardHandData.new()

var view_parent : Control setget set_view_parent
var node_hand : Control 
var node_bar_hp : Control 
var node_bar_limit : Control 


func battle_start():
	randomize()
	between_battles_data.deck.initialize()
	data = between_battles_data.duplicate()


func set_view_parent(v):
	battle_start()
	view_parent = v

	node_hand = v.get_node("hand")
	node_hand.hand_data = hand_data

	node_bar_hp = v.get_node("bar_hp")
	set_hp(data.hp)

	node_bar_limit = v.get_node("bar_mp")
	set_limit(0)

	v.get_node("button_draw").connect("pressed", self, "draw_from_deck")
	v.get_node("button_endturn").connect("pressed", self, "end_turn")


func draw_from_deck():
	var new_card = data.deck.draw_from_deck()
	node_hand.add_card(new_card, hand_data.add_card(new_card, data.limit))
	set_limit(hand_data.sum)


func end_turn():
	hand_data.discard_all()
	node_hand.discard_all()
	data.deck.turn_start()
	set_limit(0)
	yield(get_tree().create_timer(1), "timeout")
	draw_from_deck()
	set_limit(hand_data.sum)
	yield(get_tree().create_timer(0.2), "timeout")
	draw_from_deck()
	set_limit(hand_data.sum)


func set_limit(cur): 
	node_bar_limit.max_value = data.limit
	node_bar_limit.set_value(data.limit - cur)


func set_hp(v):
	data.hp = v
	node_bar_hp.max_value = data.hpmax
	node_bar_hp.set_value(data.hp)
