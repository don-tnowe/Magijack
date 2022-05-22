extends Control


onready var node_hand = $"hand"

onready var node_bar_hp = $"bar_hp"
onready var node_bar_mp = $"bar_mp"
onready var node_chance_crit = $"label_chance_crit"
onready var node_chance_overload = $"label_chance_overload"

onready var node_label_damage = $"label_damage"
onready var node_label_greeddamage = $"label_greeddamage"

onready var node_button_draw = $"button_draw"
onready var node_button_endturn = $"button_endturn"


func _ready():
	BattlePlayer.view_node = self
	node_hand.hand_data = BattlePlayer.hand_data
	node_button_draw.connect("pressed", BattlePlayer, "draw_from_deck")
	node_button_endturn.connect("pressed", BattlePlayer, "end_turn")


# Frick it, not creating a setter for each field for the jam
func update_hand():
	node_bar_mp.max_value = BattlePlayer.data.limit
	node_bar_mp.set_value(BattlePlayer.data.limit - BattlePlayer.limit_used)
	node_chance_crit.text = str(0.15 * 100) + "%"  # TODO
	node_chance_overload.text = str(0.55 * 100) + "%"  # Also TODO


func update_all():
	update_hand()
	node_bar_hp.max_value = BattlePlayer.data.hpmax
	node_bar_hp.set_value(BattlePlayer.hp)
	node_label_damage.text = str(BattlePlayer.data.damage)
	node_label_greeddamage.text = str(BattlePlayer.data.greed_damage)


func set_draw_available(v):
	node_button_draw.disabled = !v


func set_endturn_available(v):
	node_button_endturn.disabled = !v


func _process(delta):
	if node_bar_mp.value == 0:
		node_bar_mp.get_node("label").rect_position = Vector2(0, 32) + Vector2(
			randf() - 0.5,
			randf() - 0.5
		) * 8
