extends Node3D

@onready var bola = $"../../bola"
@onready var anim = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if bola.position.y < 0 :
		anim.play("gol")
	pass
