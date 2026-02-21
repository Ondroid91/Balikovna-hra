extends Node2D

@export_group("components")
@export var package_on_table : Node2D
@export var spawn_pos : Marker2D
@export var package_pos : Marker2D
@export var exit_pos : Marker2D
@export var next_button : Button
@export var send_area : Area2D
@export var destroy_area : Area2D
@export var drop_package : Area2D
@export var table_drop_area :Area2D
@export var to_bin_area : Area2D
@export var table_pos : Marker2D
@export var scener_area : Area2D
@export var scener_photo : Sprite2D

@export var packages_to_spawn : Array[PackedScene]

var next_allowed := true
var middle_occupied := true


var in_table_area : bool = false
var in_drop_area : bool = false
var in_bin_area : bool = false

func _ready() -> void:
	next_button.pressed.connect(_on_next_button)
	send_area.area_entered.connect(_on_destroy_area_entered)
	scener_area.area_entered.connect(_on_scener_area_entered)
	drop_package.area_entered.connect(_on_drop_area_entered)
	drop_package.area_exited.connect(_on_drop_area_exited)
	table_drop_area.area_entered.connect(_on_table_drop_area_entered)
	table_drop_area.area_exited.connect(_on_table_drop_area_exited)


func _on_destroy_area_entered(area: Area2D) -> void:
	if is_instance_valid(area):
		var package = area.get_parent()
		gl.sended_packages += 1
		var package_damage = check_package(package)
		if package_damage > 0:
			gl.danger_packages += 1
			gl.final_damage += package_damage
		else:
			gl.correct_packages += 1
		package.queue_free()

func check_package(package : Node2D) -> int:
	var danger_value : int = 0
	var num_ok : bool = false
	for num in gl.allowd_package_numbers:
		if package.package_number == num:
			num_ok = true
			break
	if not num_ok: danger_value += gl.wrong_number_damage
	if package.package_radiation > gl.allowed_radiation_level:
		danger_value += (package.package_radiation - gl.wrong_number_damage)
	if package.should_be_marked != package.package_marked:
		danger_value += gl.wrong_mark_damage
	return danger_value

func _on_next_button() -> void:
	if not next_allowed: return
	if not middle_occupied: return
	if package_on_table:
		if package_on_table.on_table: return
	
	next_allowed = false
	next_button.disabled = true

	if is_instance_valid(package_on_table):
		await move_package(package_on_table, exit_pos)
		middle_occupied = false

	await spawn_object()

	next_button.disabled = false
	next_allowed = true


func spawn_object() -> void:
	if packages_to_spawn.is_empty():
		return
	var ran_package := randi_range(0, packages_to_spawn.size() - 1)
	var new_package := packages_to_spawn[ran_package].instantiate() as Node2D
	add_child(new_package)
	new_package.global_position = spawn_pos.global_position
	new_package.table_pos = table_pos
	new_package.machine = self
	package_on_table = new_package
	await move_package(new_package, package_pos)
	middle_occupied = true

func move_package(pack : Node2D, destination : Marker2D) -> void:
	if not is_instance_valid(pack):
		return

	var tween := create_tween()
	tween.tween_property(
		pack,
		"global_position",
		destination.global_position,
		1.0
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	await tween.finished

func _on_scener_area_entered(area) -> void:
	if is_instance_valid(area):
		print(area.get_parent().name)


# areas
func _on_drop_area_entered(area) -> void:
	var package = area.get_parent()
	in_drop_area = true

func _on_drop_area_exited(area) -> void:
	var package = area.get_parent()
	in_drop_area = false
	package.on_table = false

func _on_table_drop_area_entered(area) -> void:
	var package = area.get_parent()
	in_table_area = true

func _on_table_drop_area_exited(area) -> void:
	var package = area.get_parent()
	in_table_area = false
	package.on_table = false
