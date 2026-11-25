extends Node2D

@export var speaker_name: String = "Station Resident"
@export var dialogue_lines: Array[String] = [
	"Welcome to the station.",
	"Stay alert out there."
]

@onready var interaction_prompt: Label = $Label

var player_in_range: bool = false

func _ready() -> void:
	interaction_prompt.text = "Talk"
	interaction_prompt.hide()
	$Area2D.body_entered.connect(_on_area_body_entered)
	$Area2D.body_exited.connect(_on_area_body_exited)

func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact") and not DialogueManager.is_active():
		DialogueManager.start_dialogue(dialogue_lines, speaker_name)

func _on_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		interaction_prompt.show()

func _on_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		interaction_prompt.hide()
