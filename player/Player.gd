extends KinematicBody2D

signal char_stuck
signal player_died
signal coins_changed(new_heaven_coins, new_hell_coins)

const WALK_FORCE = 600
const WALK_MAX_SPEED = 200
const STOP_FORCE = 1300
const JUMP_SPEED = 150
const DASH_SPEED = 720

var heaven_coins = 0 setget heaven_coin_set
var hell_coins = 0 setget hell_coin_set

var jump_key_pressed = false
var jump_key_hold_time = 0
var jump_max_hold_time = 0.3
var jump_max_count = 2
var jump_current_count = 0
var was_jumping = false

var dash_ability_enabled = true
var time_between_dashes = 0.1
var time_since_last_dash = 0
var can_dash = true
var was_dashing = false
var dash_direction = 0
var dash_time_remaining = 0
var dash_max_time = 0.12

var velocity = Vector2()

onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _input(event):
	if event.is_action_pressed("jump"):
		jump()
	elif event.is_action_released("jump"):
		stop_jumping()

func on_jumped():
	# Additional jumps get pitched slightly higher
	$JumpSound.pitch_scale = 1 + (jump_current_count - 1) * 0.2
	$JumpSound.play()

func jump():
	jump_key_pressed = true
	jump_key_hold_time = 0
	
func stop_jumping():
	jump_key_pressed = false
	reset_jump_state()
	
func check_jump_input(delta):
	if jump_key_pressed:
		var is_first_jump = jump_current_count == 0
		if is_first_jump && !is_on_floor():
			jump_current_count += 1
			
		# Actually do the jump
		var did_jump = can_jump()
		if did_jump:
			velocity.y = -JUMP_SPEED
			
			if !was_jumping:
				jump_current_count += 1
				on_jumped()
				
		was_jumping = did_jump
	
func clear_jump_input(delta):
	if jump_key_pressed:
		jump_key_hold_time += delta
		
		if jump_key_hold_time >= jump_max_hold_time:
			jump_key_pressed = false
	else:
		was_jumping = false	
	
func can_jump():
	var jump_allowed = true
	if !was_jumping || jump_max_hold_time <= 0:
		if jump_current_count == 0 && !is_on_floor():
			jump_allowed = jump_current_count + 1 < jump_max_count
		else:
			jump_allowed = jump_current_count < jump_max_count
	else:
		var jump_key_held = (jump_key_pressed && jump_key_hold_time < jump_max_hold_time)
		jump_allowed = jump_key_held && ((jump_current_count < jump_max_count) || (was_jumping && jump_current_count == jump_max_count))
	
	return jump_allowed

func reset_jump_state():
	jump_key_pressed = false
	was_jumping = false
	jump_key_hold_time = 0
	
	if is_on_floor():
		jump_current_count = 0

func _process(delta):
	if velocity.x < 0:
		$AnimatedSprite.flip_h = true
	elif velocity.x > 0:
		$AnimatedSprite.flip_h = false

func _physics_process(delta):
	# Horizontal movement code. First, get the player's input.
	var walk = WALK_FORCE * (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	# Slow down the player if they're not trying to move.
	if abs(walk) < WALK_FORCE * 0.2:
		# The velocity, slowed down a bit, and then reassigned.
		velocity.x = move_toward(velocity.x, 0, STOP_FORCE * delta)
	else:
		velocity.x += walk * delta
	# Clamp to the maximum horizontal movement speed.
	velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)

	# Vertical movement code. Apply gravity.
	velocity.y += gravity * delta
	
	check_jump_input(delta)
	clear_jump_input(delta)
	
	if dash_ability_enabled && !is_on_floor() && can_dash && time_since_last_dash > time_between_dashes &&  walk != 0 && !was_dashing && Input.is_action_just_pressed("jump"):
		was_dashing = true
		can_dash = false
		dash_direction = sign(walk)
		dash_time_remaining = dash_max_time
		# Random pitch for dash
		$WhooshSound.pitch_scale = rand_range(0.8, 1.2)
		$WhooshSound.play()
		
	if was_dashing:
		velocity.x = dash_direction * DASH_SPEED
		dash_time_remaining -= delta
		velocity.y = 0
		if dash_time_remaining <= 0:
			dash_time_remaining = 0
			was_dashing = false
			time_since_last_dash = 0
	else:
		time_since_last_dash += delta

	# Move based on the velocity and snap to the ground.
	velocity = move_and_slide(velocity, Vector2.UP)
	#velocity = move_and_slide_with_snap(velocity, transform.y, -1 * transform.y)

	# Check for jumping. is_on_floor() must be called after movement code.
	if is_on_floor():
		reset_jump_state()
		can_dash = true
	
func _on_Level_level_state_changed(is_heaven):
	if is_heaven:
		jump_max_count = 2
		dash_ability_enabled = false
		$DetectArea.collision_mask = 4
	else:
		jump_max_count = 1
		dash_ability_enabled = true
		$DetectArea.collision_mask = 2


func kill():
	on_killed()
	emit_signal("player_died")

func _on_Area2D_body_entered(body):
	on_killed()
	emit_signal("char_stuck")
	
func on_killed():
	$DeathSound.play()
	
func heaven_coin_set(new_heaven_coins):
	heaven_coins = new_heaven_coins
	
	emit_signal("coins_changed", heaven_coins, hell_coins)
	
func hell_coin_set(new_hell_coins):
	hell_coins = new_hell_coins
	
	emit_signal("coins_changed", heaven_coins, hell_coins)
	
