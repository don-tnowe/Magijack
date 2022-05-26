extends ScrollContainer

export(PackedScene) var scene_spellview

onready var overlay = $"../spell_selection"
onready var container = $"box"

var battler
var casting_available = false


func _ready():
	call_deferred("initialize")


func initialize():
	battler = BattlePlayer
	BattlePlayer.state.connect("battle_started", self, "update_view")
	BattlePlayer.state.connect("turn_started", self, "update_cooldowns")
	BattlePlayer.connect("card_drawn", self, "player_drawn_card")
	# update_view()


func player_drawn_card(card, hand, limit):
	update_cooldowns()


func update_view():
	var spellcount = battler.data.spells.size()
	while spellcount > container.get_child_count():
		var idx = container.get_child_count()
		var node = scene_spellview.instance()
		container.add_child(node)
		node.get_node("button").connect("mouse_entered", TooltipDisplayer, "show_spell_tooltip", [node, battler.data.spells[idx].spell_id])
		node.get_node("button").connect("mouse_exited", TooltipDisplayer, "hide_tooltip")
		node.get_node("button").connect("pressed", self, "spell_cast_start", [idx])

	for i in container.get_child_count():
		var node = container.get_child(i)
		if i >= spellcount:
			node.visible = false
			continue
		
		node.visible = true
		battler.data.spells[i].display_on_spell_node(node)
		
	update_cooldowns()
	

func update_cooldowns():
	for i in battler.data.spells.size():
		var node = container.get_child(i)
		if battler.state.spell_cooldowns[i] <= 0:
			node.get_node("button").disabled = !battler.data.spells[i].can_cast_with_hand(BattlePlayer.hand_data)
			node.get_node("button/progress").value = 9999999 if node.get_node("button").disabled else 0
			node.get_node("button/cooldown").visible = false

		else:
			node.get_node("button").disabled = true
			node.get_node("button/progress").value = battler.state.spell_cooldowns[i]
			node.get_node("button/cooldown").frame = battler.state.spell_cooldowns[i]
			node.get_node("button/cooldown").visible = true


func spell_cast_start(idx):
	if !casting_available: return
	
	var spell = battler.data.spells[idx]
	if spell.cost_max == 0:
		spell.cast(battler)
		battler.state.spell_cooldowns[idx] = spell.cooldown
		update_cooldowns()
		get_parent().update_all()
		
	else:
		overlay.open(spell, idx)
