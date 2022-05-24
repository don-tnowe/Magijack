class_name SpellActions
extends Reference

var spell_data


func can_cast_with_hand(hand_data) -> bool:
	return true


func can_cast_with_selection(selection):
	return true


func card_selectable(card):
	return true


func cast(caster, selected_cards = null):
	return
