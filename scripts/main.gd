extends Node3D


@onready var dialogue: CanvasLayer = $dialogue
@onready var battle: Control = $Battle

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_K:
			print("forcing visiting all houses")
			var all_houses = get_tree().get_nodes_in_group("houses")
			for house in all_houses:
				house.has_been_visited = true
			check_win_condition()

func _ready() -> void:
	$Battle.battle_won.connect(_on_battle_won)
	var all_houses = get_tree().get_nodes_in_group("houses")
	for house in all_houses:
		if "dialogue" in house:
			house.dialogue = dialogue
		if "battle" in house:
			house.battle = battle
		
func _on_battle_won() -> void:
	check_win_condition()

func check_win_condition() -> void:
	var all_houses = get_tree().get_nodes_in_group("houses")
	
	if all_houses.is_empty():
		return
	for house in all_houses:
		if "has_been_visited" in house and not house.has_been_visited:
			return
	trigger_victory()
	
func trigger_victory() -> void:
	print("all houses visited! you win!!!")
	
