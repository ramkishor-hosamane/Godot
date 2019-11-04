extends "res://Cars/Car.gd"
var target = null
onready var parent = get_parent()
var speed = 100
var max_speed = 200
var slow_down = false
signal set_path
onready var tree = $"..".get_parent().get_parent()
func _ready():
	#emit_signal("set_path",tree.get_node("PathMain").get_curve())
	pass
func control(delta):

	if parent is PathFollow2D :#and not slow_down:
		parent.set_offset(parent.get_offset() + speed * delta)
		if slow_down:
			speed =lerp(speed,0,0.1)
	
		else:
			speed = lerp(speed,max_speed,0.95)
		#position = Vector2()
	else:
		#other movement
		pass
func _physics_process(delta):

	control(delta)
	if 1 ==2:
		var target_dir = (target.global_position - global_position).normalized()

		var current_dir = Vector2(1,0).rotated(global_rotation)
		global_rotation = current_dir.linear_interpolate(target_dir, 2 * delta).angle()
		acceleration = transform.x * engine_power
		velocity+= acceleration * delta
		velocity = Vector2(engine_power/4,0).rotated(rotation)
		velocity = move_and_slide(velocity)
		print(target_dir,current_dir)
	if target:
		print(rad2deg(.angle_to(target.position)))
		#global_position = global_position.direction_to(target.global_position)
		global_rotation=position.angle_to(target.position)
func _on_look_ahead_body_entered(body):
	slow_down = true
	target = body
	#tree.get_node("currentPath").position = global_position
	#print(tree.get_node("currentPath").position)
	#emit_signal("set_path",tree.get_node("take_left_curve").get_curve())

func _on_look_ahead_body_exited(body):
	slow_down = false
	target = null