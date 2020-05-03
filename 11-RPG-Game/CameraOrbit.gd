extends Spatial

# look stats
var lookSensitivity : float = 15.0
var minLookAngle : float = -20.0
var maxLookAngle : float = 75.0

# vectors
var mouseDelta = Vector2()

# components
onready var player = get_parent()

# called when the node is initialized
func _ready ():
	
	# hide the mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# called every frame
func _process (delta):
	
	# get the rotation to apply to the camera and player
	var rot = Vector3(mouseDelta.y, mouseDelta.x, 0) * lookSensitivity * delta
	
	# camera vertical rotation
	rotation_degrees.x += rot.x
	rotation_degrees.x = clamp(rotation_degrees.x, minLookAngle, maxLookAngle)
	
	# player horizontal rotation
	player.rotation_degrees.y -= rot.y
	
	# clear the mouse movement vector
	mouseDelta = Vector2()

# called when an input is detected
func _input (event):
	
	# set "mouseDelta" when we move our mouse
	if event is InputEventMouseMotion:
		mouseDelta = event.relative
		
