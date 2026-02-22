extends Control

@export var back : Button

@export var page1 : Panel
@export var page2 : Panel
@export var page3 : Panel

@export var page_button1 : Button
@export var page_button2 : Button
@export var page_button3 : Button

@export var close_book_snd : AudioStreamPlayer
@export var turn_page_snd : AudioStreamPlayer

func _ready() -> void:
	back.pressed.connect(func(): 
		self.visible = false
		close_book_snd.play()
	)
	page_button1.pressed.connect(turn_page.bind(0))
	page_button2.pressed.connect(turn_page.bind(1))
	page_button3.pressed.connect(turn_page.bind(2))

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("right_click"):
		if gl.in_hand == "empty":
			self.visible = false


func turn_page(to_page : int) -> void:
	turn_page_snd.play()
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
