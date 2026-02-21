extends Node2D

@export var damaged : bool = false
@export var content_image : Texture2D
@export var damaged_content_image : Texture2D

@export_group("components")
@export var pacakge : Node2D
@export var sprite : Sprite2D
@export var pack : Button

func _ready() -> void:
	if damaged and damaged_content_image:
		sprite.texture = damaged_content_image
	elif not damaged and content_image:
		sprite.texture = content_image

	pack.pressed.connect(_on_pack_package)


func _on_pack_package() -> void:
	if gl.in_hand == "tape" and pacakge.package_opend:
		pacakge._on_pack_package()
