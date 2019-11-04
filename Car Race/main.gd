extends Node

func _ready():

	$currentPath.position = Vector2(0,0)

	$currentPath.rotate(PI/2)
func set_path_for_opponent(curve):
	$currentPath.position = $currentPath/PathFollow2D/Opponent.global_position
	$currentPath.rotation = $currentPath/PathFollow2D/Opponent.global_rotation
	#$currentPath/PathFollow2D/Opponent.global_rotation =
	$currentPath.set_curve(curve)
	print("Path seting over",$currentPath.position)
	#$currentPath/PathFollow2D/Opponent.global_position = $currentPath.position 
