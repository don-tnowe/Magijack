class_name CardDeck
extends Resource

const suit_names = ["red", "blue", "purple", "orange", "grey", "special"]

# Stores card data in a string. each line has a format like "red 4+1" (red card, 4 value, 1 metal)
export(String, MULTILINE) var stringified = ""

# Stores card objects for the run, parsed from suit_names once initialized. Order doesn't matter
var cards_parsed := []

# Stores card objects for the battle, reset at end of battle to cards_parsed state. Should be sorted
var cards_battle := cards_parsed

# Draw pile resets every turn to cards_battle state. Shuffled, cards drawn from top
var cards_draw := cards_battle


func initialize():
	var lines = stringified.split("\n")
	cards_parsed.resize(lines.size())
	for i in lines.size():
		cards_parsed[i] = create_stringified_card(lines[i])
	
	cards_parsed.sort_custom(cards_battle[0], "compare")
	battle_start()


func create_stringified_card(card_stringified):
	var features = card_stringified.split(" ")
	if features[0] == "special":
		pass  # TODO

	var features_value = features[1].split("+")

	return CardData.new(
		suit_names.find(features[0]),
		int(features_value[0]) if features_value[0] != "flawless" else 11,
		int(features_value[1]) if features_value.size() >= 2 else 0
	)


func battle_start():
	cards_battle = cards_parsed.duplicate()
	turn_start()


func turn_start():
	cards_draw = cards_battle.duplicate()
	cards_draw.shuffle()


func draw_from_deck():
	return cards_draw.pop_at(0)


func get_random_basic_card():
	return CardData.new(
		randi() % 4, 
		randi() % 12, 
		randi() % 4 if randi() % 4 == 0 else 0
		)
