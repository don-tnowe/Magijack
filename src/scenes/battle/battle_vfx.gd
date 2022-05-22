extends Control

onready var node_anim = $"anim"


func _ready():
	BattleManager.view_node = self


func enemy_overload():
	node_anim.play("enemy_overload")


func player_overload():
	node_anim.play("player_overload")


func player_crit():
	node_anim.play("player_crit")


func player_win():
	node_anim.play("player_win")


func enemy_win():
	node_anim.play("enemy_win")


func tie():
	pass




