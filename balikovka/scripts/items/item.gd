extends Node2D

@export var item_name : String
@export var object_rotation_on_pick : float
@export var object_h_flip_on_pick : bool = false
@export_group("components")
@export var pick : Button
@export var item_image : Sprite2D

var origin_pos : Vector2
var in_area : bool = false

func _ready() -> void:
	pick.pressed.connect(_on_picked)
	pick.mouse_entered.connect(func():
		item_image.modulate = Color(1.3, 1.3, 1.3, 1)
	)

	pick.mouse_exited.connect(func():
		item_image.modulate = Color(1, 1, 1, 1)
	)
	origin_pos = global_position


func _process(delta: float) -> void:
	if gl.in_hand != item_name: return
	
	self.global_position = get_global_mouse_position()
	if Input.is_action_just_pressed("right_click"):
		put_item_back()
	#if Input.is_action_just_pressed("left_click") and gl.in_hand != "empty" and ((global_position - origin_pos).length() < 100):
	#	put_item_back()

func put_item_back() -> void:
	rotation = 0
	item_image.flip_h = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	gl.in_hand = "empty"
	var tween := create_tween()
	tween.tween_property(
		self,
		"global_position",
		origin_pos,
		0.25
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tween.finished
	pick.disabled = false
	pick.mouse_filter = Control.MOUSE_FILTER_STOP

func _on_picked() -> void:
	rotation = object_rotation_on_pick
	item_image.flip_h = object_h_flip_on_pick
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	gl.in_hand = item_name
	pick.disabled = true
	pick.mouse_filter = Control.MOUSE_FILTER_IGNORE
