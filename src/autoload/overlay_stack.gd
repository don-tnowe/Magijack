extends Timer

onready var overlay_parent = $"/root/root/overlay/control"

const overlay_directory = "res://src/scenes/overlays/"

var overlay_scenes = {}
var stack = []


func _ready():
	for x in [
		"victory_card",
		"select_next_area",
		"view_deck",
		"select_card",
		"bonfire",
		"hp_mp_upgrade",
		"library",
		"forge",
		"defeat",
		"select_character",
		"select_companion_card"
		]:
		overlay_scenes[x] = load(overlay_directory + x + ".tscn")


func open(overlay_name, params = null):
	# Hardcoded prevention of endless deck views stacked,
	if stack.size() > 0 && overlay_name == "view_deck" && stack[stack.size() - 1] is preload("res://src/scenes/overlays/view_deck.gd"):
		stack[stack.size() - 1].close()
		return

	if stack.size() > 0: 
		stack[stack.size() - 1].hide_overlay()

	var new_overlay = overlay_scenes[overlay_name].instance()
	overlay_parent.add_child(new_overlay)
	new_overlay.initialize(params)
	stack.append(new_overlay)
	get_tree().paused = true


func pop():
	var deleted_node = stack.pop_back()
	if stack.size() == 0: return
	stack[stack.size() - 1].reopen_overlay()
	
	# Workaround for button SFX not playing until the end.
	start(2)
	yield(self, "timeout")
	deleted_node.queue_free()
