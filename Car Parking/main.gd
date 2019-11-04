extends Node
var cannot_spawn = 0
var spwan_count = 0
onready var car = preload("res://Cars/CarPlayer.tscn")
onready var customer = preload("res://characters/Customer.tscn")
onready var nav = $Map1/Navigation2D
var check_car_exit = false
var cust_numbers_list = []
var cust_wait_spaces = [true,true,true,true]
var car_entering_space1 = true
var space_full = false
func _ready():
	randomize()
	global.time = 1000
	
func spawn_customer():
	var custcar = car.instance()
	$Customers.add_child(custcar)
	custcar.car_num = generate_number() 

	custcar.position = $Map1/CustomerSpawn.position
	custcar.rotation = $Map1/CustomerSpawn.rotation
	custcar.state = custcar.STATE.START

	yield(get_tree().create_timer(0.7),"timeout")
	var cust = customer.instance()
	cust.num = custcar.car_num
	cust.rotation-=PI
	cust.position = custcar.position + Vector2(-70,20)
	cust.goal = cust.NavGoals["mall"]
	cust.nav = $Map1/Navigation2D
	set_cust_wait(cust)
	cust.connect("map_update",self,"update_map")
	cust.connect("free_the_slot",self,"free_customer_wait_slots")	
	$Customers.add_child(cust)
	
func _process(delta):
	#print("cannot_spawn",cannot_spawn)
	pass
func _on_spawn_customer_timer_timeout():
	if  (cannot_spawn == 0 or cannot_spawn ==1 ) and not space_full:
		spawn_customer()

	$spawn_customer_timer.wait_time = rand_range(1.5,4.5)







func update_map(cust):
	if cust.goal == cust.NavGoals["mall"]:
		cust.goal = cust.NavGoals["exit0"]

	elif cust.goal == cust.NavGoals["exit0"]:
		cust.goal = cust.NavGoals["exit"]
	elif cust.goal == cust.NavGoals["exit"]:
		cust.global_rotation = $Map1/CustomerWait1.rotation +PI/2
		cust.add_to_group("waiting_for_exit")
		cust.anim = "idle"

	cust.update_path()
	cust.updated = false

func _on_Car_starting_body_entered(body):
	cannot_spawn+=1
	car_entering_space1 = false
func _on_Car_starting_body_exited(body):
	cannot_spawn -=1
	car_entering_space1  = true
	if cannot_spawn == 0:
		$spawn_customer_timer.start()

func _on_Car_Ending_body_entered(body):
	pass
func set_cust_wait(cust):
	var i = 0
	var space_id = []
	var pos = null
	for space in (cust_wait_spaces):
		if space:
			space_id.append(i)
		i+=1

	i = randi() % space_id.size() + space_id[0]
	#print(space_id,i)
	cust.wait_slot = i
	cust_wait_spaces[i] = false
	pos = get_node("Map1/CustomerWait%s" % (i+1))
	cust.NavGoals["exit"] = pos.position
	if true  in cust_wait_spaces:
		pass
	else:
		space_full = true

func generate_number():
	var num = int(rand_range(100,110))
	if num in cust_numbers_list:
		return generate_number()
	
	cust_numbers_list.append(num)
	return num

func free_customer_wait_slots(cust,custcar):
	print("Reached")
	cust_wait_spaces[cust.wait_slot] = true
	cust_numbers_list.remove(cust_numbers_list.find(cust.num))


