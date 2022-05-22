extends Control

onready var node_anim = $"anim"
onready var node_anim2 = $"anim2"
onready var node_outcome_nums = $"control/outcome/nums"
onready var node_outcome_text = $"control/outcome/outcome"


func _ready():
	BattleManager.view_node = self


func enemy_overload(limit_over, limit):
	node_anim.play("enemy_overload")
	yield(node_anim, "animation_finished")
	node_anim2.play("outcome_text")
	node_outcome_nums.text = str(limit_over + limit) 
	node_outcome_text.text = "battle_outcome_overload_enemy"


func player_overload(limit_over, limit):
	node_anim.play("player_overload")
#	node_anim2.play("outcome_text")
#	node_outcome_nums.text = str(limit) + " + " + str(-limit_over) 
#	node_outcome_text.text = "battle_outcome_overload_player"


func player_crit():
	node_anim.play("player_crit")
#	node_anim2.play("outcome_text")
#	node_outcome_nums.text = "!!!"
#	node_outcome_text.text = "battle_outcome_crit"


func player_win(player, enemy):
	node_anim.play("player_win")
	node_anim2.play("outcome_text")
	node_outcome_nums.text = str(player) + " vs " + str(enemy) 
	node_outcome_text.text = "battle_outcome_hit_player"


func enemy_win(player, enemy):
	node_anim2.play("outcome_text")
	node_anim.play("enemy_win")
	node_outcome_nums.text = str(player) + " vs " + str(enemy) 
	node_outcome_text.text = "battle_outcome_hit_enemy"


func tie(player, enemy):
	node_anim2.play("outcome_text")
	node_outcome_nums.text = str(player) + " vs " + str(enemy) 
	node_outcome_text.text = "battle_outcome_draw"




