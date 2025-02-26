extends Node3D

var global_delta

enum BoardState {
	WaitingPlayerJump,
	ChoseNumber,
	PlayerWalkingToPos,
}
var board_state = BoardState.WaitingPlayerJump

var cur_player = 0
var camera_offset

func _ready() -> void:
	camera_offset = $"Players/Player 1".position - $Camera3D.position

func change_state(new_state):
	board_state = new_state
	
	if new_state == BoardState.ChoseNumber:
		var more_steps = rand_dice()
		
		# TODO: DINAMICAR PRA VARIOS PLAYERS
		player_logic_positions[0] += more_steps
		player_logic_positions[0] %= $Steps.get_child_count()

func rand_dice() -> int:
	var nums = [1,2,3,4,5,6]
	var rng = RandomNumberGenerator.new()
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
	
	$Camera3D.position = get_node("Players").get_children()[cur_player].position - camera_offset
	
	if board_state == BoardState.WaitingPlayerJump:
		rotate_dice()
		if Input.is_action_just_pressed("jump"):
			$AnimationPlayer.play("Player1Jump")
	elif board_state == BoardState.PlayerWalkingToPos:
		if !are_players_in_postion():
			move_player_to_next_position(0)

# ÁREA DA MOVIMENTACÃO

var player_logic_positions = [0, 0, 0, 0]
var player_cur_positions = [0, 0, 0, 0]

func move_player_to_next_position(player):
	var cur_player = $Players.get_children()[player]
	var player_world_pos := Vector2(cur_player.global_position.x, cur_player.global_position.z)
	var next_step_world_pos := Vector2($Steps.get_children()[player_cur_positions[player] + 1].global_position.x, 
									   $Steps.get_children()[player_cur_positions[player] + 1].global_position.z)
	
	var adding = player_world_pos.direction_to(next_step_world_pos).normalized() * 7.5 * global_delta
	
	cur_player.position.x += adding.x
	cur_player.position.z += adding.y
	
	if cur_player.position.distance_to($Steps.get_children()[player_cur_positions[player] + 1].position) < 1.5:
		# cur_player.position.x = $Steps.get_children()[player_cur_positions[player] + 1].position.x
		# cur_player.position.z = $Steps.get_children()[player_cur_positions[player] + 1].position.z
		player_cur_positions[player] += 1

func are_players_in_postion():
	return player_cur_positions == player_logic_positions
