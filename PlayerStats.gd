extends Node

#leveling System
signal xp_updated
signal leveled_up
export (int) var level = 1
var experience = 0
var experience_total = 0
var experience_required = get_required_experience(level + 1)

#character base stats
var strength = 10
var intelligence = 10
var vitality = 10 setget set_vitality, get_vitality

func set_vitality(amount):
	vitality = amount
	if health == max_health:
		self.health = vitality * 5
	self.max_health = vitality * 5
	
func get_vitality():
	return vitality

#health based on vitality
var max_health = vitality * 5
var health = max_health setget set_health, get_health

signal no_health
signal health_updated

func set_health(value):
	if health > value:
		health = value
		emit_signal("health_updated", health as float, "decreased")
		if health <= 0:
			emit_signal("no_health")
	elif health < value:
		health = value
		emit_signal("health_updated", health as float, "increased")
	else:
		pass

func get_health():
	return health

# ------------------ leveling system ---------------------- #
func get_required_experience(level):
	return round(pow(level, 1.8) + level * 4 + 30)
	
func gain_experience(amount):
	experience_total += amount
	experience += amount
	emit_signal("xp_updated", experience)
	while experience >= experience_required:
		experience -= experience_required
		emit_signal("xp_updated", experience)
		level_up()
		
func level_up():
	level += 1
	emit_signal("leveled_up", level)
	experience_required = get_required_experience(level + 1)
	self.vitality += 1
	
