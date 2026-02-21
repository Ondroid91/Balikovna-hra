extends Node

@export_enum("game", "main_menu") var start_scene : String = "game"

@export_group("components")
@export var currrent_scene : Node
@export var manual_book : Control
@export var viewport : Viewport

@export var main_menu_scene : PackedScene
@export var game_scene : PackedScene

func _ready() -> void:
	set_start_scene()


func set_start_scene() -> void:
	match start_scene:
		"game":
			load_new_scene(game_scene)
		"main_menu":
			load_new_scene(main_menu_scene)

func load_new_scene(scene_to_load : PackedScene) -> void:
	if currrent_scene:
		currrent_scene.queue_free()
	var new_scene = scene_to_load.instantiate()
	new_scene.main_scene = self
	viewport.add_child(new_scene)
	currrent_scene = new_scene
