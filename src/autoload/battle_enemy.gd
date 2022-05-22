extends Timer

signal card_drawn(card_just_drawn, hand, limit)
signal turn_ended(hand, limit_left, power)

var data : EnemyBattlerData
var hand_data := CardHandData.new()

var hp := 60
var limit_used := 0

var view_node : Control
var drawn_this_turn = 0


func _ready():
	BattlePlayer.connect("card_drawn", self, "player_card_drawn")
	BattlePlayer.connect("turn_ended", self, "player_turn_ended")


func battle_start():
	hp = data.hpmax
	var strgf = data.deck.stringified
	data.deck = CardDeck.new()
	data.deck.stringified = strgf
	data.deck.initialize()
	data.deck.battle_start()
	view_node.battle_start()


func draw_from_deck(face_up = false):
	var new_card = data.deck.draw_from_deck()
	view_node.node_hand.add_card(new_card, hand_data.add_card(new_card, data.limit), !face_up && drawn_this_turn >= data.cards_face_up)

	limit_used = hand_data.sum
	drawn_this_turn += 1

	emit_signal("card_drawn", new_card, hand_data, data.limit - limit_used)

	if drawn_this_turn > 2 && limit_used > data.limit:
		BattlePlayer.end_turn(true)
		end_turn(true)


func start_turn():
	hand_data.discard_all()
	view_node.node_hand.discard_all()

	drawn_this_turn = 0
	data.deck.turn_start()

	start(1.0)
	yield(self, "timeout")
	draw_from_deck()

	start(0.2)
	yield(self, "timeout")
	draw_from_deck()

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
	emit_signal("turn_ended", hand_data, data.limit - limit_used, hand_data.sum_power)
