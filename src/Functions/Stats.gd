extends Node

export (int) var max_health = 1
export (int) var health = max_health setget set_health

signal no_health
signal health_updated

func set_health(value):
	if health != value:
		health = value
		emit_signal("health_updated", health as float)
		if health <= 0:
			emit_signal("no_health")
