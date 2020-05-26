extends KinematicBody2D
class_name enemy

# grundgerüst für funktionalitäten aller gegner im spiel
# benötigte funktionen:
# state-machine:
#	(idle, chase)
# stats (über stats node erledigt)
# take_damage()
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
onready var player_detection_area : Area2D = $PlayerDetectionArea

#fighting
var player = null
export var fighting_type : String = "" #"ranged" "melee" oder "ranged_and_melee"

export var ranged_damage = 1
export var ranged_attack_speed = 1
onready var ranged_attack_timer = null
var can_attack = true
export var special_attack_projectiles = 1

export var melee_damage = 1
export var melee_attack_speed = 1
onready var melee_attack_timer = null

#movement
var idle_move_timer = null
export var idle_movement_time = 1
var walk_ended = true

export var move_speed = 1
export var jump_height = 1
var velocity = Vector2.ZERO
export var ACCEL = 1
export var MAX_SPEED = 1
export var FRICTION = 1

func _ready():
	state = IDLE

# ------------------------------------------- player erkennen durch PlayerDetectionArea -------------------

func detect_player(body):
	player = body
	state = CHASE
	
func forget_player():
	player = null
	state = IDLE

# --------------------------------------------- state machine --------------------------------------------
func _physics_process(delta):
	match state:
		IDLE:
			idle()
		CHASE:
			chase_player()

func idle():
	if walk_ended: # in intervallen von idle_movement_time läuft der enemy in eine zufällige richtung
		velocity = Vector2.ZERO
		var x = randi() % 3 -1
		var y = randi() % 3 -1
		velocity = Vector2(x,y)
		walk_ended = false
		idle_move_timer = Timer.new()
		self.add_child(idle_move_timer)
		idle_move_timer.connect("timeout", self, "idle_move_timer_timeout")
		idle_move_timer.one_shot = true
		idle_move_timer.wait_time = idle_movement_time
		idle_move_timer.start()
		print("start walking")
	velocity = move_and_slide(velocity.normalized() * move_speed)

func idle_move_timer_timeout():
	walk_ended = true
	idle_move_timer.queue_free()

func chase_player():
	if player != null: #um fehler zu verhindern wenn player nicht bekannt ist
		if fighting_type == "ranged" or fighting_type == "ranged_and_melee":
			if can_attack:
				ranged_attack()
				can_attack = false
				ranged_attack_timer = Timer.new()
				self.add_child(ranged_attack_timer)
				ranged_attack_timer.wait_time = ranged_attack_speed
				ranged_attack_timer.connect("timeout", self, "ranged_attack_timer_timeout")
				ranged_attack_timer.start()
		elif fighting_type == "melee":
			melee_attack_timer = Timer.new()
			self.add_child(melee_attack_timer)
			melee_attack_timer.wait_time = melee_attack_speed
			melee_attack_timer.connect("timeout", self, "melee_attack")
			melee_attack_timer.start()
		
		velocity = player.global_position - global_position
		velocity = move_and_slide(velocity.normalized() * move_speed)

# ------------------------------------------------------ attacks -----------------------------------

func ranged_attack_timer_timeout():
	can_attack = true
	ranged_attack_timer.queue_free()

func ranged_attack():
	pass

func melee_attack():
	pass
