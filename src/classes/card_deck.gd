class_name CardDeck
extends Resource

export(Array, Resource) var cards = []


func draw_from_deck():  # TODO: Actual draw-from-deck logic
  return get_random_basic_card()


func get_random_basic_card():
  return CardData.new(
    randi() % 4, 
    randi() % 12, 
    randi() % 4 if randi() % 4 == 0 else 0
  )