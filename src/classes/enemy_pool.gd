class_name EnemyPool
extends Resource

export(Array, Resource) var possible_enemies


func get_random_enemy(level, encounter_count_dict):
	var weight_sum = 0
	for x in possible_enemies:
		if can_place_enemy(x, level, encounter_count_dict):
			weight_sum += 1

	var remaining_traversal = randi() % weight_sum
	for x in possible_enemies:
		if can_place_enemy(x, level, encounter_count_dict):
			if remaining_traversal <= 1:
				return x
				
			remaining_traversal -= 1


func can_place_enemy(enemy, level, encounter_count_dict):
	return (
		level >= enemy.min_level 
		&& level <= enemy.max_level 
		&& encounter_count_dict.get(enemy.enemy_name, 0) < enemy.max_run_encounters
		)
