extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -750.0

@export var player_controller : int = -1

var global_delta

func _ready() -> void:
	assert(player_controller != -1)
	assert(player_controller < 4)

var dash_timer = 0

func _physics_process(delta: float) -> void:
	global_delta = delta
	if player_controller == 0:
		# TODO: checar se o controle está conectado
		apply_gravity()

		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("ui_left", "ui_right")
		
		var is_dashing = Input.is_action_just_pressed("B (Xbox)") and dash_timer == 0
		
		if direction:
			velocity.x = move_toward(velocity.x, direction * SPEED, SPEED)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		if is_dashing: velocity.x *= 7.5
	else:
		apply_gravity()
		# TODO: ia
	
	move_and_slide()

func apply_gravity():
	if not is_on_floor():
		velocity += get_gravity() * global_delta * 1.25
		if velocity.y > 0:
			velocity.y *= 1.1
