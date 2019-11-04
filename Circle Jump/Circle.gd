extends Area2D

onready var orbit_position = $Piviot/Orbit_position
enum MODES {STATIC,LIMITED}
var mode = MODES.STATIC
var num_orbits = 3
var current_orbits = 0
var orbit_start = null
var jumper = null


var radius = 80
var rotation_speed = PI


func init(_position,_radius = radius,_mode = MODES.STATIC):
	set_mode(_mode)
	position = _position
	radius = _radius
	$Sprite.material = $Sprite.material.duplicate()
	$SpriteEffect.material = $Sprite.material
	$Collision.shape = $Collision.shape.duplicate()
	$Collision.shape.radius = radius

	var img_size = $Sprite.texture.get_size().x / 3
	$Sprite.scale =  Vector2 (1,1) * radius  / img_size
	orbit_position.position.x = radius + 25
	rotation_speed *= pow(-1,randi() %2)
	
func _process(delta):
	$Piviot.rotation+=rotation_speed * delta
	if mode == MODES.LIMITED and jumper:
		check_orbits()
		update()
func check_orbits():
	if abs($Piviot.rotation -  orbit_start) > 2 * PI:
		current_orbits-=1
		if settings.enable_sound:
			$Beep.play()
		if current_orbits <=0:
			jumper.die()
			jumper = null
			implode()
		$Label.text =  str(current_orbits)
		orbit_start = $Piviot.rotation
func set_mode(_mode):
	mode = _mode
	var color
	match mode:
		MODES.STATIC:
			$Label.hide()
			color = settings.theme["circle_static"]
		MODES.LIMITED:

			current_orbits = num_orbits
			$Label.text = str(num_orbits)
			$Label.show()
			color = settings.theme["circle_limited"]
	$Sprite.material.set_shader_param("color", color)


func _draw():
	if mode != MODES.LIMITED:
		return
	if jumper:
		var r = ((radius * 0.5) / num_orbits) * (1 + current_orbits)
		draw_circle_arc_poly(Vector2.ZERO, r, orbit_start + PI/2,
							$Piviot.rotation + PI/2,settings.theme["circle_fill"])
												
func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	points_arc.push_back(center)
	var colors = PoolColorArray([color])
	
	for i in range(nb_points + 1):
		var angle_point = angle_from + i * (angle_to - angle_from) / nb_points - PI/2
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)







func implode():
	$AnimationPlayer.play("Implode")
	yield($AnimationPlayer,"animation_finished")
	queue_free()
func captured(target):
	jumper = target
	
	$AnimationPlayer.play("Captured")
	$"Piviot".rotation = (jumper.position  - position).angle()
	orbit_start = $Piviot.rotation