extends Area2D

onready var enemy = self.get_parent()

func _on_PlayerDetectionArea_body_entered(body):
	if body.name == "Player":
		enemy.detect_player(body)
