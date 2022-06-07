class_name GenericButton
extends Button

export(AudioStream) var click_sound


func button_pressed():
	$"sound_click".stream = click_sound
	$"sound_click".play()


func mouse_entered():
	if disabled: return
	
	$"sound_hover".play()
