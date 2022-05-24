class_name BattlerState
extends Reference

# This is the class that should've got some methods and fields common for player and enemy. But oh well

var spell_cooldowns := []

var status_turns := []
var status_battles := []
var owner 


func _init(owner_):
	owner = owner_
	BattleManager.connect("turn_started", self, "start_turn")
	BattleManager.connect("battle_started", self, "start_battle")
	BattleManager.connect("battle_ended", self, "end_battle")


func start_turn():
	for x in status_turns:
		x.tick()
		
	for i in spell_cooldowns:
		spell_cooldowns[i] = owner.data


func start_battle():
	spell_cooldowns.resize(owner.data.spells)
	for i in spell_cooldowns:
		spell_cooldowns[i] = owner.data.spells[i].start_cooldown


func end_battle():
	for i in spell_cooldowns:
		spell_cooldowns[i] = 0
	
	for x in status_turns:
		x.end()
	
	status_turns.clear()
	for x in status_battles:
		x.tick()
		
	
