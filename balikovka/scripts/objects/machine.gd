extends Node2D

@export_group("components")
@export var package_on_table : Node2D
@export var spawn_pos : Marker2D
@export var pakcage_pos : Marker2D
@export var exit_pos : Marker2D
@export var next_button : Button
@export var destroy_area : Area2D
@export var table_pos : Marker2D
@export var scener_area : Area2D
@export var scener_photo : Sprite2D

@export var packages_to_spawn : Array[PackedScene]

var next_allowed := true
var middle_occupied := true

func _ready() -> void:
	next_button.pressed.connect(_on_next_button)
	destroy_area.area_entered.connect(_on_destroy_area_entered)
	scener_area.area_entered.connect(_on_scener_area_entered)

func _on_destroy_area_entered(area: Area2D) -> void:
	if is_instance_valid(area):
		area.get_parent().queue_free()
		gl.sended_packages += 1
		var package_damage = check_package()
		if package_damage > 0:
			gl.danger_packages += 1
			gl.final_damage += package_damage
		else:
			gl.correct_packages += 1
			
func check_package() -> int:
	return 0

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
	await move_package(new_package, pakcage_pos)
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
