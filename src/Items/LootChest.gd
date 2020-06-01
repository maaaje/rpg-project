extends StaticBody2D

export var chest_style = 0
onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var audio_player = $AudioStreamPlayer2D

onready var mimic_scene = preload("res://src/Enemies/MimicChest.tscn")

export var mimic_chance = 10

var opened = false

func _ready():
	randomize()
	sprite.region_rect = Rect2(0, 16 * chest_style, 64, 16)


func _on_Area2D_body_entered(body):
	if body.name == "Player" and opened == false:
		if chest_style == 0 or chest_style == 1: #nur truhen 0 und 1 (eisen und goldtruhe können mimic spawnen)
			var mimic_roll = randi() % mimic_chance
			if mimic_roll == 0:
				spawn_mimic(chest_style)
		animation_player.play("Open")
		audio_player.playing = true
		opened = true
		give_chest_loot()

func spawn_mimic(mimic_style : int = 0):
	var mimic_chest = mimic_scene.instance()
	mimic_chest.global_position = global_position
	mimic_chest.chest_style = mimic_style
	get_parent().add_child(mimic_chest)
	mimic_chest.state = "CHASE"
	queue_free()

func give_chest_loot():
	print("Loot gedropped")
