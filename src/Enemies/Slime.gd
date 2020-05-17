extends KinematicBody2D

#onready var healthbar = 
onready var healthlabel = $HealthCounter/Label
onready var health_bar = $Bar
onready var stats = $Stats


#func _process(_delta):
#	healthlabel.text = stats.health as String

func _ready():
	health_bar.update_healthbar_maxhealth(stats.max_health)
	healthlabel.text = stats.max_health as String

func _on_Stats_no_health():
	queue_free()

