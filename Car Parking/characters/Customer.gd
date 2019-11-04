extends "res://characters/character.gd"

var num 
var NavGoals = {"mall":Vector2(350,-100),"exit0":Vector2(350,100),"exit":null}

var wait_slot
signal free_the_slot
signal map_update
var nav = null setget set_nav
var path = []
var goal =  Vector2()
var updated=false

func set_nav(new_nav):
	$Node/Number_board/Label.set_text(str(num))
	nav = new_nav
	#print("goal",goal)
	update_path()

func update_path():

	path = nav.get_simple_path(position,goal,false)
	#print(path)
	if path.size()==0:
		pass
		#print("No path")
		
func _ready():
	speed = max_speed
	anim = "walking"

	
func _process(delta):
	$Node.global_position = global_position+Vector2(10,-60)
	$Node.global_rotation = 0
	if path.size() > 0:
		var d = position.distance_to(path[0])
		if d > 2:
			var target_dir = (Vector2(path[0][0],path[0][1]) - global_position).normalized()
			var current_dir = Vector2(1,0).rotated(global_rotation)
			global_rotation = current_dir.linear_interpolate(target_dir, 4 * delta).angle()
			set_position(position.linear_interpolate(path[0],(speed * delta)/d))#.rotated(rotation))
		else:
			path.remove(0)
	elif not updated:
		updated = true
		emit_signal("map_update",self)


func _on_Look_for_car_body_entered(body):
	if body.car_num == num:
		emit_signal("free_the_slot",self,body)
		

		body.get_out()
		body.state=body.STATE.EXIT
		yield(get_tree().create_timer(0.7),"timeout")
		queue_free()

		