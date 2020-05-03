extends KinematicBody

# stats
var curHp : int = 10
var maxHp : int = 10
var damage : int = 1

var gold : int = 0

var attackRate : float = 0.3
var lastAttackTime : int = 0

# physics
var moveSpeed : float = 5.0
var jumpForce : float = 10.0
var gravity : float = 15.0

var vel = Vector3()

# components
onready var camera = get_node("CameraOrbit")
onready var attackCast = get_node("AttackRayCast")
onready var swordAnim = get_node("WeaponHolder/SwordAnimator")
onready var label = get_node("Label")
onready var ui = get_node("CanvasLayer/UI")

# called when the node is initialized
func _ready ():
	
	# initialize the UI
	ui.update_health_bar(curHp, maxHp)
	ui.update_gold_text(gold)

# called every physics step (60 times a second)
func _physics_process (delta):
	
	vel.x = 0
	vel.z = 0
	
	var input = Vector3()
	
	# movement inputs
	if Input.is_action_pressed("move_forwards"):
		input.z += 1
	if Input.is_action_pressed("move_backwards"):
		input.z -= 1
	if Input.is_action_pressed("move_left"):
		input.x += 1
	if Input.is_action_pressed("move_right"):
		input.x -= 1
	if Input.is_action_pressed("taunt"):
		label.set_text("You: Come and get me")
		var enemies = get_tree().get_nodes_in_group("enemies")
		for enemy in enemies:
			enemy.taunted()
	
	# normalize the input vector to prevent increased diagonal speed
	input = input.normalized()
	
	# get the relative direction
	var dir = (transform.basis.z * input.z + transform.basis.x * input.x)
	
	# apply the direction to our velocity
	vel.x = dir.x * moveSpeed
	vel.z = dir.z * moveSpeed
	
	# gravity
	vel.y -= gravity * delta
	
	# jump input
	if Input.is_action_pressed("jump") and is_on_floor():
		vel.y = jumpForce
	
	# move along the current velocity
	vel = move_and_slide(vel, Vector3.UP)

func _process (delta):
	
	# attack input
	if Input.is_action_just_pressed("attack"):
		try_attack()

# called when we press the attack button
func try_attack ():
	
	# if we're not ready to attack, return
	if OS.get_ticks_msec() - lastAttackTime < attackRate * 1000:
		return
		
	# set the last attack time to now
	lastAttackTime = OS.get_ticks_msec()
	
	# play the animation
	swordAnim.stop()
	swordAnim.play("attack")
	
	# is the ray cast colliding with an enemy?
	if attackCast.is_colliding():
		if attackCast.get_collider().has_method("take_damage"):
			attackCast.get_collider().take_damage(damage)

# called when we collect a coin
func give_gold (amount):
	
	gold += amount
	
	# update the UI
	ui.update_gold_text(gold)

# called when an enemy deals damage to us
func take_damage (damageToTake):
	
	curHp -= damageToTake
	
	# update the UI
	ui.update_health_bar(curHp, maxHp)
	
	# if our health is 0, die
	if curHp <= 0:
		die()

# called when our health reaches 0
func die ():
	
	# reload the scene
	get_tree().reload_current_scene()






