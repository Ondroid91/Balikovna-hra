extends Control


@export var main_scene : Node
@export var score_board : Control

@export var conntinue : Button
@export var back_to_main : Button
@export var quit : Button

@export var conntinue_image : Sprite2D
@export var back_to_main_image : Sprite2D
@export var quit_image : Sprite2D


func _ready() -> void:
	conntinue.pressed.connect(func():
		self.visible = false
		get_tree().paused = false
		)
	back_to_main.pressed.connect(func():
		self.visible = false
		get_tree().paused = false
		main_scene.set_scene("main_menu")
	)
	quit.pressed.connect(func():
		self.visible = false
		get_tree().quit()
	)
	
	conntinue.mouse_entered.connect(func():
		conntinue.modulate = Color(1.3, 1.3, 1.3, 1)
	)
	quit.mouse_exited.connect(func():
		conntinue.modulate = Color(1, 1, 1, 1)
	)
	back_to_main.mouse_entered.connect(func():
		back_to_main.modulate = Color(1.3, 1.3, 1.3, 1)
	)
	back_to_main.mouse_exited.connect(func():
		back_to_main.modulate = Color(1, 1, 1, 1)
	)
	quit.mouse_entered.connect(func():
		quit.modulate = Color(1.3, 1.3, 1.3, 1)
	)
	quit.mouse_exited.connect(func():
		quit.modulate = Color(1, 1, 1, 1)
	)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = not get_tree().paused
		self.visible = get_tree().paused
