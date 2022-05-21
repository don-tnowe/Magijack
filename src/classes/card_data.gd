class_name CardData
extends Resource

export var suit := 0
export var value := 0
export var metal_value := 0


func _init(s, v, mv):
	suit = s
	value = v
	metal_value = mv


func display_on_card_node(node):
	node.value = get_value()
	node.suit = suit
	node.metal_value = metal_value


func get_value(hand_data = null):
	if value == 11:
		if hand_data == null:
			return 11
		return 10 if hand_data.sum + 10 <= hand_data.limit else 1

	return value
