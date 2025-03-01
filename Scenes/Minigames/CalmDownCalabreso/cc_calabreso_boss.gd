extends Node2D

@export var player_controller : int = -1

func _ready() -> void:
	assert(player_controller != -1)
	assert(player_controller < 4)

func _process(delta: float) -> void:
	if player_controller == 0:
		if !$AnimationPlayer.is_playing():
			if Input.is_action_just_pressed("X (Xbox)"):
				$"Porradão".position.x = 192
				$AnimationPlayer.play("bater")
			if Input.is_action_just_pressed("Y (Xbox)"):
				$"Porradão".position.x = 576
				$AnimationPlayer.play("bater")
			if Input.is_action_just_pressed("B (Xbox)"):
				$"Porradão".position.x = 962
				$AnimationPlayer.play("bater")
	else:
		# TODO: ia
		pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.queue_free()
