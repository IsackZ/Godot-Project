extends CharacterBody2D


const SPEED = 150
const JUMP_VELOCITY = -500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#double jump
var jumps
#animation variables

#attack debug
#attack animations are buggy
var attack = false
var punch = false
var projectile = false
var passive = false
var kick = false
#honey values
var honey = false
var honey_hits = 0
#health
var health = 100
var previousHealth = GlobalHealth.p1health

@onready var M_animation = $AnimationPlayer

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
		get_node("Spritesheet").flip_h = true
	elif Input.is_action_pressed("ui_right"):
		get_node("Spritesheet").flip_h = false
	if honey_hits < 0 or honey_hits == 0:
		honey = false
	walking()
	jump()
	actions()
	move_and_slide()
	

func actions():
	
	if projectile == false and passive == false and kick == false and punch == false:
		#_on_Timer_timeout()
		if Input.is_action_just_pressed("basic attack_p1") and honey == true:
			attack = true
			punch = true
			honey_hits -= 1
			M_animation.play("Honey_punch")
			await get_tree().create_timer(0.5).timeout
			attack = false
			punch = false
		elif Input.is_action_just_pressed("basic attack_p1") and honey == false:
			attack = true
			punch = true
			M_animation.play("punch2")
			await get_tree().create_timer(0.5).timeout
			attack = false
			punch = false
		elif Input.is_action_just_pressed("Kick_attack_p1") and honey == false:
			attack = true
			kick = true
			M_animation.play("Kick")
			await get_tree().create_timer(0.9).timeout
			attack = false
			kick = false
		elif Input.is_action_just_pressed("Kick_attack_p1") and honey == true:
			attack = true
			kick = true
			honey_hits -= 1
			M_animation.play("honey_kick")
			await get_tree().create_timer(0.9).timeout
			attack = false
			kick = false
		elif Input.is_action_just_pressed("projectile attack_p1") and is_on_floor():
			attack = true
			projectile = true
			M_animation.play("projectile")
			await get_tree().create_timer(1.2).timeout
			attack = false
			projectile = false

		elif Input.is_action_just_pressed("Passive_p1") and is_on_floor():
			attack = true
			passive = true
			honey = true
			honey_hits = 5
			M_animation.play("Passive")
			await get_tree().create_timer(2).timeout
			attack = false
			passive = false
	return
#jump function
func jump():
	
	if Input.is_action_pressed("jump_p1") and is_on_floor() and honey == false:
		velocity.y = JUMP_VELOCITY
		jumps = 1
		M_animation.play("Jump")
		
	elif Input.is_action_just_pressed("jump_p1") and is_on_floor() and honey == true:
		velocity.y = JUMP_VELOCITY
		jumps = 1
		M_animation.play("Honey_jump")
		
	elif Input.is_action_just_pressed("jump_p1") and not is_on_floor() and jumps == 1 and honey == false:
		velocity.y = JUMP_VELOCITY
		jumps = 0
		M_animation.play("double_jump")
	elif Input.is_action_just_pressed("jump_p1") and not is_on_floor() and jumps == 1 and honey == true:
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
	
	elif is_on_floor() and velocity.x == 0 and attack == false and honey == true:
		M_animation.play("Honey_idle")
	
	elif is_on_floor() and velocity.x != 0 and attack == false and honey == true:
		M_animation.play("Honey_walk")
	return
#damage

func damage():
	if GlobalHealth.p1player != previousHealth:
		velocity.x = -SPEED
