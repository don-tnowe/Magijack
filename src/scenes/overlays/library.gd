extends OverlayBase


export(Array, Resource) var spell_pool = []

onready var spell_nodes = [
	$"spells/aligner1/spell",
	$"spells/aligner2/spell",
	$"spells/aligner3/spell",
]

var selected_spell_idx := -1


func _ready():
	spell_pool.shuffle() 
	for i in $"spells".get_child_count():
		spell_pool[i].display_on_spell_node(spell_nodes[i])
		spell_nodes[i].get_child(0).connect("pressed", self, "spell_pressed", [i])
		spell_nodes[i].get_child(0).connect("mouse_entered", TooltipDisplayer, "show_spell_tooltip", [spell_nodes[i], spell_pool[i].spell_id])
		spell_nodes[i].get_child(0).connect("mouse_exited", TooltipDisplayer, "hide_tooltip", [spell_nodes[i]])


func spell_pressed(idx):
	$"button_continue".visible = true
	
	if selected_spell_idx != -1:
		spell_nodes[selected_spell_idx].get_parent().rect_scale = Vector2.ONE
	
	TooltipDisplayer.pause_mode = Node.PAUSE_MODE_PROCESS
	selected_spell_idx = idx
	spell_nodes[idx].get_parent().rect_scale = Vector2(1.35, 1.35)


func close():
	BattlePlayer.add_spell(spell_pool[selected_spell_idx])
	.close()
