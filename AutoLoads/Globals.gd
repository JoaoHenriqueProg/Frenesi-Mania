extends Node

enum States {
	InMainGame,
	InMiniGame
}
var state = States.InMainGame

func _process(delta: float) -> void:
	# SÓ PRA DEBUG, TIRAR DEPOIS
	# Inentrável 
	if state == States.InMiniGame and false:
		if Input.is_action_just_pressed("DEBUG 1"):
			return_to_board()

var minigames = [
	{
		mg_name = "Exemplo 1",
		packed_scene = preload("res://Scenes/Minigames/Example1/MGExample1.tscn"),
	},
	{
		mg_name = "Exemplo 2",
		packed_scene = preload("res://Scenes/Minigames/Example2/MGExample2.tscn"),
	},
	{
		mg_name = "Exemplo 3",
		packed_scene = preload("res://Scenes/Minigames/Example3/MGExample3.tscn"),
	},
	# preload("res://Scenes/Minigames/Minigolf/MGMinigolf.tscn")
]

func start_rand_minigame():
	var rng = RandomNumberGenerator.new()
	var new_mg = minigames[rng.randi() % minigames.size()]
	get_parent().get_node("MainGame").set_process(false)
	get_parent().get_node("MainGame").visible = false
	get_parent().get_node("MainGame/Gui").visible = false
	var mg_node = new_mg.packed_scene.instantiate()
	get_parent().add_child(mg_node)
	
	state = States.InMiniGame

func start_minigame(mg_name):
	for mg in minigames:
		if mg.mg_name == mg_name:
			get_parent().get_node("MainGame").set_process(false)
			get_parent().get_node("MainGame").visible = false
			get_parent().get_node("MainGame/Gui").visible = false
			var mg_node = mg.packed_scene.instantiate()
			get_parent().add_child(mg_node)
			
			state = States.InMiniGame

var player_scores := [0, 0, 0, 0]

func modify_player_scores(modifiers: Array[int]):
	assert(modifiers.size() == 4)
	
	for i in range(4):
		player_scores[i] += modifiers[i]

func return_to_board():
	get_parent().get_node("MiniGame").queue_free()
	get_parent().get_node("MainGame").set_process(true)
	get_parent().get_node("MainGame").visible = true
	
	# TODO: esse aqui não dura nem mais dois dias sem quebrar o jogo todo
	get_parent().get_node("MainGame/Camera3D").current = true
	
	state = States.InMainGame
