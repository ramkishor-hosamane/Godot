extends "res://Cars/Car.gd"
var target = null
onready var parent = get_parent()
var speed = 100
var max_speed = 200
var slow_down = false



func control(delta):
	if slow_down:
		speed =lerp(speed,0,0.1)
	else:
		speed = lerp(speed,max_speed,0.95)
	if parent is PathFollow2D :#and not slow_down:
		parent.set_offset(parent.get_offset() + speed * delta)
		position = Vector2()
	else:
		#other movement
		
		print()
	position = Vector2()

func _physics_process(delta):
	control(delta)
	
	
	if target:
		var target_dir = (target.global_position - global_position).normalized()
		var current_dir = Vector2(1,0).rotated(global_rotation)
		global_rotation = current_dir.linear_interpolate(target_dir, 2 * delta).angle()
		acceleration = transform.y * engine_power
		velocity+= acceleration * delta
		velocity = Vector2(engine_power/4,0).rotated(rotation)
		velocity = move_and_slide(velocity)



func _on_look_ahead_body_entered(body):
	slow_down = true
	target = body
func _on_look_ahead_body_exited(body):
	slow_down = false
	target = null