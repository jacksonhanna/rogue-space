extends Node

var _dialogue_layer: CanvasLayer
var _dialogue_panel: PanelContainer
var _speaker_label: Label
var _dialogue_label: Label
var _continue_label: Label
var _lines: Array[String] = []
var _line_index: int = 0
var _active: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_create_dialogue_ui()

func _unhandled_input(event: InputEvent) -> void:
	if _active and event.is_action_pressed("shoot"):
		_advance_dialogue()
		get_viewport().set_input_as_handled()

func is_active() -> bool:
	return _active

func start_dialogue(lines: Array[String], speaker: String) -> bool:
	if _active:
		return false
	if lines.is_empty():
		push_warning("Cannot start dialogue without any lines.")
		return false

	_lines = lines.duplicate()
	_line_index = 0
	_active = true
	_speaker_label.text = speaker
	_show_current_line()
	_dialogue_panel.show()
	get_tree().paused = true
	return true

func _advance_dialogue() -> void:
	_line_index += 1
	if _line_index >= _lines.size():
		_end_dialogue()
		return
	_show_current_line()

func _show_current_line() -> void:
	_dialogue_label.text = _lines[_line_index]

func _end_dialogue() -> void:
	_active = false
	_lines.clear()
	_dialogue_panel.hide()
	get_tree().paused = false

func _create_dialogue_ui() -> void:
	_dialogue_layer = CanvasLayer.new()
	_dialogue_layer.layer = 10
	_dialogue_layer.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(_dialogue_layer)

	_dialogue_panel = PanelContainer.new()
	_dialogue_panel.anchor_left = 0.06
	_dialogue_panel.anchor_right = 0.94
	_dialogue_panel.anchor_top = 0.70
	_dialogue_panel.anchor_bottom = 0.96
	_dialogue_panel.offset_left = 0
	_dialogue_panel.offset_top = 0
	_dialogue_panel.offset_right = 0
	_dialogue_panel.offset_bottom = 0
	_dialogue_panel.custom_minimum_size = Vector2(0, 130)
	_dialogue_panel.hide()
	_dialogue_layer.add_child(_dialogue_panel)

	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(0.035, 0.045, 0.075, 0.96)
	panel_style.border_color = Color(0.65, 0.78, 0.92, 1)
	panel_style.set_border_width_all(2)
	panel_style.set_corner_radius_all(8)
	panel_style.content_margin_left = 18
	panel_style.content_margin_top = 12
	panel_style.content_margin_right = 18
	panel_style.content_margin_bottom = 10
	_dialogue_panel.add_theme_stylebox_override("panel", panel_style)

	var layout := VBoxContainer.new()
	layout.add_theme_constant_override("separation", 6)
	_dialogue_panel.add_child(layout)

	_speaker_label = Label.new()
	_speaker_label.add_theme_font_size_override("font_size", 18)
	_speaker_label.add_theme_color_override("font_color", Color(0.65, 0.84, 1))
	layout.add_child(_speaker_label)

	_dialogue_label = Label.new()
	_dialogue_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_dialogue_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_dialogue_label.add_theme_font_size_override("font_size", 20)
	layout.add_child(_dialogue_label)

	_continue_label = Label.new()
	_continue_label.text = "F / Middle Mouse: Continue"
	_continue_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_continue_label.add_theme_font_size_override("font_size", 14)
	_continue_label.add_theme_color_override("font_color", Color(0.72, 0.76, 0.82))
	layout.add_child(_continue_label)
