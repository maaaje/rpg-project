extends Control

func _ready():
	for button in $Menu.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load])
		print(button)

func _on_Button_pressed(scene_to_load):
	print(scene_to_load)
	SceneChanger.change_scene(scene_to_load)

