extends KinematicBody2D

var maxSpeed = 20
var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var gravity = 100
var startDirection = Vector2.RIGHT
var player = null

func _ready():
	direction = startDirection
	$GoalDetector.connect("area_entered", self, "on_GoalDetector_area_entered")


func _process(delta):
	velocity.x = (direction * maxSpeed).x
	velocity = move_and_slide(velocity, Vector2.UP)

	velocity.y += gravity * delta

	if is_on_wall():
		direction *= -1

	if(!is_on_floor()):
		$AnimatedSprite.play("jump")
	else:
		$AnimatedSprite.play("drive")
		
	$AnimatedSprite.flip_h = true if direction.x < 0 else false 


func _on_GoalDetector_area_entered(area):
	direction *= -1





