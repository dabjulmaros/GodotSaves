extends Node

@export var mob_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mob_timer_timeout():
	# create a new instance of the mob scene
	var mob = mob_scene.instantiate()
	
	# chose a random location on the spawnpath
	# we store the reference to the spawnlocation node
	var mob_spawn_location = $SpawnPath/SpawnLocation
	# give it a random offset
	mob_spawn_location.progress_ratio = randf()
	
	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position,player_position)
	
	# spawn child mob in the main scene
	add_child(mob)
