@tool
class_name EFXPlayOnSignal
extends Node

#@export_tool_button("Update") var update = _update
@export var play: bool = true
@export var instigator: Node
# hint: PropertyHint, hint_string: String, usage: BitField[PropertyUsageFlags
#var player: Node :
@export_node_path(
	"AnimationPlayer",
	"AudioStreamPlayer2D",
	"AudioStreamPlayer3D",
	"AudioStreamPlayer"
) var player: NodePath
var _player: Node :
	set(value):
		if not (value is AudioStreamPlayer
				or value is AudioStreamPlayer2D
				or value is AudioStreamPlayer3D
				or value is AnimationPlayer):
			push_warning("player value can be only animation or audio player")
			return
		_player = value
var signal_name: StringName
var animation_name: StringName

func _ready() -> void:
	if Engine.is_editor_hint():
		instigator.script_changed.connect(_update)
		return
	if not instigator:
		push_warning("EFXPlayOnSighal has no instigator ", get_path())
		return
	if not _player:
		push_warning("EFXPlayOnSighal has no player ", get_path())
		return
	if _player is AnimationPlayer and not _player.has_animation(animation_name):
		push_warning("EFXPlayOnSighal player has not animation named ", animation_name, " ", get_path())
		return
	instigator.connect(signal_name, _play)


func _enter_tree() -> void:
	_update()

func _update() -> void:
	if player:
		_player = get_node_or_null(player)
	if (not _player or not player)\
			and ((self as Node) is AudioStreamPlayer
			or (self as Node) is AudioStreamPlayer2D
			or (self as Node) is AudioStreamPlayer3D
			or (self as Node) is AnimationPlayer):
		player = "./"
		_player = self
	if (not _player or not player)\
			and ((get_parent() as Node) is AudioStreamPlayer
			or (get_parent() as Node) is AudioStreamPlayer2D
			or (get_parent() as Node) is AudioStreamPlayer3D
			or (get_parent() as Node) is AnimationPlayer):
		player = "../"
		_player = get_parent()
	if not instigator:
		instigator = get_parent()
	notify_property_list_changed()

func _get_property_list() -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	if instigator:
		out.append({
			"name": "signal_name",
			"type": Variant.Type.TYPE_STRING_NAME,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": instigator.get_signal_list().reduce(func(a: Variant, b: Dictionary) -> String:
				if a is Dictionary:
					return a.name + "," + b.name
				return a + "," + b.name),
			"usage": PROPERTY_USAGE_DEFAULT
		})
	if _player is AnimationPlayer:
		out.append({
			"name": "animation_name",
			"type": Variant.Type.TYPE_STRING_NAME,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": Array(_player.get_animation_list()).reduce(func(a: String, b: Variant) -> String:
				if b is String:
					return a + "," + b
				return a),
			"usage": PROPERTY_USAGE_DEFAULT
		})
	return out

func _play(
	_a1: Variant = null,
	_a2: Variant = null,
	_a3: Variant = null,
	_a4: Variant = null,
	_a5: Variant = null,
) -> void:
	if play:
		if _player is AnimationPlayer:
			_player.play(animation_name)
		elif _player is AudioStreamPlayer:
			_player.play()
		elif _player is AudioStreamPlayer2D:
			_player.play()
		elif _player is AudioStreamPlayer3D:
			_player.play()
	else:
		if _player is AnimationPlayer:
			_player.stop()
		elif _player is AudioStreamPlayer:
			_player.stop()
		elif _player is AudioStreamPlayer2D:
			_player.stop()
		elif _player is AudioStreamPlayer3D:
			_player.stop()
