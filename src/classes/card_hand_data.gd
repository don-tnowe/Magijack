class_name CardHandData
extends Reference

export var sum := 0
export var sum_power := 0
export var cards := []


func add_card(card_data, limit) -> int:
  cards.append(card_data)
  calculate_sum(limit)
  return cards.size() - 1


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