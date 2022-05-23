extends Timer

onready var node_tooltip = $"/root/root/overlay/control2/tooltip"


func show_tooltip(node, text):
	node_tooltip.visible = true
	node_tooltip.get_child(0).bbcode_text = ""
	node_tooltip.get_child(0).append_bbcode(text)
	node_tooltip.rect_global_position = node.rect_global_position - Vector2(16, node_tooltip.rect_size.y - 48)


func hide_tooltip(node):
	node_tooltip.visible = false


func show_spell_tooltip(node, spell_id):
	show_tooltip(node, "[b]"
		+ tr("spell" + str(spell_id))
		+ "[/b]\n"
		+ tr("spell" + str(spell_id) + "_desc")
		)
