extends Area2D

@export var on_table : bool = false
#package parameters
@export var package_content : Node2D
@export var danger_value : int = 0
@export var package_opend : bool = false
@export var package_number : String
@export var package_radiation : int = 0
@export var package_weight : float = 0.0
@export var package_damage : int = 0

@export_group("components")
@export var machine_pos : Marker2D
@export var table_pos : Marker2D
@export var package_image : Sprite2D
@export var package_content_image: Sprite2D

var in_area : bool = false

func _ready() -> void:
	mouse_entered.connect(func(): in_area = true)
	mouse_exited.connect(func(): in_area = false)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click") and in_area:
		if gl.in_hand == "empty":
			print("pick")
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
				machine_pos.global_position,
				0.25
			).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			on_table = false

func _on_open_package():
	if on_table:
		pass

func _on_pack_package():
	if on_table:
		on_table = false
