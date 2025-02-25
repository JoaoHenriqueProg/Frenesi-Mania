extends Camera3D

@onready var bola = $".."

const ray_l = 1000
var mouse_pos : Vector2
var from : Vector3
var to : Vector3
var space : PhysicsDirectSpaceState3D
var query : PhysicsRayQueryParameters3D

var vector : Vector3

var offset
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.set_as_top_level(true)
	offset = bola.position - position

func _process(delta: float) -> void:
	vector  = Vector3(bola.transform.origin.x,position.y,bola.transform.origin.z)
	position = bola.position - offset
	# camera_follow()
	


func camera_follow() -> void:
	vector  = Vector3(bola.transform.origin.x,position.y,bola.transform.origin.z)
	
	self.transform.origin = self.transform.origin.lerp(vector,1)


func camera_raycast():
	mouse_pos = get_viewport().get_mouse_position()
	var from = project_ray_origin(mouse_pos)
	var to = from + project_ray_normal(mouse_pos) * ray_l
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collision_mask = 0xFFFFFFFF  # Detecta qualquer camada
	
	var result = space.intersect_ray(query)
	
	return result
