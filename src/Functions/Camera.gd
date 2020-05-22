extends Camera2D

func _process(delta):
	var player_position = get_node("../Player").global_position - Vector2(0,16)
	var x = floor(player_position.x / 256) * 256
	var y = floor(player_position.y / 128) * 128
	global_position = Vector2(x,y)

