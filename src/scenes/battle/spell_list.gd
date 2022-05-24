extends ScrollContainer

export(PackedScene) var scene_spellview

onready var container = $"box"

var battler_data
var battler_state


func _ready():
	BattleManager.connect("battle_started", self, "update_view")
	BattleManager.connect("turn_started", self, "update_cooldowns")
	battler_data = BattlePlayer.data
	battler_state = BattlePlayer.state
	update_view()


func update_view():
	var spellcount = battler_data.spells.size()
	while spellcount > container.get_child_count():
		var node = scene_spellview.instance()
		container.add_child(node)

	for i in container.get_child_count():
		var node = container.get_child(i)
		if i >= spellcount:
			node.visible = false
			continue
		
		node.visible = true
		battler_data.spells[i].display_on_spell_node(node)
		
		update_cooldowns()
	

func update_cooldowns():
	for i in battler_data.spells.size():
		var node = container.get_child(i)
		if battler_state.spell_cooldowns[i] <= 0:
			node.get_node("button").disabled = battler_data.spells[i].can_cast_with_hand()
			node.get_node("button/progress").progress = 0
			node.get_node("button/cooldown").visible = false

		else:
			node.get_node("button").disabled = true
			node.get_node("button/progress").progress = battler_state.spell_cooldowns[i]
			node.get_node("button/cooldown").frame = battler_state.spell_cooldowns[i]
			node.get_node("button/cooldown").visible = true
