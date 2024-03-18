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
var punch = P2GlobalSetting.punch2
var projectile = false
#passive variable controls animation debug
var passive = false
var kick = P2GlobalSetting.kick2
#honey values
var honey_hits = 0
#health
var health = P2GlobalSetting.p2health
#defense
var defense = false
#flip value
var flip = true
#Knockback Values
var knockback_strength = 5000
var knockback_vector
var knockback_direction

@onready var M_animation = $AnimationPlayer
func _ready():
	add_to_group("Player_2")

func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	var direction = Input.get_axis("left_p2", "right_p2")
	if direction and attack == false:
		velocity.x = direction * SPEED
		
	elif direction and not is_on_floor():
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if Input.is_action_pressed("left_p2"):
		if flip == false:
			self.scale.x = -1
			flip = true
		else:
			flip = true
	elif Input.is_action_pressed("right_p2"):
		if flip == true:
			self.scale.x = -1
			flip = false
		else:
			flip = false
	if honey_hits < 0 or honey_hits == 0:
		P2GlobalSetting.passive2 = false
	
	walking()
	jump()
	actions()
	move_and_slide()

func actions():
	
	if projectile == false and passive == false and P2GlobalSetting.kick2 == false and P2GlobalSetting.punch2 == false:
		#_on_Timer_timeout()
		if Input.is_action_just_pressed("basic attack_p2") and P2GlobalSetting.passive2 == true:
			attack = true
			P2GlobalSetting.punch2 = true
			honey_hits -= 1
			M_animation.play("Honey_punch")
			await get_tree().create_timer(0.5).timeout
			attack = false
			P2GlobalSetting.punch2 = false
		elif Input.is_action_just_pressed("basic attack_p2") and P2GlobalSetting.passive2 == false:
			attack = true
			P2GlobalSetting.punch2 = true
			M_animation.play("punch")
			await get_tree().create_timer(0.5).timeout
			attack = false
			P2GlobalSetting.punch2 = false
		elif Input.is_action_just_pressed("kick attack_p2") and P2GlobalSetting.passive2 == false:
			attack = true
			P2GlobalSetting.kick2 = true
			M_animation.play("Kick")
			await get_tree().create_timer(0.9).timeout
			attack = false
			P2GlobalSetting.kick2 = false
		elif Input.is_action_just_pressed("kick attack_p2") and P2GlobalSetting.passive2 == true:
			attack = true
			P2GlobalSetting.kick2 = true
			honey_hits -= 1
			M_animation.play("honey_kick")
			await get_tree().create_timer(0.9).timeout
			attack = false
			P2GlobalSetting.kick2 = false
		elif Input.is_action_just_pressed("projectile attack_p2") and is_on_floor():
			attack = true
			projectile = true
			M_animation.play("projectile")
			await get_tree().create_timer(1.2).timeout
			attack = false
			projectile = false

		elif Input.is_action_just_pressed("passive_p2") and is_on_floor():
			attack = true
			passive = true
			honey_hits = 5
			P2GlobalSetting.passive2 = true
			M_animation.play("Passive")
			await get_tree().create_timer(2).timeout
			attack = false
			passive = false
		elif Input.is_action_just_pressed("block_p2") and is_on_floor() and P2GlobalSetting.passive2 == true:
			defense = true
			P2GlobalSetting.p2defense = true
			M_animation.play("Honey_defense")
			await get_tree().create_timer(0.5).timeout
			defense = false
			P2GlobalSetting.p2defense = false
		elif Input.is_action_just_pressed("block_p2") and is_on_floor() and P2GlobalSetting.passive2 == false:
			defense = true
			P2GlobalSetting.p2defense = true
			M_animation.play("defense")
			await get_tree().create_timer(0.5).timeout
			defense = false
			P2GlobalSetting.p2defense = false
	return
#jump function
func jump():
	
	if Input.is_action_pressed("jump_p2") and is_on_floor() and P2GlobalSetting.passive2 == false:
		velocity.y = JUMP_VELOCITY
		jumps = 1
		M_animation.play("Jump")
		
	elif Input.is_action_just_pressed("jump_p2") and is_on_floor() and P2GlobalSetting.passive2 == true:
		velocity.y = JUMP_VELOCITY
		jumps = 1
		M_animation.play("Honey_jump")
		
	elif Input.is_action_just_pressed("jump_p2") and not is_on_floor() and jumps == 1 and P2GlobalSetting.passive2 == false:
		velocity.y = JUMP_VELOCITY
		jumps = 0
		M_animation.play("double_jump")
	elif Input.is_action_just_pressed("jump_p2") and not is_on_floor() and jumps == 1 and P2GlobalSetting.passive2 == true:
		velocity.y = JUMP_VELOCITY
		jumps = 0
		M_animation.play("Honey_double_jump")
	return
func walking():
	#walking
	
	if is_on_floor() and velocity.x == 0 and attack == false and P2GlobalSetting.passive2 == false and defense == false:
		M_animation.play("idle")
	
	elif is_on_floor() and velocity.x != 0 and attack == false and P2GlobalSetting.passive2 == false and defense == false:
		M_animation.play("Walking")
	
	elif is_on_floor() and velocity.x == 0 and attack == false and P2GlobalSetting.passive2 == true and defense == false:
		M_animation.play("Honey_idle")
	
	elif is_on_floor() and velocity.x != 0 and attack == false and P2GlobalSetting.passive2 == true and defense == false:
		M_animation.play("Honey_walk")
	return
#damage

func damage():
	
	if P2GlobalSetting.p2defense == false or P2GlobalSetting.p2shield < 0 or P2GlobalSetting.p2shield == 0:
		if P1GlobalSetting.punch1 == true and P1GlobalSetting.passive1 == false:
			P2GlobalSetting.p2health -= 10
		elif  P1GlobalSetting.punch1 == true and P1GlobalSetting.passive1 == true:
			P2GlobalSetting.p2health -= 15
		elif  P1GlobalSetting.kick1 == true and P1GlobalSetting.passive1 == false:
			P2GlobalSetting.p2health -= 20
		elif P1GlobalSetting.kick1 == true and P1GlobalSetting.passive1 == true:
			P2GlobalSetting.p2health -= 25
	elif P2GlobalSetting.p2defense == true:
		if P1GlobalSetting.punch1 == true and P1GlobalSetting.passive1 == false:
			P2GlobalSetting.p2shield -= 10
		elif P1GlobalSetting.punch1 == true and P1GlobalSetting.passive1 == true:
			P2GlobalSetting.p2shield -= 15
		elif P1GlobalSetting.kick1 == true and P1GlobalSetting.passive1 == false:
			P2GlobalSetting.p2shield -= 20
		elif P1GlobalSetting.kick1 == true and P1GlobalSetting.passive1 == true:
			P2GlobalSetting.p2shield -= 25
	
func knockback():
	print(attack)
	print(defense)
	print(P2GlobalSetting.p2defense)
	#if defense is false then deal knockback as usual
	if defense == false and attack == true and P1GlobalSetting.p1defense == true:
		if flip == true:
			knockback_direction = Vector2(1, 0)  # Adjust the direction as needed
			print("should be working")
		elif flip == false:
			knockback_direction = Vector2(-1, 0)
			print("should be working")
	elif defense == false and attack == false:
		if flip == true:
			knockback_direction = Vector2(1, 0)  # Adjust the direction as needed
		elif flip == false:
			knockback_direction = Vector2(-1, 0)
	elif defense == true:
		knockback_direction = Vector2(0,0)
	knockback_vector = knockback_direction.normalized() * knockback_strength
	# Apply the knockback
	position += knockback_vector * get_process_delta_time()

