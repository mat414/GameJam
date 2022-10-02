extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var from : Vector2 = Vector2(0, 0)
export var to : Vector2 = Vector2(0, 0)
export var time : float = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	var anim = Animation.new()
	anim.add_track(0)
	anim.length = time

	var path = ".:position"
	anim.track_set_path(0, path)
	anim.track_insert_key(0, 0.0, from)
	anim.track_insert_key(0, time / 2, to)
	anim.track_insert_key(0, time, from)
	anim.value_track_set_update_mode(0, Animation.UPDATE_CONTINUOUS)
	anim.loop = true

	var anim_player = $Platform/AnimationPlayer
	anim_player.add_animation("test", anim)
	anim_player.set_current_animation("test")
	anim_player.play("test")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Heaven_settings_changed():
	pass # Replace with function body.
