extends RigidBody3D


@export var max_spd : int = 15
@export var acc : int = 10

@onready var scaler = $Scaler
@onready var cam_3d = $"../Camera3D"

var selected : bool = false
var velocity : Vector3
var spd : Vector3
var distance : float = 5
var dir : Vector3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scaler.set_as_top_level(true)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scaler_follow()
	pull_metter()
	
	
	if Input.is_action_just_pressed("left_mb"):
		selected = true
		print("aperta")
	
	if Input.is_action_just_released("left_mb"):
		print("soltar")
		if selected:
			spd = - (dir*distance*acc).limit_length(max_spd)
			print(spd)
			shoot(spd)
		selected = false
	



func shoot(vector:Vector3) -> void:
	velocity = Vector3(vector.x,0,vector.z)
	
	self.apply_impulse(velocity,Vector3.ZERO)

func scaler_follow() -> void:
	scaler.transform.origin = scaler.transform.origin.lerp(self.transform.origin,0.8)

func pull_metter() -> void: 
	var ray_cast = cam_3d.camera_raycast()
	
	
	if not ray_cast.is_empty():
		distance = self.position.distance_to(ray_cast.position)
		dir = self.transform.origin.direction_to(ray_cast.position)
		scaler.look_at(Vector3(ray_cast.position.x,position.y,ray_cast.position.z))
		print('rodando')
		
		if selected:
			scaler.scale.z = clamp(distance,0,2)
		else:
			scaler.scale.z = 0.01
