extends Node2D

signal victory_royale

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_Area2D_area_entered(area):
	emit_signal("victory_royale")
	#	vr_change_scene()

#	func vr_change_scene():
	# 	get_tree().change_scene("res://scenes/Levels/Lvl_00"+str(int(get_tree().current_scene.filename[-8])+1)+".tscn")
	#	var currentLevel = get_tree().current_scene.filename
	#	print(currentLevel[-6])
	#	currentLevel = int(currentLevel[-6])
	#	var nextLevel = str(currentLevel + 1)
	#	get_tree().change_scene("res://scenes/Levels/Lvl_00"+nextLevel+".tscn")
