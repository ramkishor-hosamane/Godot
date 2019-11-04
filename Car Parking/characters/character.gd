extends KinematicBody2D

export (PackedScene) var Bullet
export (int) var max_speed
export (float) var rot_speed

var velocity = Vector2()
var speed
var anim = null
var can_move = false
signal shoot

func _ready():
	pass


func control(delta):
	pass

func _physics_process(delta):
	if can_move:
		control(delta)

		velocity = move_and_slide(velocity)
	else:
		velocity = Vector2()

	$body.set_animation(anim)
	$body.play()

