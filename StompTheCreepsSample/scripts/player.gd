extends CharacterBody3D

# Emitted signal when the players was hit by a mob
signal hit

#how fast the player moves in meters per second
@export var speed = 14

# Vertical impulse applied to the character upon jumpin in meters per second.
@export var jump_impulse = 20

# Vertical impulse applied to the character upun bouncing over a mob
# in meters per second.
@export var bounce_impulse = 16

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
	
	# Jumping
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
	
	# iterate through all the collisions that occurred this frame
	for index in range(get_slide_collision_count()):
		# We get one of the collisions with the player
		var collision = get_slide_collision(index)
		
		#if the collision is with the ground
		if collision.get_collider()==null:
			continue
		
		# If the collision is with a mob
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			
			# We check that we are hitting it from above
			#FIXED
			# the tutorial calls for 0.1 but the monsters seem to be spawning too low
			# or almost inside the ground, by making the normal over .2 seems to fix it
			# a permanent solution would fix the monster spawn
			if Vector3.UP.dot(collision.get_normal())>0.1:
				# If so we squash and bounce
				mob.squash()
				target_velocity.y = bounce_impulse
				# Prevent further duplicate calls.
				print("squish")
				break
			else:
				print("died")
	
	# moving the character 
	velocity = target_velocity
	move_and_slide()

func die():
	hit.emit()
	queue_free()

#func _on_mob_detector_body_entered(body):
	#print("died")
	#die()


