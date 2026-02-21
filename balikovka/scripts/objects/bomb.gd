extends Node2D

@export var damaged : bool = false
@export var danger : bool = true
@export var forbbiten : bool = true
@export var safe_to_destroy : bool = false

@export var item_name : String = "bomb"
@export var content_image : Texture2D
@export var damaged_content_image : Texture2D

@export_group("components")
@export var pacakge : Node2D
@export var pack : Button

@export var wire1 : AnimatedSprite2D
@export var wire2 : AnimatedSprite2D
@export var wire3 : AnimatedSprite2D

@export var red_wire_button : Button
@export var blue_wire_button : Button
@export var green_wire_button : Button
@export var bomb_timer : Timer
@export var display_timer : Label

var cut_wires : Array[bool] = [
	false,
	false,
	false,
]

var bomb_activated : bool = false

func _ready() -> void:
	pack.pressed.connect(_on_pack_package)
	
	red_wire_button.pressed.connect(func(): cut_wire(red_wire_button))
	blue_wire_button.pressed.connect(func(): cut_wire(blue_wire_button))
	green_wire_button.pressed.connect(func(): cut_wire(green_wire_button))
	bomb_timer.timeout.connect(bomb_explode)
	pacakge = self.get_parent()

func _process(delta: float) -> void:
	if bomb_activated:
		display_timer.text = format_time_ss_ms(bomb_timer.time_left)

func bomb_triggered() -> void:
	if not bomb_activated:
		print("bomb_start cout down")
		bomb_timer.start()
	bomb_activated = true

func cut_wire(cutted_wire : Button) -> void:
	if gl.in_hand != "knife": return
	match cutted_wire:
		red_wire_button:
			red_wire_button.disabled = true
			var order = gl.correct_wire_orcer.find("red")
			cut_wires[order] = true
			wire1.frame = 1
			check_order(order)
		blue_wire_button:
			blue_wire_button.disabled = true
			var order = gl.correct_wire_orcer.find("blue")
			cut_wires[order] = true
			wire2.frame = 1
			check_order(order)
		green_wire_button:
			green_wire_button.disabled = true
			var order = gl.correct_wire_orcer.find("green")
			cut_wires[order] = true
			wire3.frame = 1
			check_order(order)

func check_order(order : int) -> void:
	match order:
		0:
			if cut_wires[1] == false and cut_wires[2] == false:
				print("correct")
			else:
				bomb_explode()
		1:
			if cut_wires[0] == true and cut_wires[2] == false:
				print("correct")
			else:
				bomb_explode()
		2:
			if cut_wires[0] == true and cut_wires[1] == true:
				print("bomb diabled")
				disable_bomb()
			else:
				bomb_explode()

var stopped_time := 0.0
func disable_bomb() -> void:
	print("bomb disabled")
	stopped_time = bomb_timer.time_left
	bomb_timer.stop()
	display_timer.text = format_time_ss_ms(stopped_time)
	bomb_activated = false
	safe_to_destroy = true

func format_time_ss_ms(time: float) -> String:
	var seconds := int(time)
	var centiseconds := int((time - seconds) * 100.0)
	return "%02d:%02d" % [seconds, centiseconds]

func bomb_explode() -> void:
	gl.bomb_expoded.emit()

func _on_pack_package() -> void:
	if gl.in_hand == "tape" and pacakge.package_opend:
		pacakge._on_pack_package()
