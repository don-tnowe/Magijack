class_name BattlerData
extends Resource

export var hpmax := 60
export var limit := 16

export var damage := 10
export var greed_damage := 10

export(Resource) var deck
export(Array, Resource) var spells := []
