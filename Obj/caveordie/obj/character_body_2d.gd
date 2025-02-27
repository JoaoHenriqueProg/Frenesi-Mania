extends CharacterBody2D



const SPEED = 300.0
const JUMP_VELOCITY = -300.0

@onready var anim = $AnimatedSprite2D
@onready var hand = $hand
@onready var spr_hand = $hand/spr_hand
@onready var self_spr = $AnimatedSprite2D

@onready var colisorhand = $hand/spr_hand/Area2D

var track = false


func _physics_process(delta: float) -> void:
	var direction := Vector2 (Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
	#GRAVIDADE
	if not is_on_floor():
		velocity += get_gravity() * delta
	
		
		
	if not _track():
		self_spr.modulate = Color(1,1,1,1)
		#MOVIMENTÇÃO
		if direction.x:
			velocity.x = direction.x * SPEED
			anim.play("walk")
			anim.flip_h = direction.x < 0
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			anim.play("idle")
		move_and_slide()
		_jump()
	else:
		self_spr.modulate = Color(1, 1, 1, 0.5)
		anim.play("idle", 0)
	
	if direction:
		hand.rotation = direction.normalized().angle()
		spr_hand.position.x = 15
		spr_hand.modulate = Color(1,1,1,1)
	else:
		spr_hand.position.x = 0
		spr_hand.modulate = Color(0,0,0,0)
	CodGlobal.hit.connect(playhit)

func playhit():
	anim.play("hit")

func test():
	pass



func _jump():
	#PULO
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		print("pulo")
		velocity.y = JUMP_VELOCITY
	if velocity.y:
		anim.play("jump")




func _track():
	if is_on_floor():
		if Input.is_action_pressed("right_mb"):
			track = true
		else:
			track = false
		
	return track
