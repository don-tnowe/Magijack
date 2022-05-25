class_name CardHandData
extends Reference

var sum := 0
var sum_power := 0
var cards := []


func add_card(card_data, limit) -> int:
	cards.append(card_data)
	modified_hand(limit)
	return cards.size() - 1


func discard_card(card, limit) -> int:
	var idx = cards.find(card)
	cards.remove(idx)
	modified_hand(limit)
	return idx


func discard_all():
	cards.clear()
	sum = 0
	sum_power = 0


func modified_hand(limit):
	calculate_sum(limit)


func calculate_sum(limit: int):
	sum = 0
	sum_power = 0

	var first_pass = []
	first_pass.resize(cards.size())

	for i in cards.size():
		first_pass[i] = cards[i].get_value(i, self, limit)
		sum += first_pass[i]

	for i in cards.size():  # Count again to account for "flawless" cards (1 if limit, 10 if not)
		sum -= first_pass[i]
		sum_power += cards[i].get_power(i, self, limit)
		sum += cards[i].get_value(i, self, limit)

