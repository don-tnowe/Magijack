class_name CardData
extends Resource

export var suit := 0
export var value := 0
export var metal_value := 0
export var special_index := 0


func _init(s, v, mv = 0, special = 0):
	suit = s
	value = v
	metal_value = mv
	special_index = special


func display_on_card_node(node):
	node.value = get_value()
	node.suit = suit
	node.metal_value = metal_value


func get_value(my_index = 0, hand_data = null, limit = -1):
	if value == 11:
		if hand_data == null:
			return 11
		return 10 if hand_data.sum + 10 <= limit else 1

	return value


func get_power(my_index = 0, hand_data = null, limit = -1):
	return get_value(my_index, hand_data, limit) + metal_value


func is_of_suit(suit_idx):
	return suit == suit_idx


func compare(a, b):
	if a.special_index > b.special_index: return true
	if a.suit < b.suit: return true
	if a.value > b.value: return true
	if a.metal_value > b.metal_value: return true
	
	return false
