extends Position2D

# enum is basically a way of defining some values, and we're providing options to a drop down
enum Direction {RIGHT,LEFT}
export (Direction) var startDirection

export(PackedScene) var EnemyScene

var currentEnemyNode = null
var spawnOnNextTick = false

func _ready():
	$Timer.connect("timeout", self, "check_enemy_spawn")
	call_deferred("spawn_enemy")
	

func spawn_enemy():
	currentEnemyNode = EnemyScene.instance()
	currentEnemyNode.startDirection = Vector2.RIGHT if startDirection == Direction.RIGHT else Vector2.LEFT
	get_parent().add_child(currentEnemyNode)
	currentEnemyNode.global_position = global_position

func check_enemy_spawn():
	if(!is_instance_valid(currentEnemyNode)):
		if(spawnOnNextTick):
			spawn_enemy()
			spawnOnNextTick = false
		else:
			spawnOnNextTick = true
