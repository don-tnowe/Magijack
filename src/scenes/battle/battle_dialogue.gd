extends Control

onready var node_player_view = $"/root/root/player_ui/control"
onready var node_btn_draw = $"/root/root/player_ui/control/button_draw"
onready var node_btn_endturn = $"/root/root/player_ui/control/button_endturn"
onready var node_btn_continue = $"center/label/button"
onready var node_text = $"center/label"
onready var node_anim = $"anim"


func _ready():
	if Metaprogression.runs_finished == 0:
		call_deferred("starting_dialogue")


func starting_dialogue():
	# Give the player weak cards and the enemy stronger cards. Wait for starting draw
	BattlePlayer.data.deck.sneak_cards([CardData.new(0, 2), CardData.new(2, 3)])
	BattleEnemy.data.deck.sneak_cards([CardData.new(0, 6), CardData.new(3, 5)])
	yield(BattlePlayer, "card_drawn")
	yield(BattlePlayer, "card_drawn")
	node_player_view.call_deferred("set_draw_available", false)
	node_player_view.call_deferred("set_endturn_available", false)
	
	# When both starter cards drawn, tell lore.
	show_text("tutorial_1")
	node_btn_continue.visible = true
	yield(node_btn_continue, "pressed")
	show_text("tutorial_2")
	yield(node_btn_continue, "pressed")
	
	# Player must click "End Turn" (instead of "Continue", so hide one and enable the other)
	show_text("tutorial_3")
	node_btn_continue.visible = false
	yield(node_anim, "animation_finished")
	show_arrow(node_btn_endturn.rect_global_position + Vector2(-64, 64))
	node_player_view.set_endturn_available(true)
	yield(node_btn_endturn, "pressed")
	
	# Player must draw cards until overload.
	hide_text()
	# 6 + 3 + 2 + 2 + 1 + 1 + 5 > 16, which at no stage adds up to a Crit.
	BattlePlayer.data.deck.sneak_cards([
		CardData.new(1, 5), CardData.new(0, 11), CardData.new(2, 11), 
		CardData.new(0, 2), CardData.new(1, 2), CardData.new(2, 3), CardData.new(3, 6)
		])
	yield(BattlePlayer, "card_drawn")
	yield(BattlePlayer, "card_drawn")
	
	show_text("tutorial_4")
	node_player_view.call_deferred("set_endturn_available", false)
	
	yield(BattlePlayer, "turn_started")
	hide_text()
	
	# Player learns about overloading and crits.
	# 4 + 6 + 6 = 16, so Crit.
	BattlePlayer.data.deck.sneak_cards([CardData.new(1, 6), CardData.new(2, 6), CardData.new(0, 4)])
	yield(BattlePlayer, "card_drawn")
	yield(BattlePlayer, "card_drawn")
	node_player_view.call_deferred("set_draw_available", false)
	node_player_view.call_deferred("set_endturn_available", false)
	node_btn_continue.visible = true
	
	show_text("tutorial_5")
	yield(node_btn_continue, "pressed")
	show_text("tutorial_6")
	yield(node_btn_continue, "pressed")
	show_text("tutorial_7")
	yield(node_btn_continue, "pressed")
	show_text("tutorial_8")
	
	node_btn_continue.visible = false
	node_player_view.set_draw_available(true)
	node_player_view.set_endturn_available(true)
	
	# Player draws Flawless Beasts.
	yield(BattlePlayer, "turn_started")
	hide_text()
	BattlePlayer.data.deck.sneak_cards([CardData.new(1, 11), CardData.new(0, 11), CardData.new(2, 11), CardData.new(3, 11)])
	yield(BattlePlayer, "card_drawn")
	yield(BattlePlayer, "card_drawn")
	node_player_view.call_deferred("set_draw_available", false)
	node_player_view.call_deferred("set_endturn_available", false)
	
	node_btn_continue.visible = true
	show_text("tutorial_9")
	yield(node_btn_continue, "pressed")
	
	show_text("tutorial_10")
	yield(node_btn_continue, "pressed")
	node_player_view.set_draw_available(true)
	node_player_view.set_endturn_available(true)
	node_btn_continue.visible = false
	hide_text()


func ending_dialogue():
	show_text("phoenix_final_defeated")
	node_player_view.call_deferred("set_draw_available", false)
	node_player_view.call_deferred("set_endturn_available", false)
	node_btn_continue.visible = true
	yield(node_btn_continue, "pressed")
	hide_text()


func show_text(text):
	node_text.visible_characters = 0
	node_text.bbcode_text = tr(text)
	node_text.rect_scale.y = 0
	visible = false
	node_anim.play("show")
	$"arrows".visible = false
	set_process(true)


func hide_text():
	node_anim.play("hide")
	$"arrows".visible = false
	set_process(false)


func show_arrow(pos):
	node_anim.play("arrow")
	$"arrows".global_position = pos


func _process(delta):
	node_text.visible_characters += 1
