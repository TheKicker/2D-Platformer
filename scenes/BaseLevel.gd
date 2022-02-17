extends Node

signal coin_total_changed

# Instances the player scene so we don't have to constantly reload it
var playerScene = preload("res://scenes/Player.tscn")
# Basic config
var spawnPoint = Vector2.ZERO
var currentPlayerNode = null
var totalCoins = 0
var collectedCoins = 0
var totalEnemies = 0

func _ready():
	# Get the initial spawn point as set in TileMap
	spawnPoint = $Player.global_position
	register_player($Player)
	# Count the total number of coins availble in the scene
	# totalCoins = get_tree().get_nodes_in_group("coin").size()
	coin_total_change(get_tree().get_nodes_in_group("coin").size())
	totalEnemies = get_tree().get_nodes_in_group("enemy").size()
	print("Coins: ", totalCoins, " / Enemies: ", totalEnemies)

func coin_collected():
	collectedCoins += 1
	emit_signal("coin_total_changed", totalCoins, collectedCoins)

func coin_total_change(newTotal):
	totalCoins = newTotal
	emit_signal("coin_total_changed", totalCoins, collectedCoins)

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

