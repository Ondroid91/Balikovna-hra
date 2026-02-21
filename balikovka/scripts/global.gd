extends Node


var in_hand : String = "empty"
var alive : bool = true


var level_time : float = 300.0
var wrong_number_damage = 10
var wrong_mark_damage = 10
var wrong_remove_damage = 10

var not_safe_to_destroy = 10
var danger_package = 10
var damaged_package = 10




var allowed_radiation_level = 20


var allowd_package_numbers : Array[String] = [
	"",
	"1321",
	"4526",
]

var correct_wire_orcer : Array[String] = [
	"red",
	"blue",
	"green",
]

#signals
signal bomb_expoded

# statistic
var sended_packages : int = 0
var correct_packages : int = 0
var danger_packages : int = 0
var incorrectly_removed_packages : int = 0
var correctly_removed_packages : int = 0
var final_damage : int = 0


func _ready() -> void:
	bomb_expoded.connect(func(): alive = false)
