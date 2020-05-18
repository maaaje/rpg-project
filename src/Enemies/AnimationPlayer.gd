extends AnimationPlayer


func _on_Stats_health_updated(_health):
	play("Hurt")
	
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Hurt":
		play("slime_wobble")
