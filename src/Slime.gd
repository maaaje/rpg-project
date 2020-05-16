extends KinematicBody2D

#onready var healthbar = 
onready var healthlabel = $HealthCounter/Label
onready var stats = $Stats


func _process(delta):
	#healthbar.rect_size.x = 16 * (health / MAX_HEALTH)
	healthlabel.text = stats.health as String

func _on_Stats_no_health():
	queue_free()
