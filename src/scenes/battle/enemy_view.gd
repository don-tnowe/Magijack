extends Control

export(PackedScene) var bubble

onready var node_hand = $"../hand"
onready var node_instance = $"enemy"

onready var node_label_hp = $"label_hp"
onready var node_label_mp = $"label_mp"
onready var node_label_damage = $"label_damage"
onready var node_label_greeddamage = $"label_greeddamage"


func _ready():
	BattleEnemy.view_node = self
	node_hand.hand_data = BattleEnemy.hand_data


func update_all():
	node_label_hp.text = str(BattleEnemy.hp)
	node_label_mp.text = str(BattleEnemy.data.limit)
	node_label_damage.text = str(BattleEnemy.data.damage)
	node_label_greeddamage.text = str(BattleEnemy.data.greed_damage)


func taken_damage(amount):
	var node = bubble.instance()
	add_child(node)
	node.global_position = node_label_hp.rect_global_position
	node.initialize(1, ("+" if amount < 0 else "") + str(-amount), 0, 1, 64)


func set_enemy(enemy_data):
	node_instance.queue_free()
	node_instance = enemy_data.scene.instance()
	add_child(node_instance)
	update_all()
