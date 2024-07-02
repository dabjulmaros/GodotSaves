extends CharacterBody3D

# emitted when the player jumped on the mob.
signal squashed

# minimun speed of the mob in meters per second
@export var min_speed = 10
# maximun speed of the mob in meters per second
@export var max_speed = 18

func _physics_process(delta):
	move_and_slide()

# this function will be called from the main menu
func initialize(start_position, player_position):
	# we position the mob by placing it at start_position
	# and rotate it towards the player_position, so it looks at the player
	look_at_from_position(start_position,player_position, Vector3.UP)
	
	# rotate this mob randomly wihin the range of -45 and +45 degrees,
	# so that it doenst move directly towards the player
	rotate_y(randf_range(-PI/4,PI/4))
	
	# calculate random speed
	var random_speed = randi_range(min_speed,max_speed)
	# calculate foward velocity that represents speed
	velocity = Vector3.FORWARD * random_speed
	# then rotate the velocity vector based on the mobs y roation
	# in order to move in the direction its look
	velocity = velocity.rotated(Vector3.UP, rotation.y)


func _on_visibility_notifier_screen_exited():
	queue_free()

func squash():
	squashed.emit()
	queue_free()
