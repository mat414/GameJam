extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var active = false

signal respawn_point_touched(position)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_active(is_active):
	active = is_active
	print("I've been set to active: ", active)
	# Do graphical updates here
	$AnimatedSprite.animation = "active" if active else "inactive"

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		emit_signal("respawn_point_touched", position)
		
		# Set all other respawn points to inactive
		get_tree().call_group_flags(SceneTree.GROUP_CALL_REALTIME, "Respawn", "set_active", false)
		set_active(true)
