extends Node2D

@export var main_scene : Node
@export var manual_button : Button
@export var manual_image : Sprite2D
@export var timer : Timer
@export var count_down : Label


@export var open_book_snd : AudioStreamPlayer
@export var background_snd : AudioStreamPlayer


func _ready() -> void:
	manual_button.pressed.connect(func(): 
		if gl.in_hand == "empty":
			main_scene.manual_book.visible = true
			open_book_snd.play()
			)
	manual_button.mouse_entered.connect(func():
		manual_image.modulate = Color(1.3, 1.3, 1.3, 1)
	)
	manual_button.mouse_exited.connect(func():
		manual_image.modulate = Color(1, 1, 1, 1)
	)
	timer.wait_time = gl.level_time
	timer.start()
	timer.timeout.connect(_on_time_out)

func _process(delta: float) -> void:
	count_down.text = format_time_ss_ms(timer.time_left)

func format_time_ss_ms(time: float) -> String:
	var total_seconds := maxf(time, 0.0)

	var minutes := int(total_seconds) / 60
	var seconds := int(total_seconds) % 60
	var centiseconds := int((total_seconds - int(total_seconds)) * 100.0)

	return "%02d:%02d:%02d" % [minutes, seconds, centiseconds]

func _on_time_out() -> void:
	background_snd.stop()
	gl.shift_end.emit()
	print("level finished")
