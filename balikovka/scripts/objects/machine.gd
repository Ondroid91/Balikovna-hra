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
@export var bin_pos : Marker2D
@export var scener_area : Area2D
@export var scener_photo : Sprite2D
@export var bin_image : Sprite2D
@export var scan_image : Sprite2D

@export var packages_to_spawn : Array[PackedScene]

var next_allowed := true
var middle_occupied := true

var in_table_area : bool = false
var in_drop_area : bool = false
var in_bin_area : bool = false

var origin_bin_pos : Vector2

func _ready() -> void:
	next_button.pressed.connect(_on_next_button)
	send_area.area_entered.connect(_on_destroy_area_entered)
	scener_area.area_entered.connect(_on_scener_area_entered)
	drop_package.area_entered.connect(_on_drop_area_entered)
	drop_package.area_exited.connect(_on_drop_area_exited)
	table_drop_area.area_entered.connect(_on_table_drop_area_entered)
	table_drop_area.area_exited.connect(_on_table_drop_area_exited)
	to_bin_area.area_entered.connect(_on_bin_drop_area_entered)
	to_bin_area.area_exited.connect(_on_bin_drop_area_exited)

	origin_bin_pos = bin_image.global_position


func _on_destroy_area_entered(area: Area2D) -> void:
	if is_instance_valid(area):
		var package = area.get_parent()
		gl.sended_packages += 1
		var package_damage = check_package(package, true)
		if package_damage > 0:
			gl.danger_packages += 1
			gl.final_damage += package_damage
		else:
			gl.correct_packages += 1
		package.queue_free()

func check_package(package : Node2D, send : bool) -> int:
	var danger_value : int = 0
	var num_ok : bool = false
	for num in gl.allowd_package_numbers:
		if package.package_number == num:
			num_ok = true
			break
	if send and not num_ok: danger_value += gl.wrong_number_damage
	if package.package_radiation > gl.allowed_radiation_level:
		danger_value += (package.package_radiation - gl.wrong_number_damage)
	if send and package.should_be_marked != package.package_marked:
		print("wrong mark")
		danger_value += gl.wrong_mark_damage
	
	var content = package.package_content
	if send and content.damaged: danger_value += gl.damaged_package
	if send and content.danger: danger_value += gl.danger_package
	if send and content.forbbiten: danger_value += gl.forbbiten_item_damage
	
	if (
	send == false
	and not content.damaged
	and not content.forbbiten
	and not content.danger
	):  
		danger_value += gl.damaged_package
	#if send == false and not content.danger: danger_value += gl.danger_package
	if send == false and content.danger == true and not content.safe_to_destroy:
		danger_value += gl.danger_package
		print("danger content")
	print("dmg : ", danger_value)
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
	print(ran_package)
	var new_package := packages_to_spawn[ran_package].instantiate() as Node2D
	add_child(new_package)
	new_package.global_position = spawn_pos.global_position
	new_package.table_pos = table_pos
	new_package.machine = self
	new_package.previos_pos = package_pos
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
		var package = area.get_parent()
		var content_image = package.package_content.content_image
		if package.package_content.damaged:
			content_image = package.package_content.damaged_content_image
		
		if content_image:
			scan_image.texture = content_image
		


# areas
func _on_drop_area_entered(area) -> void:
	#var package = area.get_parent()
	in_drop_area = true

func _on_drop_area_exited(area) -> void:
	var package = area.get_parent()
	in_drop_area = false
	package.on_table = false

func _on_table_drop_area_entered(area) -> void:
	#var package = area.get_parent()
	in_table_area = true

func _on_table_drop_area_exited(area) -> void:
	var package = area.get_parent()
	in_table_area = false
	package.on_table = false

func remove_package(package : Node2D) -> void:
	await get_tree().create_timer(1.0).timeout
	var tween := create_tween()
	tween.tween_property(
		bin_image,
		"global_position",
		origin_bin_pos + Vector2(400, 0),
		0.75
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tween.finished
	print("package to destroy ", package)
	var package_damage = check_package(package, false)
	if package_damage > 0:
		gl.incorrectly_removed_packages += 1
		gl.final_damage += gl.wrong_remove_damage
	else:
		gl.correctly_removed_packages += 1

	package.queue_free()

	var tween2 := create_tween()
	tween2.tween_property(
		bin_image,
		"global_position",
		origin_bin_pos,
		0.75
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_bin_drop_area_entered(area) -> void:
	in_bin_area = true

func _on_bin_drop_area_exited(area) -> void:
	in_bin_area = false
