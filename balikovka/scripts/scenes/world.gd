extends Node2D

@export var main_scene : Node
@export var manual_button : Button
@export var timer : Timer

func _ready() -> void:
	manual_button.pressed.connect(func(): main_scene.manual_book.visible = true)
	timer.wait_time = gl.level_time
	timer.start()
	timer.timeout.connect(_on_time_out)


func _on_time_out() -> void:
	print("level finished")
