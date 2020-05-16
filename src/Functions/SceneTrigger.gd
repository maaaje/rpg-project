extends Area2D

func _on_SceneTrigger_area_entered(_area):
	SceneChanger.change_scene("res://src/MerchantHouse.tscn", 0.2)
	print("area entered")

