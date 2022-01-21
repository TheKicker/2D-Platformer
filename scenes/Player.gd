extends KinematicBody2D

# Basic config
var gravity = 1000
var velocity = Vector2.ZERO
var horizontalAcceleration = 2000
var maxHorizontalSpeed = 140
var jumpSpeed = 375
var jumpTerminationMultiplier = 4
var hasDoubleJump = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Processed every frame, delta is seconds since last run (very very small number)
func _process(delta):
	var moveVector = get_movement_vector()
	
	# Combine our vector, with acceleration and delta
	velocity.x += moveVector.x * horizontalAcceleration * delta
	
	# Slow down the player when button is released
	if (moveVector.x == 0):
		# Lerp is basically (from, to, how far between 0 and 1) so lerp(0, 10, 0.5) will equal 5
		# Linear Interpolation to find all the points between two 
		# pow(2, x * delta) allows us to be framerate independent.  No matter what you play on the deceleration is the same
		velocity.x = lerp(0, velocity.x, pow(2, -50 * delta))
	
	# Limits our positive and negative speed to our maximmum horizontal speed
	velocity.x = clamp(velocity.x, -maxHorizontalSpeed, maxHorizontalSpeed)
	
	# Removes the ability to spam jump, player must be on the floor or just left it (Coyote timer)
	if (moveVector.y < 0 && (is_on_floor() || !$CoyoteTimer.is_stopped() || hasDoubleJump)):
		velocity.y = moveVector.y * jumpSpeed
		if(!is_on_floor() && $CoyoteTimer.is_stopped()):
			hasDoubleJump = false
		$CoyoteTimer.stop()
	
	# Allows the player to control the height of their jumps (tap versus hold)
	if (velocity.y < 0 && !Input.is_action_pressed("jump")):
		velocity.y += gravity * jumpTerminationMultiplier * delta
	else:
		velocity.y += gravity * delta
	
	var wasOnFloor = is_on_floor()
	
	# Calculates the collisions and movements before looping to the next FPS
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if(wasOnFloor && !is_on_floor()):
		$CoyoteTimer.start()
	
	if(is_on_floor()):
		hasDoubleJump = true
	
	update_animation()

func get_movement_vector():
	# Vector2 is used for 2D Math calculations, if left 0 it amounts to False
	var moveVector = Vector2.ZERO
	
	# If right is pressed 1 moves right, if left is pressed -1 moves left, else or both zero out
	moveVector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	# Unless we jump, the default is zero
	moveVector.y = -1 if Input.is_action_just_pressed("jump") else 0
	
	return moveVector

func update_animation():
	var moveVect = get_movement_vector()
	
	if(!is_on_floor()):
		$AnimatedSprite.play("Jump")
	elif(moveVect.x != 0):
		$AnimatedSprite.play("Run")
	else:
		$AnimatedSprite.play("Idle")
	
	if(moveVect.x != 0):
		$AnimatedSprite.flip_h = true if moveVect.x > 0 else false
	
	
	
	
	
