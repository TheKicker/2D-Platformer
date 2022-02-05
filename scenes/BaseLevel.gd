extends Node

# Instances the player scene so we don't have to constantly reload it
var playerScene = preload("res://scenes/Player.tscn")
# Basic config
var spawnPoint = Vector2.ZERO
var currentPlayerNode = null

func _ready():
	# Get the initial spawn point as set in TileMap
	spawnPoint = $Player.global_position
	register_player($Player)

# Listens to the player death, adds the signal connection for player death
func register_player(player):
	currentPlayerNode = player
	# On player death, call itself to func player died.  Deferred to prevent physics callback error
	currentPlayerNode.connect("death", self, "on_player_died", [], CONNECT_DEFERRED)

func create_player():
	var playerInstance = playerScene.instance()
	# Create a new player node below the current one (to preserve node order)
	add_child_below_node(currentPlayerNode,playerInstance)
	# Spawn at our designated spawnpoint
	playerInstance.global_position = spawnPoint
	# Register the player and listen for events (like player death)
	register_player(playerInstance)

func on_player_died():
	# Remove the old player, spawn a new one 
	currentPlayerNode.queue_free()
	create_player()
