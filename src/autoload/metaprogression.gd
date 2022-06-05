extends Timer

const saved_properties = [
	"runs_finished",
	"battles_completed_highscore",
	"artisan_unlocked",
	"loop_unlocked"
]

var runs_finished := -1
var battles_completed_highscore := 0
var artisan_unlocked := false
var loop_unlocked := false

var companion_card : CardData
var companion_card_stringified : String


func _ready():
	load_game()


func run_ended():
	battles_completed_highscore = max(BattleManager.battles_completed, battles_completed_highscore)
	runs_finished += 1
	save_game()


func save_game():
	var dict = {}
	for x in saved_properties:
		dict[x] = get(x)

	var file = File.new()
	file.open("user://savegame.dat", File.WRITE)
	file.store_var(dict)


func load_game():
	var file = File.new()
	if !file.file_exists("user://savegame.dat"): return
	file.open("user://savegame.dat", File.READ)
	
	var dict = file.get_var()
	for x in saved_properties:
		set(x, dict.get(x, get(x)))
