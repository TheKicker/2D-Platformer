extends KinematicBody2D

var maxSpeed = 40
var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var gravity = 400
var startDirection = Vector2.RIGHT

func _ready():
	direction = startDirection
	$GoalDetector.connect("area_entered", self, "on_goal_entered")
	$HitboxArea.connect("area_entered", self, "on_hitbox_entered")


func _process(delta):
	velocity.x = (direction * maxSpeed).x
	velocity = move_and_slide(velocity, Vector2.UP)

	velocity.y += gravity * delta

	if is_on_wall():
		direction *= -1

	$AnimatedSprite.flip_h = true if direction.x > 0 else false 


func on_goal_entered(_area2d):
	direction *= -1

func on_hitbox_entered(_area2d):
	queue_free()
