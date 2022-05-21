class_name EnemyBattlerData
extends BattlerData

# For the enemy to draw more cards, the percentage of cards that would bust them must be less than this.
export var risk_max := 0.25
# If the percentage is lower than risk_max, multiply by this and get the chance to draw.
export var risk_chance_mult := 1.0
# Chance to draw once the player draws. Enemies always draw as much as they can at the end of turn.
export var player_draw_response_chance := 1.0
# The first X cards drawn are revealed to player. The rest require using vision spells.
export var cards_face_up := 2
# YOUR first X cards drawn are revealed to enemy. The rest can still be seen using vision spells.
export var player_cards_face_up := 0
