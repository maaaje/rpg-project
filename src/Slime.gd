extends KinematicBody2D

const MAX_HEALTH = 20

#onready var healthbar = 
onready var healthlabel = $HealthCounter/Label
onready var health = MAX_HEALTH


func _process(delta):
	#healthbar.rect_size.x = 16 * (health / MAX_HEALTH)
	healthlabel.text = health as String
	if health <= 0:
		die()
				
func die():
	queue_free()
	
