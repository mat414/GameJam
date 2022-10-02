extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var collected = false
var player_reference

# Called when the node enters the scene tree for the first time.
func _ready():
	player_reference = get_node("/root/Level/Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if !collected && body == player_reference:
		collected = true
		player_reference.heaven_coins += 1
		# Play sound with some randomized pitching
		$CoinSound.pitch_scale = rand_range(0.8, 1.2)
		$CoinSound.play()
		# Destroy area 2D
		$Area2D.queue_free()


func _on_CoinSound_finished():
	# Destroy entire coin after sound is finished
	if collected:
		queue_free()
