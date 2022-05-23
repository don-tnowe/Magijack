extends Control

export(Array, Texture) var mpbar_textures

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
	
	var crit_overload_chance = BattlePlayer.data.deck.get_crit_overload_chance(BattlePlayer.hand_data, BattlePlayer.data.limit)
	node_chance_crit.text = str(floor(crit_overload_chance[0] * 100)) + "%"
	node_chance_overload.text = str(ceil(crit_overload_chance[1] * 100)) + "%"
	
	node_bar_mp.texture = mpbar_textures[0 if crit_overload_chance[1] == 0.0 else 1 if crit_overload_chance[1] < 0.5 else 2]
	set_draw_available(BattlePlayer.drawn_this_turn >= 2 && crit_overload_chance[1] < 1.0 && BattlePlayer.data.deck.cards_draw.size() > 0)


func update_all():
	update_hand()
	node_bar_hp.max_value = BattlePlayer.data.hpmax
	node_bar_hp.set_value(BattlePlayer.hp)
	node_label_damage.text = str(BattlePlayer.data.damage)
	node_label_greeddamage.text = str(BattlePlayer.data.greed_damage)


func overloaded():
	node_hand.discard_all(1)
	set_endturn_available(false)


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
