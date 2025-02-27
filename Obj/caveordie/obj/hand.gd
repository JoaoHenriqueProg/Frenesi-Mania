extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("left_mb"):
		CodGlobal.colisorhand = global_position
		CodGlobal.emit_hit()
		
		


func _on_body_entered(body: Node2D) -> void:
	pass
