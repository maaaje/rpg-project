extends CanvasLayer

onready var player_stats = get_node("../Player/PlayerStats")

onready var animation_player = $AnimationPlayer
onready var health_bar = $CenterContainer/HBoxContainer/Bar
onready var health_label = $CenterContainer/HBoxContainer/HP
onready var xp_label = $CenterContainer/HBoxContainer/XP
onready var lvl_label = $CenterContainer/HBoxContainer/LVL

func _ready():
	player_stats.connect("xp_updated", self, "on_xp_updated")
	player_stats.connect("leveled_up", self, "on_leveled_up")
	player_stats.connect("health_updated", self, "on_health_updated")
	health_bar.update_healthbar_maxhealth(player_stats.max_health)
	health_label.text = "HP: " + player_stats.max_health as String
	lvl_label.text = "LVL: " + player_stats.level as String
	print(player_stats)
	
func on_health_updated(health, change):
	health_bar._on_Stats_health_updated(health)
	health_label.text = "HP: " + health as String
	if change == "decreased":
		animation_player.play("change_label_red")
	elif change == "increased":
		animation_player.play("change_label_green")
		
func on_xp_updated(new_xp):
	xp_label.text = "XP: " + new_xp as String
	
func on_leveled_up(new_level):
	lvl_label.text = "LVL: " + new_level as String
