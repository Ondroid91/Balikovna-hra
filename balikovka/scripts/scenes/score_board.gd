extends Control

@export var main_scene : Node
@export var ending_name : Label

@export var send_packages : Label
@export var correct_packages : Label
@export var correcty_removed : Label
@export var incorrecty_removed : Label


@export var back_to_main : Button
@export var conntinue : Button

func _ready() -> void:
	back_to_main.pressed.connect(func(): 
		get_tree().paused = false
		main_scene.set_scene("main_menu")
		print("back to main"))
	conntinue.pressed.connect(func():
		get_tree().paused = false
		main_scene.set_scene("game")
	)

func show_score() -> void:
	send_packages.text = str(gl.sended_packages)
	correct_packages.text = str(gl.correct_packages)
	correcty_removed.text = str(gl.correctly_removed_packages)
	incorrecty_removed.text = str(gl.incorrectly_removed_packages)

func set_ending_name(ending : String) -> void:
	ending_name.text = ending
