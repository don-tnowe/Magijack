extends Control


export var spell := 1 setget set_spell # TODO: change to spell resource.


func set_spell(v):
	spell = v
	$"button/icon".frame = v


func button_pressed():
	pass 


func mouse_entered():
	TooltipDisplayer.show_spell_tooltip(self, spell)


func mouse_exited():
	TooltipDisplayer.hide_tooltip(self)
