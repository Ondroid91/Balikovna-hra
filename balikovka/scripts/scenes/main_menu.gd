extends Node2D

@export var main_scene : Node

@export var play : Button
@export var quit : Button


func _ready() -> void:
	quit.pressed.connect(func(): 
		get_tree().paused = false
		get_tree().quit()
		print("back to main"))
	play.pressed.connect(func():
		get_tree().paused = false
		main_scene.set_scene("game")
	)
