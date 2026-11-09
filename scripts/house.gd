extends StaticBody3D

@onready var prompt : Label3D = $Label3D
@export var dialogue: CanvasLayer
@export var battle: Control
@export var enemy: Resource 
@onready var player: CharacterBody3D = $"../../ProtoController"


var has_been_visited = false

func _ready() -> void:
	if battle != null: 
		battle.battle_won.connect(_on_battle_won)
	else: 
		push_error("battle node is missing on "+name+"! pls assign one")
func _on_battle_won() -> void:
	player.resume_overworld()

func interact():
	if has_been_visited:
		return false
	has_been_visited = true
	if dialogue != null:
		dialogue.visible = true
		if not dialogue.trick.is_connected(_on_dialogue_finished):
			dialogue.trick.connect(_on_dialogue_finished)
		if not dialogue.treat.is_connected(_on_dialogue_finished):
			dialogue.treat.connect(_on_dialogue_finished)
		return true
	return false

func _on_dialogue_finished():
	dialogue.visible = false
	
	battle.enemy = enemy
	
	battle.visible = true
	
func show_prompt():
	if has_been_visited != true:
		prompt.visible = true
	
func hide_prompt():
	prompt.visible = false
