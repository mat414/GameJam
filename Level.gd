extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const MODULATE_SCALAR = 2
var active_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Heaven.modulate.a = 1
	$Hell.modulate.a = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(delta):
	if active_index == 1:
		$Heaven.modulate.a = lerp($Heaven.modulate.a, 0, delta * MODULATE_SCALAR)
		$Hell.modulate.a = 1 - $Heaven.modulate.a
	else:
		$Heaven.modulate.a = lerp($Heaven.modulate.a, 1, delta * MODULATE_SCALAR)
		$Hell.modulate.a = 1 - $Heaven.modulate.a
		
	if $Heaven.modulate.a <= 0.2:
		$Heaven.collision_layer = 2
		$Hell.collision_layer = 1
	if $Hell.modulate.a <= 0.2:
		$Heaven.collision_layer = 1
		$Hell.collision_layer = 2

func _on_Timer_timeout():
	
	active_index ^= 1
