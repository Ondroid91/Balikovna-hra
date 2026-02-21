extends Node2D

@export var damaged : bool = false
@export var danger : bool = false
@export var forbbiten : bool = false
@export var safe_to_destroy : bool = false

@export var item_name : String
@export var content_image : Texture2D
@export var damaged_content_image : Texture2D

@export_group("components")
@export var pacakge : Node2D
@export var sprite : Sprite2D
@export var pack : Button

func _ready() -> void:
	damaged = damged_chance()
	if damaged:
		sprite.texture = damaged_content_image
	else:
		sprite.texture = content_image
	pack.pressed.connect(_on_pack_package)
	
func damged_chance() -> bool:
	var chance_to_damage = randi_range(0, gl.chance_to_damaged)
	if chance_to_damage == 0:
		print("item is damaged")
		return true
	else: return false


func _on_pack_package() -> void:
	if gl.in_hand == "tape" and pacakge.package_opend:
		pacakge._on_pack_package()
