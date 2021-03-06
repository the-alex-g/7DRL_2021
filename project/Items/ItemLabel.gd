class_name ItemLabel
extends Label

# signals

# enums

# constants
const STYLEBOX := "res://Items/ItemLabel.tres"

# exported variables

# variables
var _ignore

# onready variables


func _ready()->void:
	set("custom_styles/normal", load(STYLEBOX))


func generate_text(item:Dictionary):
	text = _parse_traits_from_item(item)


func _parse_traits_from_item(item:Dictionary)->String:
	var string := ""
	string += item["name"]
	for property in item["properties"]:
		string += "\n"+property+" "+str(item["properties"][property])
	return string
