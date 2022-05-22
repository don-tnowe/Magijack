class_name EnemyBattlerData
extends BattlerData

# For the enemy to draw more cards, the percentage of cards that would bust them must be less than this.
export var risk_max := 0.25
# If the percentage is lower than risk_max, multiply by this and get the chance to draw.
export var risk_chance_mult := 1.0
# Chance to draw at the start of turn. After that, attempt to draw with this chance again.
export var start_draw_chance := 0.2
# Chance to draw once the player draws.
export var player_draw_response_chance := 1.0
# Enemies always draw as much as they can at the end of turn until this roll succeeds.
export var end_draw_stop_chance := 0.0
# The first X cards drawn are revealed to player. The rest require using vision spells.
export var cards_face_up := 2
# YOUR first X cards drawn are revealed to enemy. The rest can still be seen using vision spells.
export var player_cards_face_up := 0

# Levels this appears on.
export var min_level := 0
export var max_level := 8
export var recommended_level := 1

# Returns the difficulty it will be on this level. Make sure to present low (< 0) and high (> 0) choices.
func get_difficulty(on_level):
	if min_level > on_level:
		return -999  # Too easy

	if max_level < on_level:
		return 999  # Too hard

	return recommended_level - on_level
