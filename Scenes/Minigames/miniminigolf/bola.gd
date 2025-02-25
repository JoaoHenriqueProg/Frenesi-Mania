extends RigidBody3D


@export var max_spd : int = 8
@export var acc : int = 5

@onready var scaler = $Scaler
@onready var cam_3d = $"../Camera3D"
@onready var anim = $"../blockbench_export2/Node/AnimationPlayer"
@onready var objcolidido = $"../blockbench_export2/Node/obj_goal"
#@onready var smesh = $meshbolinha

var selected : bool = false
var velocity : Vector3
var spd : Vector3
var distance : float = 5
var dir : Vector3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scaler.set_as_top_level(true)

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)  
	
	if collision:
		var collider = collision.get_collider()  
		
		if collider == objcolidido: 
			print("Colidiu com obj_goal: ", collider.name)
			anim.play("gol")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scaler_follow()
	pull_metter()
	
	
	if Input.is_action_just_pressed("left_mb"):
		selected = true
		acc = 0
		#update_smesh_color()
		print("aperta")
	else: acc = 5
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


#func update_smesh_color() -> void:
	#var material = smesh.get_active_material(0)
	#var red_intensity = clamp(distance / 5, 0, 1)  
			#
	#material.albedo_color = material.albedo_color.lerp(Color(1, 0, 0), 0.1)
