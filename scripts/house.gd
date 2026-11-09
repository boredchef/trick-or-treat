extends StaticBody3D

@onready var prompt : Label3D = $Label3D
@onready var dialogue: CanvasLayer = get_tree().get_first_node_in_group("dialogue")
@onready var battle: Control = get_tree().get_first_node_in_group("battle")

const REESES = preload("uid://iqompr37b88l")
@export var enemy: Resource = REESES 

@onready var player: CharacterBody3D = $"../../ProtoController"

var has_been_visited = false

func _ready() -> void:
	if battle != null: 
		battle.battle_won.connect(_on_battle_won)
		battle.battle_left.connect(_on_battle_left)
	else: 
		push_error("battle node is missing on "+name+"! pls assign one")

func _on_battle_left() -> void:
	player.resume_overworld()

func _on_battle_won() -> void:
	player.resume_overworld()

func interact() -> bool:
	if has_been_visited:
		return false
	has_been_visited = true
	prompt.text = "visited"
	if dialogue != null:
		dialogue.open_dialogue()
		if not dialogue.trick.is_connected(_on_dialogue_finished):
			dialogue.trick.connect(_on_dialogue_finished, CONNECT_ONE_SHOT)
		if not dialogue.treat.is_connected(_on_dialogue_finished):
			dialogue.treat.connect(_on_dialogue_finished, CONNECT_ONE_SHOT)
		return true
	return false

func _on_dialogue_finished():
	dialogue.visible = false
	
	if battle != null and enemy != null:
		battle.enemy = enemy
		battle.visible = true
		if battle.has_method("start_battle"):
			battle.start_battle()
	else:
		print(name, " has no enemy. finishing interaction.")
		if player != null:
			player.resume_overworld()
	
func show_prompt():
	if has_been_visited:
		prompt.text = "visited"
	else:
		prompt.text = "trick or treat"
	prompt.visible = true
	
func hide_prompt():
	prompt.visible = false
