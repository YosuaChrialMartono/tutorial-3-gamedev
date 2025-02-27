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

func _physics_process(delta):
	velocity.y += delta * gravity

	if is_on_floor():	
		amount_jumped = 0

	if Input.is_action_just_pressed('ui_up'):
		if amount_jumped == 0:
			velocity.y += jump_speed
			amount_jumped = 1
		elif amount_jumped == 1:
			velocity.y += jump_speed
			amount_jumped = 2

	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
		$Sprite2D.flip_h = true
		if Input.is_action_just_pressed("ui_left"):
			if Time.get_ticks_msec() / 1000.0 - last_left_tap_time < run_tap_interval:
				is_running = true
			else:
				is_running = false
			
			last_left_tap_time = Time.get_ticks_msec() / 1000.0

	if Input.is_action_pressed("ui_right"):
		direction.x += 1
		$Sprite2D.flip_h = false
		if Input.is_action_just_pressed("ui_right"):
			if Time.get_ticks_msec() / 1000.0 - last_right_tap_time < run_tap_interval:
				is_running = true
			else:
				is_running = false
			last_right_tap_time = Time.get_ticks_msec() / 1000.0

	if direction != Vector2.ZERO:
		if is_running:
			velocity.x = direction.x * running_speed
		else:
			velocity.x = direction.x * walk_speed

	else:
		velocity.x = 0
		
	
	if Input.is_action_pressed("ui_down"):
		$Sprite2D.texture = load("res://assets/kenney_platformercharacters/PNG/Adventurer/Poses/adventurer_duck.png")
		velocity.x = direction.x * crouching_speed
	else:
		$Sprite2D.texture = load("res://assets/kenney_platformercharacters/PNG/Adventurer/Poses/adventurer_idle.png")

	# "move_and_slide" already takes delta time into account.
	move_and_slide()
