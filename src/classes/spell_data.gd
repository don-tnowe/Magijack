class_name SpellData
extends Resource

var texture : Texture
var texture_frame := 0

var cooldown := 0
var cooldown_start := 0


func can_cast_with_hand(hand_data):
	return true


# Returns same as Select Card Spell node takes.
func get_cast_conditions(hand_data):
	return [
		hand_data,  # Hand data
		0,  # Minimum
		0  # Maximum
	]


func cast(caster, selected_cards = null):
	pass


func card_selectable(card):
	return true


func can_cast_with_selection(selection):
	return true
