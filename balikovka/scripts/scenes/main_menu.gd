extends Node2D

@export var main_scene : Node

@export var play : Button
@export var quit : Button

@export var play_image : Sprite2D
@export var quit_image : Sprite2D


func _ready() -> void:
	quit.pressed.connect(func(): 
		get_tree().paused = false
		get_tree().quit()
		print("back to main"))
	play.pressed.connect(func():
		get_tree().paused = false
		gl.reset_variables()
		main_scene.set_scene("game")
	)
	play.mouse_entered.connect(func():
		play_image.modulate = Color(1.3, 1.3, 1.3, 1)
	)

	play.mouse_exited.connect(func():
		play_image.modulate = Color(1, 1, 1, 1)
	)
	quit.mouse_entered.connect(func():
		quit_image.modulate = Color(1.3, 1.3, 1.3, 1)
	)
	quit.mouse_exited.connect(func():
		quit_image.modulate = Color(1, 1, 1, 1)
	)
