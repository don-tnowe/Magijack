class_name EnemyPool
extends Resource

export(Array, Resource) var possible_enemies


func get_random_enemies(level, encounter_count_dict, count):
	var weight_sum = 0
	for x in possible_enemies:
		if can_place_enemy(x, level, encounter_count_dict):
			weight_sum += 1

	var results = []
	results.resize(count)
	for i in count:
		var remaining_traversal = randi() % weight_sum + 1
		for x in possible_enemies:
			if can_place_enemy(x, level, encounter_count_dict):
				# If enemy was placed in another cell, skip it. Otherwise, count down the path to result
				if weight_sum == 1 || !results.has(x):
					remaining_traversal -= 1
					
				if remaining_traversal < 1:
					results[i] = x
					break
		
		if weight_sum != 1: weight_sum -= 1  # Next time, choose out of 1 less enemies.
		
	return results


func can_place_enemy(enemy, level, encounter_count_dict):
	return (
		level >= enemy.min_level 
		&& level <= enemy.max_level 
		&& encounter_count_dict.get(enemy.enemy_id, 0) < enemy.max_run_encounters
		)
