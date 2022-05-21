class_name CardHandData
extends Reference

export var sum := 0
export var limit := 16
export var cards := []


func add_card(card_data) -> int:
  cards.append(card_data)
  calculate_sum(limit)
  return cards.size() - 1


func calculate_sum(with_limit: int):
  limit = with_limit
  sum = 0
  for x in cards:
    sum += x.get_value()