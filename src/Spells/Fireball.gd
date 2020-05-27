extends KinematicBody2D

const SHOOT_VELOCITY : float = 2.0
const MAX_FLIGHT_TIME : float = 1.0

var damage = 5 + randi() % 2 + 1 #macht 5-7 Schaden

var velocity = Vector2.ZERO
var flight_timer = null
onready var start_position = position

func _ready():
	set_physics_process(false)
	

func _physics_process(delta):
	var collision = move_and_collide(velocity)
	if collision != null:
		on_impact(collision)

func launch():
	var temp = global_transform
	var scene = get_tree().current_scene
	var direction = get_global_mouse_position() - global_position
	
	get_parent().remove_child(self)
	scene.add_child(self)
	global_transform = temp
	
	look_at(get_global_mouse_position())
	velocity = SHOOT_VELOCITY * direction.normalized()
	
	set_physics_process(true)
	
	flight_timer = Timer.new()
	flight_timer.one_shot = true
	flight_timer.wait_time = MAX_FLIGHT_TIME
	flight_timer.autostart = true
	flight_timer.connect("timeout", self, "destroy")
	add_child(flight_timer)

func on_impact(collision):
	deal_damage(collision)
	queue_free()

func destroy():
	queue_free()
	
func deal_damage(collision):
	var hit = collision.collider
	if hit.is_in_group("enemies"):
		hit.take_damage(damage)
