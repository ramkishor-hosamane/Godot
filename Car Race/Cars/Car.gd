extends KinematicBody2D

export (int) var max_health
export (int) var wheel_base
export (int) var engine_power
export (int) var braking 
export (int) var max_speed_reverse

var steering_angle = deg2rad(15)
var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var steer_direction 
var friction = -2
var drag = -0.001
var slip_speed = 400
var traction_fast = 0.1
var traction_slow = 0.7
var alive= true
var health

signal health_changed
signal dead


func _ready():
	health= max_health
	emit_signal("health_changed",health * 100/max_health)


func control(delta):
	pass


func take_damage(amount):
	health-=amount
	emit_signal("health_changed",health * 100/max_health)
	if health<=0:
		explode()
		
		


func explode():
	$collsion.disabled = true
	alive =false
	
	#$body.hide()
	#$explosion.show()
	#$explosion.play("fire")

