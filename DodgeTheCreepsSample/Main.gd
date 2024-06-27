extends Node

@export var mob_scene: PackedScene
var score
var paused = false

# Called when the node enters the scene tree for the first time.
#func _ready():
	#pass
#
#
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if  Input.is_action_just_pressed("start_game") && !$MobTimer.is_stopped():
		if(paused):
			pause()
		else:
			resume()
	pass


func game_over():
	$Music.stop()
	$DeathSound.play()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	pass # Replace with function body.
	
func new_game():
	
	get_tree().call_group("mobs","queue_free")
	
	$Music.play()
	
	score = 0
	$HUD.update_score(0)
	$HUD.show_message("Get Ready")
	$Player.start($StartPosition.position)
	$StartTimer.start()


func _on_mob_timer_timeout():
	# Create a new instance of the mob scene
	var mob = mob_scene.instantiate()
	
	# choose a random location on path2d
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	#set the mobs direction perpendicular to the path direction
	var direction = mob_spawn_location.rotation + PI/2
	
	# set the mobs position to a random location
	mob.position = mob_spawn_location.position
	
	# add some randomness to the direction
	direction += randf_range(-PI /4 , PI /4)
	mob.rotation = direction
	
	# choose the velocity of the mob
	var velocity = Vector2(randf_range(150.0,250.0),0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# spawn the mob by adding it to the main scene
	add_child(mob)
	


func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _on_score_timer_timeout():
	score+=1
	$HUD.update_score(score)

func pause():
	paused = false
	get_tree().call_group("gameEntity","pause")
	$HUD/Message.text = "Pause!"
	$HUD/Message.show()
	$MobTimer.paused = true
	$ScoreTimer.paused = true
	
func resume():
	paused = true
	get_tree().call_group("gameEntity","resume")
	$HUD/Message.hide()
	$MobTimer.paused = false
	$ScoreTimer.paused = false
