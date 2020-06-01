extends Enemy

onready var sprite = $Sprite

export var chest_style : int = 0

func _ready():
	sprite.region_rect = Rect2(0, chest_style * 16, 32, 16)
	anim.play("Idle")
