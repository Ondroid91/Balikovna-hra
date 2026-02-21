extends Node2D

@export var damaged : bool = false
@export var danger : bool = true
@export var forbbiten : bool = true
@export var safe_to_destroy : bool = false

@export var item_name : String
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

func package_opend() -> void:
	if not bomb_activated:
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
				bomb_timer.stop()
				safe_to_destroy = true
			else:
				bomb_explode()

func bomb_explode() -> void:
	print("explode")
	gl.bomb_expoded.emit()

func _on_pack_package() -> void:
	if gl.in_hand == "tape" and pacakge.package_opend:
		pacakge._on_pack_package()
	
