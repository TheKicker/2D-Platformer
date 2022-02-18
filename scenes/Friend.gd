extends Node2D

signal hello_there

func _ready():
	pass

func _on_Area2D_area_entered(area):
	$AnimatedSprite.play("show")
	emit_signal("hello_there")


func _on_Area2D_area_exited(area):
	$AnimatedSprite.play("default")
