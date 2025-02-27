extends Node

@onready var colisorhand = $hand/spr_hand/Area2D/CollisionShape2D
signal hit


func emit_hit():
	emit_signal("hit")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
