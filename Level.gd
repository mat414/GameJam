extends Node2D

enum {Heaven, Hell}

const hell_bg = Color8(82,9,9,255)
const heaven_bg = Color8(21,138,173,255)
var shift_bg = Gradient.new()

var vis_state
var mask_state

var last_respawn_point = Vector2(200, 300)

signal level_state_changed(state)

# Called when the node enters the scene tree for the first time.
func _ready():
	vis_state = Hell
	mask_state = Hell
	$Background.color = hell_bg
	$Heaven.modulate.a = 0
	shift_bg.set_color(0, hell_bg)
	shift_bg.set_color(1, heaven_bg)
	$Player/AnimatedSprite.animation = "devil"
	
	emit_signal("level_state_changed", false)
	
	#$Player.connect("coins_changed", $HUD, "_on_Player_coins_changed")
	for respawn_point in get_tree().get_nodes_in_group("Respawn"):
		respawn_point.connect("respawn_point_touched", self, "set_respawn_point")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not $SwitchVisTimer.is_stopped():
		var alpha = lerp(1, 0, $SwitchVisTimer.time_left/$SwitchVisTimer.wait_time)
		if vis_state == Hell:
			$Hell.modulate.a = 1-alpha
			$Heaven.modulate.a = alpha
			$Background.color = shift_bg.interpolate(alpha)
		else:
			$Hell.modulate.a = alpha
			$Heaven.modulate.a = 1-alpha
			$Background.color = shift_bg.interpolate(1-alpha)


func _on_ShowTimer_timeout():
	$SwitchVisTimer.start()
	$SwitchMaskTimer.start()


func _on_SwitchVisTimer_timeout():
	vis_state = Heaven if vis_state == Hell else Hell
	if vis_state == Heaven:
		$Background.color = heaven_bg
		$Heaven.modulate.a = 1
		$Hell.modulate.a = 0
	else: 
		$Background.color = hell_bg
		$Heaven.modulate.a = 0
		$Hell.modulate.a = 1


func _on_SwitchMaskTimer_timeout():
	if mask_state == Hell:
		mask_state = Heaven
		$Player/AnimatedSprite.animation = "angel"
	else:
		mask_state = Hell
		$Player/AnimatedSprite.animation = "devil"
	$Player.collision_mask ^= 0x6
	
	emit_signal("level_state_changed", mask_state == Heaven)



func _on_Player_char_stuck():
	_on_Player_player_died()

func _on_Player_player_died():
	$Player.position = last_respawn_point
	print("You died")

func set_respawn_point(pos):
	last_respawn_point = pos
