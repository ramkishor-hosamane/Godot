extends KinematicBody2D

export (int) var speed
signal map_update
var nav = null setget set_nav
var path = []
var goal =  Vector2()
var updated=false
func set_nav(new_nav):
	nav = new_nav
	print("goal",goal)
	update_path()

func update_path():
	path = nav.get_simple_path(position,goal,true)
	print(path)
	if path.size()==0:
		print("No path")
		
func _ready():
	pass
func _process(delta):
	if path.size() > 0:
		var d = position.distance_to(path[0])
		if d > 2:
			var target_dir = (Vector2(path[0][0],path[0][1]) - global_position).normalized()
			var current_dir = Vector2(1,0).rotated(global_rotation)
			global_rotation = current_dir.linear_interpolate(target_dir, 4 * delta).angle()
			set_position(position.linear_interpolate(path[0],(speed * delta)/d))#.rotated(global_rotation))
		else:
			path.remove(0)
	elif not updated:
		updated = true
		emit_signal("map_update")
