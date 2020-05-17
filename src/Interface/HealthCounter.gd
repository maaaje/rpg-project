extends NinePatchRect

onready var label = $Label

func _on_Stats_health_updated(health):
	label.text = health as String
