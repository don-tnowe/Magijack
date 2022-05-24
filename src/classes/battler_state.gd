class_name BattlerState
extends Reference

signal turn_started()

# This is the class that should've got some methods and fields common for player and enemy. But oh well

var spell_cooldowns := []

var status_draws := []
var status_turns := []
var status_battles := []
var owner 


func _init(owner_):
	owner = owner_
	owner_.connect("card_drawn", self, "draw_card")
#	BattleManager.connect("turn_started", self, "start_turn")
	BattleManager.connect("battle_started", self, "start_battle")
	BattleManager.connect("battle_ended", self, "end_battle")


func draw_card(card, hand, limit):
	for x in status_draws:
		x.tick()


func start_turn():
	for x in status_turns:
		x.tick()
		
	for i in spell_cooldowns.size():
		spell_cooldowns[i] -= 1
	
	emit_signal("turn_started")


func start_battle():
	spell_cooldowns.resize(owner.data.spells.size())
	for i in spell_cooldowns.size():
		spell_cooldowns[i] = owner.data.spells[i].cooldown_start


func end_battle():
	for i in spell_cooldowns.size():
		spell_cooldowns[i] = 0
	
	for x in status_draws:
		x.end()
	status_draws.clear()

	for x in status_turns:
		x.end()
	status_turns.clear()
	
	for x in status_battles:
		x.tick()
		
	clear_inactive_effects(status_battles)


func clear_inactive_effects(arr):
	var i = 0
	while i < arr.size():
		if !arr[i].active: arr.pop_at(i)
		else: i -= 1
		
	
