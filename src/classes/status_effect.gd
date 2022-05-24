class_name StatusEffect
extends Reference

var target : Object
var target_property : String
var mod_value : float
var owner_array : Array
var duration := 1


func _init(target_ : Object, target_property_ : String, mod_value_ : float, duration_ : int, owner_array_ : Array):
	target = target_
	target_property = target_property_
	mod_value = mod_value_
	duration = duration_
	owner_array = owner_array_

	target_.set(target_property_, target_.get(target_property_) + mod_value_)


func tick():
	if duration == 0: return
	duration -= 1
	if duration == 0: end()


func end():
	target.set(target_property, target.get(target_property) - mod_value)
	owner_array.erase(self)
