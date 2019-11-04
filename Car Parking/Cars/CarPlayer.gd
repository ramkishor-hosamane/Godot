extends "res://Cars/Car.gd"
var can_move = false
var target = null
var car_num = 200
var bump_time = 0
var state = null
enum STATE {START,PARK,EXIT}
var space_to_start = ["first","second"]
onready var game_timer = get_parent().get_parent().get_node("GameTimer")
func _ready():
	space_to_start = "first"
	
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
	if Input.is_action_just_pressed("ui_accept") and target:
		game_timer.wait_time =game_timer.get_time_left() +  5.0
		game_timer.start()
		get_out()
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
	if can_move:
		control(delta)
		velocity +=acceleration *delta
		velocity = move_and_slide(velocity)
		
	elif state == STATE.START:	
		var startpos = get_parent().get_parent().get_node("Map1/CustomerSpawn").position
		if space_to_start == "first":
			position = lerp(position,startpos + Vector2(0,120),0.05)
		elif space_to_start == "second":
			position = lerp(position,startpos + Vector2(0,60),0.05)
		yield(get_tree().create_timer(0.7),"timeout")
		state = STATE.PARK
	if state == STATE.EXIT:
		rotation =PI #lerp(rotation,PI,0.1)
		position+=Vector2(-8,0)
		if target:
			get_out()
		if position.x<=-230:
			queue_free()




func _on_EnteringArea_body_entered(body):
	if body.name =="Player" and state !=STATE.START:
		target = body
		target.hide()
		target.position = Vector2(1000,1000)
		target.can_move = false
		can_move = true

func get_out():
		can_move = false
		velocity = lerp(velocity,Vector2(),0.1)
		var pos = Vector2(450,450)
		if target:
			target.show()
		else:
			return
		if !$lookahead2.is_colliding():
			pos = $lookahead2.global_position
		elif !$lookahead3.is_colliding():
			pos = $lookahead3.global_position
		elif !$lookahead4.is_colliding():
			pos = $lookahead4.global_position
		elif !$lookahead1.is_colliding():
			pos = $lookahead1.global_position
		target.global_position = pos
		target.can_move = true
		target = null

	