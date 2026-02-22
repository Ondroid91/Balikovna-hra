extends Control

@export var back : Button

@export var page1 : Panel
@export var page2 : Panel
@export var page3 : Panel
@export var page4 : Panel
@export var page5 : Panel

@export var page_button1 : Button
@export var page_button2 : Button
@export var page_button3 : Button
@export var page_button4 : Button
@export var page_button5 : Button

@export var close_book_snd : AudioStreamPlayer
@export var turn_page_snd : AudioStreamPlayer

var manual_book_origin_pos : Vector2

func _ready() -> void:
	back.pressed.connect(func(): 
		move_manual_book_down()
		close_book_snd.play()
	)
	page_button1.pressed.connect(turn_page.bind(0))
	page_button2.pressed.connect(turn_page.bind(1))
	page_button3.pressed.connect(turn_page.bind(2))
	page_button4.pressed.connect(turn_page.bind(3))
	page_button5.pressed.connect(turn_page.bind(4))
	manual_book_origin_pos = global_position

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("right_click"):
		if gl.in_hand == "empty":
			move_manual_book_down()
			close_book_snd.play()

func move_manual_book_down() -> void:
	var tween := create_tween()
	tween.tween_property(
		self,
		"global_position",
		manual_book_origin_pos,
		0.5
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tween.finished
	#visible = false

func turn_page(to_page : int) -> void:
	turn_page_snd.play()
	match to_page:
		0:
			page1.visible = true
			page2.visible = false
			page3.visible = false
			page4.visible = false
			page5.visible = false
		1:
			page1.visible = false
			page2.visible = true
			page3.visible = false
			page4.visible = false
			page5.visible = false
		2:
			page1.visible = false
			page2.visible = false
			page3.visible = true
			page4.visible = false
			page5.visible = false
		3:
			page1.visible = false
			page2.visible = false
			page3.visible = false
			page4.visible = true
			page5.visible = false
		4:
			page1.visible = false
			page2.visible = false
			page3.visible = false
			page4.visible = false
			page5.visible = true
