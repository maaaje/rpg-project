extends KinematicBody2D
# grundgerüst für funktionalitäten aller gegner im spiel
# benötigte funktionen:
# state-machine:
#	(idle, chase)
# stats (über stats node erledigt)
# chase_player()
# idle()
# ranged_attack()
# melee_attack()
# jump() 								?
# give_xp(xp-reward)
# drop_item(chance?)					?
# drop_gold(random_amount?)				?

var state = null
enum {
	IDLE,
	CHASE
}

onready var stats = $Stats

#fighting
export var fighting_type : String = "" #"ranged" "melee" oder "ranged_and_melee"

export var ranged_damage = 1
export var ranged_attack_speed = 1
onready var ranged_attack_timer = null
export var special_attack_projectiles = 1

export var melee_damage = 1
export var melee_attack_speed = 1
onready var melee_attack_timer = null

#movement
export var move_speed = 1
export var jump_height = 1
var velocity = Vector2.ZERO
export var ACCEL = 1
export var MAX_SPEED = 1
export var FRICTION = 1

func _physics_process(delta):
	match state:
		IDLE:
			idle()
		CHASE:
			chase_player()
			
func idle():
	pass

func chase_player():
	if fighting_type == "ranged" or fighting_type == "ranged_and_melee":
		ranged_attack_timer = Timer.new()
		ranged_attack_timer.wait_time = ranged_attack_speed
		ranged_attack_timer.connect("timeout", self, ranged_attack())
	elif fighting_type == "melee":
		melee_attack_timer = Timer.new()
		melee_attack_timer.wait_time = melee_attack_speed
		melee_attack_timer.connect("timeout", self, melee_attack())
	pass

func ranged_attack():
	pass

func melee_attack():
	pass
