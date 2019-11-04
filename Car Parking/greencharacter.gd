extends "res://characters/character.gd"

export (float) var turret_speed 
export (int) var detect_radius 

onready var parent = get_parent()

var target = null
func _ready():
	speed = max_speed

func control(delta):
	if parent is PathFollow2D:
		parent.set_offset(parent.get_offset() + speed * delta)
		position = Vector2()
	else:
		#other movement
		pass

func _process(delta):
	pass



