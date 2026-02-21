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
@export var package_marked : bool = false
var should_be_marked : bool = false
var drag_package : bool = false

@export_group("components")
@export var machine : Node2D
@export var machine_pos : Marker2D
@export var table_pos : Marker2D
@export var package_image : AnimatedSprite2D
@export var package_button : Button
@export var package_area : Area2D


var in_table_area : bool = false

@export var items_list : Array[PackedScene]


func _ready() -> void:
	package_button.pressed.connect(_on_package_pressed)
	package_button.button_down.connect(_on_drag_package)
	package_button.button_up.connect(_on_drop_package)
	should_get_mark()
	spawn_item_in_package()

func _process(delta: float) -> void:
	if drag_package:
		global_position = get_global_mouse_position()
		#print(drag_package)


func _on_package_pressed() -> void:
	#if gl.in_hand == "empty":
		#if global_position.distance_to(machine.pakcage_pos.global_position) < 5.0 \
		#or global_position.distance_to(table_pos.global_position) < 5.0:
			#_on_pick_package()
		#	pass
	if gl.in_hand == "knife" and not package_opend:
		_on_open_package()
	if gl.in_hand == "tape" and package_opend:
		_on_pack_package()
	if gl.in_hand == "stamp" and not package_opend:
		_on_stamp_mark()

func _on_drag_package() -> void:
	if gl.in_hand == "empty":
		drag_package = true


var previos_pos : Marker2D
func _on_drop_package() -> void:
	drag_package = false
	print("drop ", machine.in_drop_area)
	
	if machine.in_drop_area:
		on_table = false
		previos_pos = machine.package_pos
		_on_move_package(machine.package_pos)
		_on_resize_package(1.0)
	elif machine.in_bin_area:
		package_button.disabled = true
		_on_move_package(machine.bin_pos)
		_on_resize_package(1.0)
		reparent(machine.bin_image)
		self.package_area.monitorable = false
		machine.package_on_table = null
		print("package to destroy ", self)
		machine.remove_package(self)
	elif machine.in_table_area:
		on_table = true
		previos_pos = table_pos
		_on_move_package(table_pos)
		_on_resize_package(2.0)
	else:
		_on_move_package(previos_pos)

func should_get_mark() -> void:
	for num in gl.packages_to_mark:
		if package_number == num:
			should_be_marked = true
			break

func spawn_item_in_package() -> void:
	if package_content:
		package_content.queue_free()
	var ran_item = randi_range(0, items_list.size() - 1)
	var new_item = items_list[ran_item].instantiate()
	new_item.visible = false
	new_item.pacakge = self
	new_item.global_position -= Vector2(0, 80)
	package_content = new_item
	add_child(new_item)

func _on_move_package(dest : Marker2D):
	var tween := create_tween()
	tween.tween_property(
		self,
		"global_position",
		dest.global_position,
		0.25
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	#.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	await tween.finished

func _on_resize_package(value: float) -> void:
	var tween := create_tween()
	tween.tween_property(
		self,
		"scale",
		Vector2(value, value),
		0.25
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	await tween.finished

func _on_open_package() -> void:
	if on_table:
		if package_content.item_name == "bomb":
			package_content.bomb_triggered()
		package_image.frame = 1
		package_content.visible = true
		package_opend = true
		package_button.disabled = true
		package_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		print("package opend")

func _on_pack_package() -> void:
	if on_table:
		package_image.frame = 0
		package_content.visible = false
		package_opend = false
		package_button.disabled = false
		package_button.mouse_filter = Control.MOUSE_FILTER_STOP
		print("package packed")

func _on_stamp_mark() -> void:
	if on_table:
		package_marked = true
		print("package marked")
