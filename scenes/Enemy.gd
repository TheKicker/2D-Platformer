extends KinematicBody2D

var maxSpeed = 40
var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var gravity = 400

# enum is basically a way of defining some values, and we're providing options to a drop down
enum Direction {RIGHT,LEFT}
export (Direction) var startDirection

func _ready():
	direction = Vector2.RIGHT if startDirection == Direction.RIGHT else Vector2.LEFT
	$GoalDetector.connect("area_entered", self, "on_goal_entered")


func _process(delta):
	velocity.x = (direction * maxSpeed).x
	velocity = move_and_slide(velocity, Vector2.UP)

	velocity.y += gravity * delta

	if is_on_wall():
		direction *= -1

	$AnimatedSprite.flip_h = true if direction.x > 0 else false 


func on_goal_entered(_area2d):
	direction *= -1
