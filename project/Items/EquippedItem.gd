extends TextureRect

# signals

# enums

# constants

# exported variables

# variables
var _ignore
var item := {}

# onready variables
onready var _item_image := $AnimatedSprite


func change_item(new_item:Dictionary)->void:
	item = new_item
	var new_anim:String = item["anim_name"]
	_item_image.play(new_anim)

