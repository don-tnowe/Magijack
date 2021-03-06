class_name SpellData
extends Resource


export var spell_id := 0

export var texture : Texture = preload("res://assets/graphics/spells.png")
export var texture_frame := 0

export var cost_min := 0
export var cost_max := 0

export var cooldown := 0
export var cooldown_start := 0

export(Script) var actions

var actions_instance


func _init():
	call_deferred("create_actions_instance")


func create_actions_instance():
	actions_instance = actions.new()
	actions_instance.spell_data = self


func display_on_spell_node(node):
	node.get_node("button/icon").texture = texture
	node.get_node("button/icon").frame = texture_frame
	node.get_node("button/cd_max").frame = cooldown
	
	var has_cooldown = cooldown != 0
	node.get_node("button/progress").max_value = cooldown if has_cooldown else 1
	node.get_node("button/cd_max").visible = has_cooldown
	node.get_node("button/cd_icon").visible = has_cooldown


func can_cast_with_hand(hand_data) -> bool:
	return actions_instance.can_cast_with_hand(hand_data)


func can_cast_with_selection(selection):
	return actions_instance.can_cast_with_selection(selection)


func card_selectable(card):
	return actions_instance.card_selectable(card)


func cast(caster, selected_cards = null):
	actions_instance.cast(caster, selected_cards)
	
