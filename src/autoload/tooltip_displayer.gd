extends Timer

onready var node_tooltip = $"/root/root/overlay/control2/tooltip"


func show_tooltip(node, text):
	node_tooltip.visible = true
	node_tooltip.get_child(0).bbcode_text = ""
	node_tooltip.get_child(0).append_bbcode(text)
	node_tooltip.rect_global_position = Vector2(
		clamp(
			node.rect_global_position.x + node.rect_size.x * 0.5 - node_tooltip.rect_size.x * 0.375, 
			32, 
			node_tooltip.get_parent().rect_size.x - 32 - node_tooltip.rect_size.x * 0.75
			), 
		node.rect_global_position.y + 48 - node_tooltip.rect_size.y
		)


func hide_tooltip(node = null):
	node_tooltip.visible = false


func show_unique_node_tooltip(node):
	if node.name == "bar_hp":
		show_tooltip(node, "[b]"
		+ tr("tooltip_hp") % [BattlePlayer.hp, BattlePlayer.data.hpmax]
		+ "[/b]\n"
		+ tr("tooltip_hp_desc")
		)
		
	elif node.name == "bar_mp":
		show_tooltip(node, "[b]"
		+ tr("tooltip_mp") % [BattlePlayer.limit_used, BattlePlayer.data.limit, BattlePlayer.data.limit - BattlePlayer.limit_used]
		+ "[/b]\n"
		+ tr("tooltip_mp_desc")
		)
		
	elif node.name == "tt_crit":
		show_tooltip(node, tr("tooltip_crit"))
		
	elif node.name == "tt_overload":
		show_tooltip(node, tr("tooltip_overload"))


func show_spell_tooltip(node, spell_id):
	show_tooltip(node, "[b]"
		+ tr("spell" + str(spell_id))
		+ "[/b]\n"
		+ tr("spell" + str(spell_id) + "_desc")
		)
