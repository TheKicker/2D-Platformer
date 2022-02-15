extends KinematicBody2D

signal death

enum State {NORMAL, DASHING}

export(int, LAYERS_2D_PHYSICS) var dashHazardMask

# Basic config
var gravity = 1000
var velocity = Vector2.ZERO
var horizontalAcceleration = 2000
var maxHorizontalSpeed = 150
var maxDashSpeed = 650
var minDashSpeed = 100
var jumpSpeed = 375
var jumpTerminationMultiplier = 4
var hasDoubleJump = false
var currentState = State.NORMAL
var isStateNew = true
var defaultHazardMask = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$HazardArea.connect("area_entered", self, "on_hazard_area_entered")
	defaultHazardMask = $HazardArea.collision_mask

func on_hazard_area_entered(area2d):
	emit_signal("death")
	
# Processed every frame, delta is seconds since last run (very very small number)
func _process(delta):
	match currentState:
		State.NORMAL:
			process_normal(delta)
		State.DASHING:
			process_dashing(delta)
	isStateNew = false
	
func change_state(newState):
	currentState = newState
	isStateNew = true

func process_normal(delta):
	var moveVector = get_movement_vector()
	
	if (isStateNew):
		$DashHitbox/CollisionShape2D.disabled = true
		$HazardArea.collision_mask = defaultHazardMask
	
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
	
	if(Input.is_action_just_pressed("dash")):
		call_deferred("change_state", State.DASHING)
	
	update_animation()

func process_dashing(delta):
	$AnimatedSprite.play("Dash")
	$HazardArea.collision_mask = dashHazardMask
	if (isStateNew):
		$DashHitbox/CollisionShape2D.disabled = false
		var moveVector = get_movement_vector()
		var velocityMod = 1
		if(moveVector.x != 0):
			velocityMod = sign(moveVector.x)
		else:
			velocityMod = 1 if $AnimatedSprite.flip_h else -1 
		velocity = Vector2(maxDashSpeed * velocityMod, 0)
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.x = lerp(0, velocity.x, pow(2, -10 * delta))
	if (abs(velocity.x) < minDashSpeed):
		call_deferred("change_state", State.NORMAL)

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
	
	
	
	
	
