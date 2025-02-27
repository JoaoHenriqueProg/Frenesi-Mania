extends TileMap

var cell 


func _ready() -> void: 
	pass

func _process(delta: float) -> void:
		CodGlobal.hit.connect(destroy)

func destroy():
		cell = local_to_map(CodGlobal.colisorhand)
		print('quebro',cell)
		set_cell(0,cell,-1)
	
