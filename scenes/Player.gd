extends KinematicBody2D

var gravity = 1000
var velocity = Vector2.ZERO
var horizontalAcceleration = 2000
var maxHorizontalSpeed = 140
var jumpSpeed = 375
var jumpTerminationMultiplier = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Processed every frame, delta is seconds since last run (very very small number)
func _process(delta):
	
	
	var moveVector = Vector2.ZERO
	moveVector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	moveVector.y = -1 if Input.is_action_just_pressed("jump") else 0
	
	velocity.x += moveVector.x * horizontalAcceleration * delta
	if (moveVector.x == 0):
		velocity.x = lerp(0, velocity.x, pow(2, -50 * delta))
	
	velocity.x = clamp(velocity.x, -maxHorizontalSpeed, maxHorizontalSpeed)
	
	if (moveVector.y < 0 && is_on_floor()):
		velocity.y = moveVector.y * jumpSpeed
	
	if (velocity.y < 0 && !Input.is_action_pressed("jump")):
		velocity.y += gravity * jumpTerminationMultiplier * delta
	else:
		velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
