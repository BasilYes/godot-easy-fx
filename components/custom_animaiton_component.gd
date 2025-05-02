@tool
class_name EFXCustomAnimationComponent
extends EFXAnimationComponent

@export var signal_source: Node = null :
	set(value):
		signal_source = value
		notify_property_list_changed()
var forward_signal_name: String = ""
var backward_signal_name: String = ""


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	if signal_source.has_signal(forward_signal_name):
		signal_source.connect(forward_signal_name, play.bind(1.0, false, true))
	if signal_source.has_signal(backward_signal_name):
		signal_source.connect(backward_signal_name, play.bind(1.0, true, true))


func _get_property_list() -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	if signal_source:
		out.append({
			"name": "forward_signal_name",
			"type": Variant.Type.TYPE_STRING_NAME,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": signal_source.get_signal_list().reduce(func(a: Variant, b: Dictionary) -> String:
				if a is Dictionary:
					return a.name + "," + b.name
				return a + "," + b.name),
			"usage": PROPERTY_USAGE_DEFAULT
		})
		out.append({
			"name": "backward_signal_name",
			"type": Variant.Type.TYPE_STRING_NAME,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": signal_source.get_signal_list().reduce(func(a: Variant, b: Dictionary) -> String:
				if a is Dictionary:
					return a.name + "," + b.name
				return a + "," + b.name),
			"usage": PROPERTY_USAGE_DEFAULT
		})
	return out
