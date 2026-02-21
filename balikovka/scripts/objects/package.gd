extends Node2D

@export var on_table : bool = false
@export var package_opend : bool = false
@export var package_content : Node2D

@export_group("package parameters")
@export var danger_value : int = 0
@export var package_number : String
@export var package_radiation : int = 0
@export var package_weight : float = 0.0
@export var package_damage : int = 0
@export var package_marked : bool = true
var should_be_marked : bool = false
var drag_package : bool = false

@export_group("components")
@export var machine : Node2D
@export var machine_pos : Marker2D
@export var table_pos : Marker2D
@export var package_image : Sprite2D
@export var package_button : Button
@export var package_area : Area2D

var in_area : bool = false

func _ready() -> void:
	package_button.pressed.connect(_on_package_pressed)
	package_button.button_down.connect(_on_drag_package)
	package_button.button_up.connect(_on_drop_package)

func _process(delta: float) -> void:
	if drag_package:
		global_position = get_global_mouse_position()


func _on_package_pressed() -> void:
	if gl.in_hand == "empty":
		if global_position.distance_to(machine.pakcage_pos.global_position) < 5.0 \
		or global_position.distance_to(table_pos.global_position) < 5.0:
			_on_pick_package()
	if gl.in_hand == "knife" and not package_opend:
		_on_open_package()
	if gl.in_hand == "tape" and package_opend:
		_on_pack_package()
	if gl.in_hand == "stamp" and not package_opend:
		_on_stamp_mark()

func _on_drag_package() -> void:
	if on_table:
		drag_package = true

func _on_drop_package() -> void:
	on_table = false
	drag_package = false
	_on_pick_package()

func set_package():
	#package_image.texture
	#package_content_image.texture = package_content.image
	pass

func _on_pick_package():
	match on_table:
		false:
			var tween := create_tween()
			tween.tween_property(
				self,
				"global_position",
				table_pos.global_position,
				0.25
			).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			on_table = true
		true:
			var tween := create_tween()
			tween.tween_property(
				self,
				"global_position",
				machine.pakcage_pos.global_position,
				0.25
			).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			on_table = false

func _on_open_package() -> void:
	if on_table:
		package_opend = true
		package_image.visible = false
		package_button.disabled = true

		package_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		print("package opend")

func _on_pack_package() -> void:
	if on_table:
		package_opend = false
		package_image.visible = true
		package_button.disabled = false
		package_button.mouse_filter = Control.MOUSE_FILTER_STOP
		print("package packed")

func _on_stamp_mark() -> void:
	if on_table:
		package_marked = true
		print("package marked")
