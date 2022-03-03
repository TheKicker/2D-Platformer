extends Node2D

signal victory_royale

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_Area2D_area_entered(area):
	emit_signal("victory_royale")
