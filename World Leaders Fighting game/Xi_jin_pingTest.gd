extends CharacterBody2D


const SPEED = 150
const JUMP_VELOCITY = -500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#double jump
var jumps
@onready var M_animation = $AnimationPlayer
@onready var sprite: Sprite2D = get_node("Spritesheet(2)Scaled3xPngcrushedScaled2xPngcrushed") 
#attack debug
var attack = false
var punch = false
var projectile = false
var passive = false
var honey = false
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction and attack == false:
		velocity.x = direction * SPEED
		
	elif direction and not is_on_floor():
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if Input.is_action_pressed("ui_left"):
		sprite.flip_h = true
	elif Input.is_action_pressed("ui_right"):
		sprite.flip_h = false
	walking()
	jump()
	actions()
	move_and_slide()
	

func actions():
	if Input.is_action_just_pressed("basic attack") and projectile == false and passive == false:
		attack = true
		punch = true
		M_animation.play("punch")
		await get_tree().create_timer(0.9).timeout
		attack = false
		punch = false
		#_on_Timer_timeout()
		return
	elif Input.is_action_just_pressed("projectile attack") and is_on_floor() and passive == false and punch == false:
		attack = true
		projectile = true
		M_animation.play("projectile")
		await get_tree().create_timer(1.2).timeout
		attack = false
		projectile = false

	elif Input.is_action_just_pressed("Passive") and is_on_floor() and projectile == false and punch == false:
		attack = true
		passive = true
		honey = true
		M_animation.play("Passive")
		await get_tree().create_timer(2).timeout
		attack = false
		passive = false
func timer(x):
	await get_tree().create_timer(x).timeout
	return 
#jump function
func jump():
	if Input.is_action_pressed("jump") and is_on_floor() and honey == false:
		velocity.y = JUMP_VELOCITY
		jumps = 1
		M_animation.play("Jump")
		
	elif Input.is_action_just_pressed("jump") and is_on_floor() and honey == true:
		velocity.y = JUMP_VELOCITY
		jumps = 1
		M_animation.play("Honey_jump")
		
	elif Input.is_action_just_pressed("jump") and not is_on_floor() and jumps == 1 and honey == false:
		velocity.y = JUMP_VELOCITY
		jumps = 0
		M_animation.play("double_jump")
	elif Input.is_action_just_pressed("jump") and not is_on_floor() and jumps == 1 and honey == true:
		velocity.y = JUMP_VELOCITY
		jumps = 0
		M_animation.play("Honey_double_jump")
	return
func walking():
	#walking
	if is_on_floor() and velocity.x == 0 and attack == false and honey == false:
		M_animation.play("idle")
	
	elif is_on_floor() and velocity.x != 0 and attack == false and honey == false:
		M_animation.play("Walking")
	

