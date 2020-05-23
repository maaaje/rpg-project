extends Projectile


func on_impact(collision):
	if collision.collider.name == "Player":
		print("Spieler getroffen!")
	queue_free()
