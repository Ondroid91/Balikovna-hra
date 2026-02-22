extends Control

@export var back : Button

@export var page1 : Panel
@export var page2 : Panel
@export var page3 : Panel

@export var page_button1 : Button
@export var page_button2 : Button
@export var page_button3 : Button

func _ready() -> void:
	back.pressed.connect(func(): self.visible = false)
	page_button1.pressed.connect(turn_page.bind(0))
	page_button2.pressed.connect(turn_page.bind(1))
	page_button3.pressed.connect(turn_page.bind(2))
func turn_page(to_page : int) -> void:
	match to_page:
		0:
			page1.visible = true
			page2.visible = false
			page3.visible = false
		1:
			page1.visible = false
			page2.visible = true
			page3.visible = false
		2:
			page1.visible = false
			page2.visible = false
			page3.visible = true
