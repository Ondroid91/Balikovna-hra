extends Node

@export_enum("game", "main_menu") var start_scene : String = "game"

@export_group("components")
@export var currrent_scene : Node
@export var manual_book : Control
@export var viewport : Viewport
@export var parameters : Label
@export var score_background : Sprite2D
@export var score_board : Control

@export var main_menu_scene : PackedScene
@export var game_scene : PackedScene

func _ready() -> void:
	set_scene(start_scene)
	gl.bomb_expoded.connect(you_died_screen)
	gl.you_are_fired.connect(you_are_fired_screen)
	gl.shift_end.connect(shift_ends_screen)

	#make_score_background_light(5.0)

func _process(delta: float) -> void:
	parameters.text = (
		"damage : " + str(gl.final_damage) + "\n" +
		"sended packages : " + str(gl.sended_packages) + "\n" +
		"correct packages : " + str(gl.correct_packages) + "\n" +
		"danger packages : " + str(gl.danger_packages) + "\n" +
		"correct removed : " + str(gl.correctly_removed_packages) + "\n" +
		"incorrect removed : " + str(gl.incorrectly_removed_packages)
	)

func diable_screen() -> void:
	make_score_background_light(3.0)
	score_board.visible = false

func you_died_screen() -> void:
	get_tree().paused = true
	make_score_background_dark(0.1)
	score_board.visible = true
	score_board.set_ending_name("You died")
	score_board.show_score()

func you_are_fired_screen() -> void:
	get_tree().paused = true
	make_score_background_dark(2.0)
	score_board.visible = true
	score_board.set_ending_name("You have been fired")
	score_board.show_score()
	
func shift_ends_screen() -> void:
	get_tree().paused = true
	make_score_background_dark(2.0)
	score_board.visible = true
	score_board.set_ending_name("Your shift ends")
	score_board.show_score()

func make_score_background_light(speed : float) -> void:
	score_background.modulate.a = 1.0
	var tween := create_tween()
	tween.tween_property(
		score_background,
		"modulate:a",
		0.0,
		speed
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func make_score_background_dark(speed : float) -> void:
	score_background.modulate.a = 0.0
	var tween := create_tween()
	tween.tween_property(
		score_background,
		"modulate:a",
		1.0,
		speed
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func set_scene(scene : String) -> void:
	match scene:
		"game":
			gl.reset_variables()
			diable_screen()
			load_new_scene(game_scene)
		"main_menu":
			diable_screen()
			load_new_scene(main_menu_scene)

func load_new_scene(scene_to_load : PackedScene) -> void:
	if currrent_scene:
		currrent_scene.queue_free()
	var new_scene = scene_to_load.instantiate()
	new_scene.main_scene = self
	viewport.add_child(new_scene)
	currrent_scene = new_scene
