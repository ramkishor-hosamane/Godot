extends Node


var Circle = preload("res://Objects/Circle.tscn")
var Jumper = preload("res://Objects/Jumper.tscn")
var player
var score = -1
func _ready():
	randomize()
	$HUD.hide()
	
func new_game():
	score = -1
	$HUD.update_score(score,score)
	$Camera2D.position = $start_pos.position
	player = Jumper.instance()
	player.position = $start_pos.position
	add_child(player)
	player.connect("captured",self,"_on_Jumper_captured")
	spawn_circle($start_pos.position)
	player.connect("died",self,"_on_Jumper_died")
	$HUD.show()
	$HUD.show_message("Go!")
	if settings.enable_music:
		$Music.play()
	print(settings.enable_music)
func spawn_circle(_position =null):
	var c = Circle.instance()
	if !_position:
		var x = rand_range(-150,150)
		var y = rand_range(-450,-400)
		_position = player.target.position + Vector2(x,y)
	add_child(c)
	c.init(_position)

func _on_Jumper_captured(object):
	$Camera2D.position = object.position
	call_deferred("spawn_circle")
	object.captured(player)
	score+=1
	$HUD.update_score(score-1,score)

func _on_Jumper_died():
	get_tree().call_group("circles","implode")
	$Screens.game_over(score,40)
	$HUD.hide()
	if settings.enable_music:
		$Music.stop()