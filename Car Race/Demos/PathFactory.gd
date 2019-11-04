extends Node

var path

var pathfollow
#var Boxpath = [
#		[Vector2(100,100)],
#		[Vector2(520,100),Vector2(700,-200),Vector2(100,100)],
#		[Vector2(520,980)],
#		[Vector2(100,980)]
#		]
		
var Curvepath1
var path_to_be_created  = Curvepath1
onready var oppo = preload("res://Demos/OpponentFollow.tscn")
var paths = []
func _ready():
	var o = oppo.instance()
	o.max_health =100
	o.position = get_parent().get_node("startpos").position
	var pos = o.position
	print(pos)
	Curvepath1 = [
			[pos],
			[pos + Vector2(500,0),Vector2(-500,-200),Vector2(100,100)]
			]
	path_to_be_created  = Curvepath1
	path = generatePath()
	drawPathLine(path)
	pathfollow = PathFollow2D.new()
	path.add_child(pathfollow)
	pathfollow.add_child(o)
	print(o.get_parent().name)

func drawPathLine(path):
	var line = Line2D.new()
	line.points = path.curve.get_baked_points()
	line.modulate=  Color(0xffff00f0)
	path.add_child(line)
	
func generatePath():
	return addPath(path_to_be_created,false)
	
	
func createCurve(points,closed=false):
	var curve = Curve2D.new()
	for point in points:
		var position = point[0]
		var inTan = (point[1] if point.size() > 1 else Vector2())
		var outTan = (point[2] if point.size() > 2 else Vector2())
		curve.add_point(position,inTan,outTan)
	if closed:
		curve.add_point(curve.get_point_position(0))
	return curve

func createPath(curve):
	var path2D = Path2D.new()
	path2D.curve = curve
	paths.append(path2D)
	add_child(path2D)
	return path2D
	
func addPath(points,closed =false):
	var curve = createCurve(points,closed)
	return createPath(curve)
	
