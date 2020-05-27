extends KinematicBody2D
class_name Enemy

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#---------------		# VERWENDUNG												-------------------
#---------------		# Neue Gegnerszene mit folgender Struktur einrichten:		-------------------

#---------------		# KinematicBody2D											-------------------
#---------------		#--- Sprite													-------------------
#---------------		#--- AnimationPlayer										-------------------
#---------------		#--- PlayerDetectionArea									-------------------
#---------------		#--- CollisionShape2D										-------------------
#---------------		#--- MeleeDamageArea										-------------------
#---------------		#--- Stats													-------------------
#---------------		#--- Bar													-------------------
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# ZWECK DES SCRIPTS
# grundgerüst für funktionalitäten aller gegner im spiel
# benötigte funktionen:
# state-machine:
#	(idle, chase)
# stats (über stats node erledigt)
# take_damage()							?    <- stats.connect("helath_updated", self, "take_damage")
# chase_player()
# idle()
# ranged_attack()
# melee_attack()
# jump() 								?
# give_xp(xp-reward)
# drop_item(chance?)					?
# drop_gold(random_amount?)				?

#nodes
onready var stats = $Stats
onready var health_bar = $Bar
onready var player_detection_area : Area2D = $PlayerDetectionArea
onready var melee_damage_area : Area2D = null 
#wird nur genutzt, wenn fighting_type == "melee" oder "raned_and_melee" bzw. "melee_and_ranged"
#daher in func _ready() gecacht
onready var anim : AnimationPlayer = $AnimationPlayer

#fighting
var player = null
export var fighting_type : String = "" #"ranged" "melee" oder "ranged_and_melee"

export var ranged_damage = 1
export var projectile_speed_multiplier = 1.0
export var ranged_attack_speed = 1.0
export var ranged_attack_range = 40
onready var ranged_attack_timer = null
var can_attack_ranged = true
export var special_attack_roll = 5

export var melee_damage = 1
export var melee_attack_speed = 1.0
onready var melee_attack_timer = null
var can_attack_melee = true

#movement
var idle_move_timer = null
export var idle_movement_time = 1
var walk_ended = true

export var move_speed = 40
export var jump_height = 1
var velocity = Vector2.ZERO
export var ACCEL = 1
export var MAX_SPEED = 1
export var FRICTION = 1

var state = null
enum {
	IDLE,
	CHASE
}

func _ready():
	if fighting_type == "melee" or fighting_type == "ranged_and_melee" or fighting_type == "melee_and_ranged":
		melee_damage_area = $MeleeDamageArea
	
	stats.connect("health_updated", health_bar, "_on_Stats_health_updated")
	stats.connect("no_health", self, "die")
	health_bar.get_child(0).max_value = stats.max_health
	
	self.add_to_group("enemies")
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
	velocity = move_and_slide(velocity.normalized() * move_speed)

func idle_move_timer_timeout():
	walk_ended = true
	idle_move_timer.queue_free()

func chase_player():
	if player != null: #um fehler zu verhindern wenn player nicht bekannt ist
		if fighting_type == "ranged":
			if can_attack_ranged:
				ranged_attack()
				can_attack_ranged = false
				ranged_attack_timer = Timer.new()
				self.add_child(ranged_attack_timer)
				ranged_attack_timer.wait_time = ranged_attack_speed
				ranged_attack_timer.connect("timeout", self, "ranged_attack_timer_timeout")
				ranged_attack_timer.start()
				
		elif fighting_type == "melee":
			if can_attack_melee and melee_damage_area.overlaps_body(player):
				melee_attack()
				can_attack_melee = false
				melee_attack_timer = Timer.new()
				self.add_child(melee_attack_timer)
				melee_attack_timer.wait_time = melee_attack_speed
				melee_attack_timer.connect("timeout", self, "melee_attack_timer_timeout")
				melee_attack_timer.start()
				
		elif fighting_type == "ranged_and_melee" or "melee_and_range":
			if can_attack_ranged:
				ranged_attack()
				can_attack_ranged = false
				ranged_attack_timer = Timer.new()
				self.add_child(ranged_attack_timer)
				ranged_attack_timer.wait_time = ranged_attack_speed
				ranged_attack_timer.connect("timeout", self, "ranged_attack_timer_timeout")
				ranged_attack_timer.start()
				
			if can_attack_melee and melee_damage_area.overlaps_body(player):
				melee_attack()
				can_attack_melee = false
				melee_attack_timer = Timer.new()
				self.add_child(melee_attack_timer)
				melee_attack_timer.wait_time = melee_attack_speed
				melee_attack_timer.connect("timeout", self, "melee_attack_timer_timeout")
				melee_attack_timer.start()
		
		#nur auf den Spieler zu bewegen, wenn der Gegner auch melee attacks hat, ansonsten nur in range bewegen
		if fighting_type == "melee" or fighting_type == "melee_and_ranged" or fighting_type == "ranged_and_melee":
			velocity = player.global_position - self.global_position
			velocity = move_and_slide(velocity.normalized() * move_speed)
		
		elif fighting_type == "ranged":
			var distance_to_player : Vector2 = player.global_position - self.global_position
			if distance_to_player.length() > ranged_attack_range:
				velocity = player.global_position - self.global_position
				velocity = move_and_slide(velocity.normalized() * move_speed)
			elif distance_to_player.length() <= ranged_attack_range:
				velocity = velocity.move_toward(Vector2.ZERO, FRICTION)

# --------------------------------------------- attacks and cooldown timers -----------------------------------

func ranged_attack_timer_timeout():
	can_attack_ranged = true
	ranged_attack_timer.queue_free()
	
func melee_attack_timer_timeout():
	can_attack_melee = true
	melee_attack_timer.queue_free()

func ranged_attack():
#	anim.play("ranged_attack")	
	var attack_roll = randi() % special_attack_roll
	if attack_roll == 0:
		special_attack()
	else:
		var shoot_direction = player.global_position - self.global_position
		var projectile = Globals.enemy_projectile.instance()
		projectile.damage = ranged_damage
		self.add_child(projectile)
		projectile.launch(shoot_direction, projectile_speed_multiplier)
		state = CHASE

# ---------------------- code für special_attack() wird individuell für einzelne gegnertypen implementiert

func special_attack():
	self.special_attack()

func melee_attack():
	player.take_damage(melee_damage)
#	anim.play("melee_attack")

# ------------------------------------------- schaden nehmen und sterben ----------------------------------------

func take_damage(damage):
	stats.health = max(0, stats.health - damage)
#	if stats.health > 0:
#		anim.play("hurt")

func die():
#	anim.play("die")
	queue_free()
