extends Node2D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("DEBUG 1"):
		var scores : Array[int] = [0,0,0,0]
		var score_inp = [$Score0, $Score1, $Score2, $Score3]
		
		for i in range(4):
			if score_inp[i].text.is_valid_int():
				scores[i] = int(score_inp[i].text)
		
		Globals.modify_player_scores(scores)
		Globals.return_to_board()
