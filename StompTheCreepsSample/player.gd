extends CharacterBody3D

#how fast the player moves in meters per second
@export var speed = 14

# the downward acceleration when in the air, in meters per second square
@export var fall_acceleration = 75

var target_velocity = Vector3.ZERO

func _physics_process(delta):
	# We create a local variable to store the input direction
	var direction = Vector3.ZERO
	
	# We check for each move input and update the direction accordingly
	if Input.is_action_pressed("move_right"):
		direction.x +=1
	if Input.is_action_pressed("move_left"):
		direction.x -=1
	if Input.is_action_pressed("move_up"):
		# in 3d the xz plane is the ground plane
		direction.z -=1
	if Input.is_action_pressed("move_down"):
		direction.z +=1

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		# Setting the basis property will affect the rotation of the node
		$Pivot.basis = Basis.looking_at(direction)
	
	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	# Vertical Velocity
	if not is_on_floor(): # if in the air, fall  towards floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration*delta)
	
	# moving the character 
	velocity = target_velocity
	move_and_slide()
