extends HBoxContainer

onready var health_bar = $HealthBar

func update_healthbar(health):
	health_bar.value = health
	
func update_healthbar_maxhealth(max_health):
	health_bar.max_value = max_health

func _on_Stats_health_updated(health):
	update_healthbar(health)
