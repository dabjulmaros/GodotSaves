extends Label
var score = 0
var multiplier = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_mob_squashed():
	score += multiplier
	multiplier += 2 * multiplier
	text = "Scored: %s" % score


func _on_player_touched_the_ground():
	multiplier = 1

