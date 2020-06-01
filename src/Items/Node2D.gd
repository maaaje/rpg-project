extends Node2D

const projectile_scene = "res://src/Spells/FireballPruple.tscn"

func _on_Area2D_area_entered(area):
	if area.get_parent().name == "Player":
		Globals.projectile = preload(projectile_scene)
		queue_free()
