extends Node



onready var oppo = $OpponentNavigation
onready var nav = $Navigation2D
var points = [Vector2(400, 450), Vector2(700,  450), Vector2(700, 700), Vector2(400, 700)]

func _ready():
	randomize()
	oppo.position = $startpos.position
	oppo.goal = $endpos.position
	oppo.nav = nav
	#connect("map_update",self,"update_map")





func make_polygon_instance(points):
	var polygon = NavigationPolygon.new()
	var outline = PoolVector2Array(points)
	polygon.add_outline(outline)
	polygon.make_polygons_from_outlines()
	$Navigation2D/NavigationPolygonInstance.navpoly= polygon
func update_map():
	#if oppo.goal == $endpos.position:
	#	oppo.goal = $startpos.position
	#elif oppo.goal == $startpos.position:
	#	oppo.goal= $endpos.position
	#make_polygon_instance(points)
	print("Updated")
	oppo.goal= $endpos.position
	#oppo.nav = oppo.get_node("mynavigation")
	oppo.update_path()
	oppo.updated = false