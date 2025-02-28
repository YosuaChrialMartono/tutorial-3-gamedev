extends CharacterBody2D

@export var gravity = 200.0
@export var walk_speed = 200
@export var jump_speed = -150

# Double Jump Implementation
var amount_jumped = 0

# Dashing Implementation
@export var run_tap_interval = 0.75
@export var running_speed = 300
var last_left_tap_time = 0
var last_right_tap_time = 0
var is_running = false

# Crouching Implementation
@export var crouching_speed = 100

# Animation Implementation
@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	velocity.y += delta * gravity

	if is_on_floor():
		amount_jumped = 0

	if Input.is_action_just_pressed('ui_up'):
		if amount_jumped == 0:
			velocity.y += jump_speed
			amount_jumped = 1
			animated_sprite.play("jump")
		elif amount_jumped == 1:
			velocity.y += jump_speed
			amount_jumped = 2
			animated_sprite.play("jump")

	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
		animated_sprite.flip_h = true
		if Input.is_action_just_pressed("ui_left"):
			if Time.get_ticks_msec() / 1000.0 - last_left_tap_time < run_tap_interval:
				is_running = true
			else:
				is_running = false

			last_left_tap_time = Time.get_ticks_msec() / 1000.0

	if Input.is_action_pressed("ui_right"):
		direction.x += 1
		animated_sprite.flip_h = false
		if Input.is_action_just_pressed("ui_right"):
			if Time.get_ticks_msec() / 1000.0 - last_right_tap_time < run_tap_interval:
				is_running = true
			else:
				is_running = false
			last_right_tap_time = Time.get_ticks_msec() / 1000.0

	if direction != Vector2.ZERO:
		if is_running:
			velocity.x = direction.x * running_speed
			animated_sprite.play("run")
		else:
			velocity.x = direction.x * walk_speed
			animated_sprite.play("walk")

	else:
		velocity.x = 0

	if Input.is_action_pressed("ui_down"):
		velocity.x = direction.x * crouching_speed
		animated_sprite.play("crouch")

	if direction == Vector2.ZERO or velocity.y == 0:
		if is_on_floor():
			if Input.is_action_pressed("ui_down"):
				animated_sprite.play("crouch")
			else:
				animated_sprite.play("idle")
		else:
			animated_sprite.play("falling")

	# "move_and_slide" already takes delta time into account.
	move_and_slide()
