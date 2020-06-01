extends Enemy

const special_attack_directions = [Vector2(1, 0), Vector2(1, -0.5), Vector2(1, -1), Vector2(1, -1.5), 
								Vector2(0, -1), Vector2(-1, -1.5), Vector2(-1, -1), Vector2(-1, -0.5), 
								Vector2(-1, 0), Vector2(-1, 0.5), Vector2(-1, 1), Vector2(-1, 1.5),
								Vector2(0, 1), Vector2(1, 1.5), Vector2(1, 1), Vector2(1, 0.5)]

func special_attack():
	for i in special_attack_directions.size(): # (1, 0) (1, -1) (0, -1) (-1, -1) (-1, 0) (-1, 1) (0, -1) (1, 1)
		var shoot_direction = special_attack_directions[i].normalized()
		var projectile = Globals.enemy_projectile.instance()
		projectile.damage = ranged_damage
		self.add_child(projectile)
		projectile.launch(shoot_direction, projectile_speed_multiplier)
		yield(get_tree().create_timer(0.1), "timeout")
	state = CHASE
