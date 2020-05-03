extends KinematicBody

# stats
var curHp : int = 3
var maxHp : int = 3

# attacking
var damage : int = 1
var attackDist : float = 1.5
var attackRate : float = 1.0

# physics
var moveSpeed : float = 2.5

# vectors
var vel : Vector3 = Vector3()

# components
onready var timer = get_node("Timer")
onready var player = get_node("/root/MainScene/Player")
onready var label = get_node("Label")

func _ready ():
	
	add_to_group("enemies")
	# set the timer wait time
	timer.wait_time = attackRate
	timer.start()

func taunted():
	label.set_text("I'll kill you")
# called 60 times a second
func _physics_process (delta):
	
	# get the distance from us to the player
	var dist = translation.distance_to(player.translation)
	
	# if we're outside of the attack distance, chase after the player
	if dist > attackDist:
		# calculate the direction between us and the player
		var dir = (player.translation - translation).normalized()
		
		vel.x = dir.x
		vel.y = 0
		vel.z = dir.z
		
		# move towards the player
		vel = move_and_slide(vel, Vector3.UP)

# called every "attackRate" seconds
func _on_Timer_timeout():
	
	# if we're within the attack distance - attack the player
	if translation.distance_to(player.translation) <= attackDist:
		player.take_damage(damage)

# called when the player deals damage to us
func take_damage (damageToTake):
	
	curHp -= damageToTake
	
	# if our health reaches 0 - die
	if curHp <= 0:
		die()

# called when our health reaches 0
func die ():
	
	# destroy the node
	queue_free()
