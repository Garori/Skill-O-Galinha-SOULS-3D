extends CharacterBody3D


var SPEED = 50.0
const JUMP_VELOCITY = 4.5
@export var sensivity = 600

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	
func _physics_process(delta):
	# Add the gravity.
	#if not is_on_floor():
		#velocity.y -= gravity * delta
	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
	if Input.is_action_pressed("ui_accept"):
		SPEED = 200
	else:
		SPEED = 50
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x,0,input_dir.y)).normalized()
	if direction.x:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		velocity.y = direction.y * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()
	
func _input(event):
	if event is InputEventMouseMotion:
		if rotation.z >= 0:
			rotation.y -= (event.relative.x/sensivity)
			rotation.x -= (event.relative.y/sensivity)
		else:
			rotation.y += (event.relative.x/sensivity)
			rotation.x += (event.relative.y/sensivity)
		
		#print_debug(rotation)
		
		#$cameraPivot.rotation.x = $cameraPivot.rotation.x/sensivity
		
