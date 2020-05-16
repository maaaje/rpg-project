extends Node2D

func _on_SceneTrigger_area_entered(_area):
	SceneChanger.change_scene("res://src/Level/World.tscn", 0)
