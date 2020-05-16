extends Control

var health = 50 setget set_health
var max_health = 50 setget set_max_health

onready var label = $Label

func set_health(value):
	health = clamp(value, 0, max_health)
	
func set_max_health(value):
	max_health = max(value, 1)
	
func _ready():
	pass

