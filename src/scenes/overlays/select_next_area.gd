extends OverlayBase


export(Resource) var enemy_pool

var feature_pool = ["hp_mp_upgrade", "forge", "library", "bonfire"]

var choices
var choices_features
var current_choice = 0


func _ready():
	var level = BattleManager.enemy_level
	choices = enemy_pool.get_random_enemies(level, BattleManager.enemy_encounter_count, 2)
	if BattleManager.battles_completed % 4 == 3:
		choices_features = [3, 3]
		
	else:
		choices_features = [0, 1, 2]
		
		if BattleManager.next_feature != "":
			choices_features.erase(feature_pool.find(BattleManager.next_feature))
			
		choices_features.shuffle()
		
	display_card(choices[0], choices_features[0], 0, level)
	display_card(choices[1], choices_features[1], 1, level)
	
	# Don't show before tutorial.
	if Metaprogression.runs_finished == -1:
		Metaprogression.runs_finished = 0
		close()


func display_card(enemy, feature, idx, level):
	var card_node = $"cards".get_child(idx)
	card_node.get_node("card/enemy").frame = enemy.enemy_id
	card_node.get_node("card/feature").frame = feature
	card_node.get_node("card").connect("gui_input", self, "card_input", [idx])
	
	enemy = enemy.duplicate()
	choices[idx] = enemy  # So only the enemy that will be chosen gets modified, not the original
	# TODO: add more enemy types so this is irrelevant
	enemy.hpmax += floor(enemy.hpmax * (level * 0.1))
	enemy.damage += floor(enemy.damage * (level * 0.15))
	enemy.greed_damage += floor(enemy.greed_damage * (level * 0.05))
	enemy.limit += floor(level * 0.25)


func close():
	BattleManager.next_feature = feature_pool[choices_features[current_choice]]
	BattleEnemy.set_enemy(choices[current_choice])
	BattleManager.call_deferred("battle_start")
	.close()


func card_input(event, idx):
	if event is InputEventMouseButton && event.is_pressed():
		$"cards".get_child(current_choice).rect_scale = Vector2.ONE
		$"cards".get_child(idx).rect_scale = Vector2(1.2, 1.2)
		current_choice = idx
		$"button".visible = true


