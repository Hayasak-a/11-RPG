extends Area

export var goldToGive : int = 1
var rotateSpeed : float = 5.0

# called every frame
func _process (delta):
	
	# rotate along the Y axis
	rotate_y(rotateSpeed * delta)
	
# called when a body enters the coin collider
func _on_GoldCoin_body_entered (body):
	
	# is this the player? If so give them gold
	if body.name == "Player":
		body.give_gold(goldToGive)
		queue_free()
