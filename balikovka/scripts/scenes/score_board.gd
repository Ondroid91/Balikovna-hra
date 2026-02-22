extends Control

@export var main_scene : Node
@export var ending_name : Label

@export var send_packages : Label
@export var correct_packages : Label
@export var correcty_removed : Label
@export var incorrecty_removed : Label
@export var earns : Label

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
	if ending == "Your shift ends":
		earns.text = str(sum_score())
	elif ending == "You have been fired":
		earns.text = "0"
	elif ending == "You died":
		earns.text = "0"

func sum_score() -> float:
	var sum : float = 0
	sum += gl.sended_packages * 0.1
	sum += gl.correct_packages * 0.1
	sum += gl.correctly_removed_packages * 0.1
	sum -= gl.final_damage * 0.05
	return sum
