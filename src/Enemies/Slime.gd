extends KinematicBody2D

onready var healthlabel = $HealthCounter/Label
onready var health_bar = $Bar
onready var stats = $Stats

export var SPEED = 40

onready var walk_timer = $WalkState
var walk_ended = true
var velocity = Vector2.ZERO

var player = null
var player_area = null

onready var hit_box = $HitBox
export var damage = 0

onready var shoot_timer = $ShootTimer
export var ranged_cooldown = 0
var can_shoot = true
onready var projectile_spawn_position = $ProjectileSpawnPosition
onready var xp_reward = (randi() % 3 + 1) * 7

enum{
	WANDER,
	CHASE
}

var state = WANDER

func _ready():
	health_bar.update_healthbar_maxhealth(stats.max_health)
	healthlabel.text = stats.max_health as String

func _physics_process(delta):
	if state == 0:
		$Label.text = "WANDER"
	elif state == 1:
		$Label.text = "CHASE"
		
		
	match state:
		WANDER:
			wander_state(delta)
		
		CHASE:
			chase_player()

func wander_state(delta):
	if walk_ended:
		velocity = Vector2.ZERO
		var x = randi() % 3 -1
		var y = randi() % 3 -1
		velocity = Vector2(x,y)
		walk_ended = false
		walk_timer.one_shot = true
		walk_timer.start()
	velocity = move_and_slide(velocity.normalized() * SPEED)

func _on_WalkState_timeout():
	walk_ended = true

func chase_player():
	velocity = player.global_position - global_position
	velocity = move_and_slide(velocity.normalized() * SPEED)
	try_shoot()
		
func try_shoot():
	if can_shoot:
		shoot_projectile((player.global_position - global_position).normalized())
		can_shoot = false
		shoot_timer.wait_time = ranged_cooldown
		shoot_timer.start()
		state = CHASE
	elif can_shoot == false:
		state = CHASE
	
		
func shoot_projectile(velocity):
	var projectile = Globals.enemy_projectile.instance()
	projectile_spawn_position.add_child(projectile)
	projectile.launch(velocity)
	state = CHASE

func _on_ShootTimer_timeout():
	can_shoot = true

func _on_PlayerDetectionArea_body_entered(body):
	if body.name == "Player":
		player = body
		state = CHASE

func _on_PlayerDetectionArea_body_exited(body):
	if body.name == "Player":
		state = WANDER
	else:
		pass

func _on_Stats_no_health():
	queue_free()
	get_node("../Player/PlayerStats").gain_experience(xp_reward)

func _on_HitBox_area_entered(area):
	if area.get_parent().name == "Player":
		player_area = area
		area.get_parent().take_damage(damage)
		$DamageTimer.start()
	else:
		pass

func _on_DamageTimer_timeout():
	player_area.get_parent().take_damage(damage)
	

func _on_HitBox_area_exited(area):
	$DamageTimer.stop()


