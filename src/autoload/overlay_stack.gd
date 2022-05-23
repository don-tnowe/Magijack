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
		# "hp_mp_upgrade",
		# "library",
		# "forge",
		"defeat"
		]:
		overlay_scenes[x] = load(overlay_directory + x + ".tscn")


func open(overlay_name, params = null):
	if stack.size() > 0: 
		stack[stack.size() - 1].hide_overlay()

	var new_overlay = overlay_scenes[overlay_name].instance()
	overlay_parent.add_child(new_overlay)
	new_overlay.initialize(params)
	stack.append(new_overlay)


func pop():
	stack.pop_back().queue_free()
	if stack.size() == 0: return
	stack[stack.size() - 1].reopen_overlay()
