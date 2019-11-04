extends CanvasLayer
var total_time
onready var game_timer = get_parent().get_node("GameTimer")
func _ready():
	print(game_timer.name)
	total_time = game_timer.get_wait_time()
func _process(delta):
	update_time()

func update_time():
	var value = int(game_timer.get_time_left())
	$MarginContainer/TimeLeft/Tween.interpolate_property($MarginContainer/TimeLeft/Bar,"value",$MarginContainer/TimeLeft/Bar.value,value * 100/total_time,0.3,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$MarginContainer/TimeLeft/Tween.start()
	
	$MarginContainer/TimeLeft/Time.set_text(str(value))
	#$MarginContainer/TimeLeft/Bar.value = (value * 100/game_timer.get_wait_time())

	if value % 4 ==0:
		$MarginContainer/TimeLeft/AnimationPlayer.play("scale")