extends KinematicBody2D

# PLAYER SIGNALS
signal shoot_item


# MOVEMENT VARIABLES
export var ACCEL = 550
export var FRICTION = 550
export var MAX_SPEED = 40
export var MAX_SPEED_SPRINT = 60
var velocity = Vector2.ZERO

# FIREBALL SCENE AND SPAWN POSITION
const fireball_scene = preload("res://src/Spells/Fireball.tscn")
onready var spell_spawn_position = $Position2D
var shoot_item = null

# ENUM STATES FOR STATE_MACHINE
enum {
	MOVE,
	ROLL,
	ATTACK
}
var state = MOVE
onready var animation_player = $AnimationPlayer
onready var ranged_cooldown = $RangedCooldown
export (float) var cooldown_time_ranged = 0.5
var shoot_ready : bool = true

# PLAYER STATS RELATED VARIABLES AND NODES
onready var stats = $PlayerStats
onready var health_bar = $Bar
onready var health_counter_label = $HealthCounter/Label

func _ready():
	health_bar.update_healthbar_maxhealth(stats.max_health)
	health_counter_label.text = stats.health as String

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		
		ROLL:
			pass
			
		ATTACK:
			attack_state(delta)
			
	if Input.is_action_just_pressed("simulate_player_damage"):
		take_damage(randi()%5 +1)
	if Input.is_action_just_pressed("xp-test"):
		$PlayerStats.gain_experience(5)	


# ------------------- STATE_MACHINE FOR MOVEMENT ------------------------
func move_state(delta):
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		if Input.is_action_pressed("shift"):
			velocity = velocity.move_toward(input_vector * MAX_SPEED_SPRINT, ACCEL * delta)
		else:
			velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCEL * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	
func attack_state(delta):
	#velocity = Vector2.ZERO
	#Character soll beim Angreifen immer stehen bleiben
	#velocity = move_and_slide(velocity)
	#Bewegungseingaben während die Attack-Animation ausgeführt wird, sorgen sonst dafür, dass der Spieler auch nach
	#dem Angriff noch läuft und erst durch die FRICTION abgebremst wird. Spieler soll sofort stillstehen bei Angriff
	if shoot_ready == true:
		emit_signal("shoot_item")
		shoot_ready = false
		ranged_cooldown.wait_time = cooldown_time_ranged
		ranged_cooldown.start()
	state = MOVE

func _on_RangedCooldown_timeout():
	shoot_ready = true
	
func attack_animation_finished():
	state = MOVE

# ------------------- FIREBALL CODE ------------------------ 
func _on_Player_shoot_item():
	shoot_fireball()
	print("Feuerball geschossen")

func shoot_fireball():
	spawn_fireball()
	shoot_item.launch()
	shoot_item = null 	

func spawn_fireball():
	if shoot_item == null:
		shoot_item = Globals.projectile.instance()
		spell_spawn_position.add_child(shoot_item)

# ------------------- DAMAGE AND DEATH CODE ------------------------
func take_damage(dmg):
	stats.health = max(0, stats.health - dmg)
	animation_player.play("Hurt")
	
func _on_PlayerStats_no_health():
	print("Spieler gestorben")
