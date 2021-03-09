class_name ItemLabel
extends Label

# signals

# enums

# constants
const STYLEBOX := "res://Items/ItemLabel.tres"
const FONT := "res://Font.tres"
const COLOR := Color("37ffff")

# exported variables

# variables
var _ignore

# onready variables


func _ready()->void:
	set("custom_styles/normal", load(STYLEBOX))
	set("custom_fonts/font", load(FONT))
	set("custom_colors/font_color", COLOR)
	margin_left = 34
	margin_top = -16
	margin_right = 180


func generate_text(item:Dictionary):
	text = _parse_traits_from_item(item)


func _parse_traits_from_item(item:Dictionary)->String:
	var string := ""
	string += item["name"]
	string += _get_edited_string(item["properties"])
	return string


func _get_edited_string(properties:Dictionary)->String:
	var properties_as_string := ""
	for property in properties:
		var property_name:String = property
		var value:float = properties[property]
		if property_name == "_speed":
			value /= 10
		properties_as_string += "\n"
		property_name = _remove_underscores(property_name)
		property_name = property_name.capitalize()
		if value > 0:
			properties_as_string += "+"+str(value)+" "
		else:
			properties_as_string += str(value)+" "
		properties_as_string += property_name
	return properties_as_string


func _remove_underscores(string:String)->String:
	var _string_without_underscores := ""
	for character in string:
		if character == "_":
			_string_without_underscores += " "
		else:
			_string_without_underscores += character
	return _string_without_underscores
