class_name StatusEffect
extends Reference

var target : Object
var target_property : String
var mod_value : float
var duration := 1
var active := true


func _init(target_ : Object, target_property_ : String, mod_value_ : float, duration_ : int):
	target = target_
	target_property = target_property_
	mod_value = mod_value_
	duration = duration_

	target_.set(target_property_, target_.get(target_property_) + mod_value_)


func tick():
	if !active: return
	duration -= 1
	if duration == 0: end()


func end():
	if !active: return
	target.set(target_property, target.get(target_property) - mod_value)
	active = false
