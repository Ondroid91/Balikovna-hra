extends Node2D

@export var main_scene : Node
@export var manual_button : Button
@export var manual_image : Sprite2D
@export var timer : Timer

func _ready() -> void:
	manual_button.pressed.connect(func(): 
		if gl.in_hand == "empty":
			main_scene.manual_book.visible = true)
	manual_button.mouse_entered.connect(func():
		manual_image.modulate = Color(1.3, 1.3, 1.3, 1)
	)
	manual_button.mouse_exited.connect(func():
		manual_image.modulate = Color(1, 1, 1, 1)
	)
	timer.wait_time = gl.level_time
	timer.start()
	timer.timeout.connect(_on_time_out)

func _on_time_out() -> void:
	gl.shift_end.emit()
	print("level finished")
