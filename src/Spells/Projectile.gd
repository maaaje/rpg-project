extends KinematicBody2D
class_name Projectile

export var SHOOT_VELOCITY : float = 1.5
const MAX_FLIGHT_TIME : float = 2.0

export var damage = 5

var velocity = Vector2.ZERO
var flight_timer = null
onready var start_position = position

func _ready():
	set_physics_process(false)
	

func _physics_process(delta):
	var collision = move_and_collide(velocity)
	if collision != null:
		on_impact(collision)

func launch(direction, speed_multiplier = 1):
	var temp = global_transform
	var scene = get_tree().current_scene
	
	get_parent().remove_child(self)
	scene.add_child(self)
	global_transform = temp
	
	look_at(get_global_mouse_position())
	velocity = SHOOT_VELOCITY * direction.normalized() * speed_multiplier
	
	set_physics_process(true)
	
	flight_timer = Timer.new()
	flight_timer.one_shot = true
	flight_timer.wait_time = MAX_FLIGHT_TIME
	flight_timer.autostart = true
	flight_timer.connect("timeout", self, "destroy")
	add_child(flight_timer)


func on_impact(collision):
	if collision.collider.name == "Player":
		collision.collider.take_damage(damage)
	queue_free()

func destroy():
	queue_free()

