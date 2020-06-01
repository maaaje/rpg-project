extends StaticBody2D

export var chest_style = 0
onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var audio_player = $AudioStreamPlayer2D

var opened = false

func _ready():
	sprite.region_rect = Rect2(0, 16 * chest_style, 64, 16)


func _on_Area2D_body_entered(body):
	if body.name == "Player" and opened == false:
		animation_player.play("Open")
		audio_player.playing = true
		opened = true
		give_chest_loot()
		
func give_chest_loot():
	print("Loot gedropped")
