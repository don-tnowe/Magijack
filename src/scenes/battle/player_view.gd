extends Control

export(Array, Texture) var mpbar_textures
export(PackedScene) var bubble

onready var node_hand = $"hand"
onready var node_spells = $"spells"

onready var node_bar_hp = $"bar_hp"
onready var node_bar_mp = $"bar_mp"
onready var node_label_power = $"label_power"
onready var node_chance_crit = $"label_chance_crit"
onready var node_chance_overload = $"label_chance_overload"

onready var node_label_damage = $"label_damage"
onready var node_label_greeddamage = $"label_greeddamage"

onready var node_button_draw = $"button_draw"
onready var node_button_endturn = $"button_endturn"
onready var node_crit_draw_warning = $"crit_draw_warning"


func _ready():
	BattlePlayer.view_node = self
	node_hand.hand_data = BattlePlayer.hand_data
	call_deferred("connect_signals")


func connect_signals():
	node_button_draw.connect("pressed", self, "draw_from_deck")
	node_button_endturn.connect("pressed", self, "end_turn")
	node_crit_draw_warning.get_node("button").connect("pressed", self, "draw_from_deck")


func end_turn():
	node_crit_draw_warning.visible = false
	BattlePlayer.end_turn()


func draw_from_deck():
	if BattlePlayer.limit_used >= BattlePlayer.data.limit && !node_crit_draw_warning.visible:
		set_draw_available(false)
		node_crit_draw_warning.visible = true
		return
	
	node_crit_draw_warning.visible = false
	BattlePlayer.draw_from_deck()


func update_hand():
	node_bar_mp.max_value = BattlePlayer.data.limit
	node_bar_mp.set_value(BattlePlayer.data.limit - BattlePlayer.limit_used)
	
	node_label_power.text = str(BattlePlayer.hand_data.sum_power)
	if BattlePlayer.data.power_bonus > 0:
		node_label_power.text += "+" + str(BattlePlayer.data.power_bonus)
	
	var crit_overload_chance = BattlePlayer.data.deck.get_crit_overload_chance(BattlePlayer.hand_data, BattlePlayer.data.limit)
	node_chance_crit.text = str(floor(crit_overload_chance[0] * 100)) + "%"
	node_chance_overload.text = str(ceil(crit_overload_chance[1] * 100)) + "%"
	
	node_bar_mp.texture = mpbar_textures[0 if crit_overload_chance[1] == 0.0 else 1 if crit_overload_chance[1] < 0.5 else 2]
	node_spells.casting_available = BattlePlayer.drawn_this_turn >= 2
	set_draw_available(BattlePlayer.data.deck.cards_draw.size() > 0)


func update_all():
	update_hand()
	node_bar_hp.max_value = BattlePlayer.data.hpmax
	node_bar_hp.set_value(BattlePlayer.hp)
	node_label_damage.text = str(BattlePlayer.data.damage)
	node_label_greeddamage.text = str(BattlePlayer.data.greed_damage)


func overloaded():
	set_endturn_available(false)


func set_draw_available(v):
	node_button_draw.disabled = !v


func set_endturn_available(v):
	node_button_endturn.disabled = !v
	if !v: 
		node_spells.casting_available = false


func added_card(start_pos, amount, power_amount):
	var node = bubble.instance()
	var node2 = bubble.instance()
	
	add_child(node2)
	add_child(node)
	
	if amount == power_amount:
		node.global_position = start_pos + Vector2(24, 0)
		node2.global_position = start_pos + Vector2(24, 0)
		
	else:
		node.global_position = start_pos
		node2.global_position = start_pos + Vector2(48, 0)
		node.rotation_degrees -= 15
		node2.rotation_degrees += 5
		
	node.initialize(0, str(amount), 0.5, 0.7, 120, node_bar_mp.rect_global_position + node_bar_mp.rect_size * 0.5, 0.75)
	node2.initialize(2, str(power_amount), 0.3, 0.7, 120, node_label_power.get_child(1).global_position, 0.75)



func taken_damage(amount):
	var node = bubble.instance()
	add_child(node)
	node.global_position = node_bar_hp.rect_global_position + node_bar_hp.rect_size * 0.5
	node.initialize(1, ("+" if amount < 0 else "") + str(-amount))


func _process(delta):
	if node_bar_mp.value == 0:
		node_bar_mp.get_node("label").rect_position = Vector2(0, 32) + Vector2(
			randf() - 0.5,
			randf() - 0.5
		) * 8
