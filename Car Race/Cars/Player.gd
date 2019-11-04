extends "res://Cars/Car.gd"


func get_input():
	var turn = 0
	if Input.is_action_pressed("right"):
		turn +=1
	if Input.is_action_pressed("left"):
		turn -=1
	steer_direction = turn * steering_angle
	if Input.is_action_pressed("forward"):
		acceleration = transform.x * engine_power
	if Input.is_action_pressed("backward"):
		acceleration = transform.x * braking
	if turn:
		$tire1.rotation = lerp(0,steer_direction,0.7)
		$tire2.rotation = lerp(0,steer_direction,0.7)
	else:
		$tire1.rotation = 0
		$tire2.rotation = 0

func caluculate_steering(delta):
	var rear_wheel = position  - transform.x * wheel_base /2.0
	var front_wheel = position  + transform.x * wheel_base /2.0
	rear_wheel+= velocity * delta
	front_wheel+= velocity.rotated(steer_direction) * delta
	var new_heading = (front_wheel - rear_wheel).normalized()
	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = velocity.linear_interpolate(new_heading * velocity.length(),traction)
	if d< 0:
		velocity = -new_heading * min(velocity.length(),max_speed_reverse)
	rotation = new_heading.angle()


	
func apply_friction():
	if  velocity.length() < 5:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	acceleration += drag_force + friction_force
func control(delta):
	get_input()
	apply_friction()
	caluculate_steering(delta)

func _physics_process(delta):
	acceleration = Vector2.ZERO
	control(delta)
	velocity += acceleration * delta
	velocity = move_and_slide(velocity)
