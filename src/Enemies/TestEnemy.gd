extends Enemy

const special_attack_directions = [Vector2(1, 0), Vector2(1, -1), Vector2(0, -1), Vector2(-1, -1), 
								Vector2(-1, 0), Vector2(-1, 1), Vector2(0, 1), Vector2(1, 1)]

func special_attack():
	for i in range(8): # (1, 0) (1, -1) (0, -1) (-1, -1) (-1, 0) (-1, 1) (0, -1) (1, 1)
		var shoot_direction = special_attack_directions[i]
		var projectile = Globals.enemy_projectile.instance()
		projectile.damage = ranged_damage
		self.add_child(projectile)
		projectile.launch(shoot_direction, projectile_speed_multiplier)
	state = CHASE
