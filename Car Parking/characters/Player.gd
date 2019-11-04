extends "res://characters/character.gd"


func _ready():
	speed = max_speed
	can_move = true
	
func control(delta):
	anim = "idle"
	velocity = Vector2()
	var rot_dir = 0
	if Input.is_action_pressed("left"):
		rot_dir -= 2
	if Input.is_action_pressed("right"):
		rot_dir += 2
		
	rotation += rot_speed * rot_dir * delta
	if Input.is_action_pressed("forward"):
		anim = "walking"
		velocity += Vector2(speed,0).rotated(rotation) 
	if Input.is_action_pressed("backward"):
		velocity += Vector2(-speed/2,0).rotated(rotation) 
		anim = "walking"


