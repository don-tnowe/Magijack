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

var deck_depths = [cards_draw, cards_battle, cards_parsed]

func initialize():
	var lines = stringified.split("\n")
	cards_parsed.resize(lines.size())
	for i in lines.size():
		cards_parsed[i] = create_stringified_card(lines[i])
	
	cards_parsed.sort_custom(cards_battle[0], "compare")


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


func battle_end():
	cards_draw = cards_battle.duplicate()


func turn_start():
	cards_draw = cards_battle.duplicate()
	cards_draw.shuffle()


func draw_from_deck():
	return cards_draw.pop_back()

# Crit, then overload.
func get_crit_overload_chance(hand, limit) -> Array:
	var crit_count = 0
	var overload_count = 0
	for x in cards_draw:
		var new_limit_left = limit - hand.sum - x.get_value(-1, hand, limit)
		if new_limit_left == 0:
			crit_count += 1

		elif new_limit_left < 0:
			overload_count += 1

	var total = float(cards_draw.size())
	return [crit_count / total, overload_count / total]

# Depth 0 = Draw pile, Depth 1 = Resets after battle, Depth 2 = Does not reset until run end
func add_cards(cards, depth_of_consequence = 2):
	var array_chosen = deck_depths[depth_of_consequence]
	array_chosen.append_array(cards)
	array_chosen.sort_custom(cards_battle[0], "compare")

# Depth 0 = Discard, Depth 1 = Exhaust, Depth 2 = Remove from deck
func remove_cards(cards, depth_of_consequence = 2):
	var array_chosen = deck_depths[depth_of_consequence]
	for x in cards:
		array_chosen.erase(x)


func random_sharpen(count, can_repeat = false):
	var upgradeable_cards = []
	
	for x in cards_parsed:
		if x.metal_value < 10:
			upgradeable_cards.append(x)
	
	while !can_repeat && count > upgradeable_cards.size():
		count -= upgradeable_cards.size()
		var i = 0  # need separate iterator because of element removal
		while i < upgradeable_cards.size():
			upgradeable_cards[i].metal_value += 1
			if upgradeable_cards[i].metal_value >= 10:
				upgradeable_cards.remove(i)
				i -= 1
			
			i += 1
		
	for i in count:
		var idx = randi() % upgradeable_cards.size()
		var card = upgradeable_cards[idx]
		card.metal_value += 1
		
		if !can_repeat || card.metal_value == 10:
			upgradeable_cards.remove(idx)
		
		if upgradeable_cards.size() == 0:
			break


func sneak_cards(cards):
	for x in cards:
		cards_draw.push_back(x)


func get_random_basic_card():
	return CardData.new(
		randi() % 4, 
		randi() % 12, 
		randi() % 4 if randi() % 4 == 0 else 0
	)
