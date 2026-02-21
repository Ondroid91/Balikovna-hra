extends Control


@export var back : Button


func _ready() -> void:
	back.pressed.connect(func(): self.visible = false)
	
