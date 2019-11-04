extends Area2D

onready var orbit_position = $Piviot/Orbit_position


var radius = 80
var rotation_speed = PI


func init(_position,_radius = radius):
	position = _position
	radius = _radius
	$Collision.shape = $Collision.shape.duplicate()
	$Collision.shape.radius = radius

	var img_size = $Sprite.texture.get_size().x / 3
	$Sprite.scale =  Vector2 (1,1) * radius  / img_size
	orbit_position.position.x = radius + 25
	rotation_speed *= pow(-1,randi() %2)
	
func _process(delta):
	$Piviot.rotation+=rotation_speed * delta
