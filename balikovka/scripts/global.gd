extends Node

var in_hand : String = "empty"
var alive : bool = true

var level_time : float = 300.0

#penalization
var wrong_number_damage : int = 10
var wrong_mark_damage : int = 10
var wrong_remove_damage : int = 10
var not_safe_to_destroy : int = 10
var danger_package : int = 10
var damaged_package : int = 10
var forbbiten_item_damage : int = 10


var max_damage : int = 200
var allowed_radiation_level = 20
var allowd_package_numbers : Array[String] = [
	"",
	"1321",
	"4526",
]
var packages_to_mark : Array[String] = [
	"4526",
]



var correct_wire_orcer : Array[String] = [
	"red",
	"blue",
	"green",
]

# chances
var chance_to_damaged : int = 5

#signals
signal bomb_expoded
signal you_are_fired
signal shift_end

# statistic
var sended_packages : int = 0
var correct_packages : int = 0
var danger_packages : int = 0
var incorrectly_removed_packages : int = 0
var correctly_removed_packages : int = 0
var final_damage : int = 0

func _ready() -> void:
	bomb_expoded.connect(func(): alive = false)

func reset_variables() -> void:
	in_hand = "empty"
	alive = true
	sended_packages = 0
	correct_packages = 0
	danger_packages = 0
	incorrectly_removed_packages = 0
	correctly_removed_packages = 0
	final_damage = 0
