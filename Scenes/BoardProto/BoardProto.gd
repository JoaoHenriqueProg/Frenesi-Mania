extends Node3D

var global_delta

enum BoardState {
	WaitingPlayerJump,
	ChoseNumber,
	PlayerWalkingToPos,
	GoToMinigame,
}
var board_state = BoardState.WaitingPlayerJump

var cur_player = 0
var camera_offset

@onready var players = $Players.get_children()

var rng = RandomNumberGenerator.new()
var cur_mg

func _ready() -> void:
	camera_offset = players[0].position - $Camera3D.position

var randomizing_mg = true # todo: coco

func change_state(new_state):
	board_state = new_state
	
	if new_state == BoardState.GoToMinigame:
		$Gui.show()
		# todo: mais coco
		var timer1 = get_tree().create_timer(1)
		timer1.connect("timeout", func (): randomizing_mg = false)
		var timer2 = get_tree().create_timer(2)
		timer2.connect("timeout", func (): go_to_mg())
	if new_state == BoardState.ChoseNumber:
		var more_steps = rand_dice()
		
		player_logic_positions[cur_player] += more_steps
		player_logic_positions[cur_player] %= $Steps.get_child_count()

func rand_dice() -> int:
	var nums = [1, 2, 3, 4, 5, 6]
	var num = nums[rng.randi() % nums.size()]
	if num == 1:
		$Dado.rotation.x = 0
		$Dado.rotation.y = 0
		$Dado.rotation.z = deg_to_rad(-90)
	elif num == 2:
		$Dado.rotation.x = deg_to_rad(-90)
		$Dado.rotation.y = deg_to_rad(180)
		$Dado.rotation.z = deg_to_rad(90)
	elif num == 3:
		$Dado.rotation.x = deg_to_rad(-90)
		$Dado.rotation.y = 0
		$Dado.rotation.z = 0
	elif num == 4:
		$Dado.rotation.x = deg_to_rad(-90)
		$Dado.rotation.y = deg_to_rad(-180)
		$Dado.rotation.z = 0
	elif num == 5:
		$Dado.rotation.x = deg_to_rad(90)
		$Dado.rotation.y = deg_to_rad(-90)
		$Dado.rotation.z = deg_to_rad(180)
	elif num == 6:
		$Dado.rotation.x = 0
		$Dado.rotation.y = deg_to_rad(180)
		$Dado.rotation.z = deg_to_rad(90)
	
	return num

func rotate_dice():
	get_node("Dado").rotation.x += 30 * global_delta
	get_node("Dado").rotation.y += 40 * global_delta
	get_node("Dado").rotation.z += 50 * global_delta

func _process(delta: float) -> void:
	global_delta = delta
	
	if Input.is_action_just_pressed("DEBUG 1"):
		Globals.start_rand_minigame()
	
	$Camera3D.position = players[cur_player].position - camera_offset
	
	if randomizing_mg:
		cur_mg = Globals.minigames[rng.randi() % Globals.minigames.size()]
		$Gui/Control/Label.text = cur_mg.mg_name
	
	if board_state == BoardState.WaitingPlayerJump:
		micro_adjust_players_pos()
		rotate_dice()
		if Input.is_action_just_pressed("jump"):
			players[cur_player].jump()
			
			# TODO: isso aqui é muito cagado
			var timer1 = get_tree().create_timer(0.25)
			timer1.connect("timeout", func (): change_state(BoardState.ChoseNumber))
			var timer2 = get_tree().create_timer(0.5)
			timer2.connect("timeout", func (): change_state(BoardState.PlayerWalkingToPos))
	elif board_state == BoardState.PlayerWalkingToPos:
		if !are_players_in_postion():
			move_player_to_next_position(cur_player)
		else:
			if cur_player != 3:
				cur_player += 1
				change_state(BoardState.WaitingPlayerJump)
			else:
				change_state(BoardState.GoToMinigame)

# ÁREA DA MOVIMENTACÃO

var player_logic_positions = [0, 0, 0, 0]
var player_cur_positions = [0, 0, 0, 0]

func move_player_to_next_position(player):
	var cur_player = players[player]
	var player_world_pos := Vector2(cur_player.global_position.x, cur_player.global_position.z)
	var next_step = (player_cur_positions[player] + 1) % 18
	var next_step_world_pos := Vector2($Steps.get_children()[next_step].global_position.x, 
									   $Steps.get_children()[next_step].global_position.z)
	
	var adding = player_world_pos.direction_to(next_step_world_pos).normalized() * 7.5 * global_delta
	
	cur_player.position.x += adding.x
	cur_player.position.z += adding.y
	
	if cur_player.position.distance_to($Steps.get_children()[next_step].position) < 1.5:
		# cur_player.position.x = $Steps.get_children()[player_cur_positions[player] + 1].position.x
		# cur_player.position.z = $Steps.get_children()[player_cur_positions[player] + 1].position.z
		player_cur_positions[player] += 1
		player_cur_positions[player] %= $Steps.get_child_count()

func micro_adjust_players_pos():
	for i in range(4):
		var position_in_step = 0
		for j in range(i):
			if player_logic_positions[i] == player_logic_positions[j]:
				position_in_step += 1
		
		var desired_pos = $Steps.get_children()[player_logic_positions[i]].position
		desired_pos.x += position_in_step * 2
		
		players[i].position = Vector3(
			lerp(players[i].position.x, desired_pos.x, 0.1),
			lerp(players[i].position.y, desired_pos.y, 0.1),
			lerp(players[i].position.z, desired_pos.z, 0.1)
		)

func are_players_in_postion():
	return player_cur_positions == player_logic_positions

# todo: mais coco ainda
func go_to_mg():
	Globals.start_minigame(cur_mg.mg_name)
