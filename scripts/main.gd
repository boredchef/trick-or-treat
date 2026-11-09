extends Node3D


@onready var dialogue: CanvasLayer = $dialogue
@onready var battle: Control = $Battle

const REESES = preload("uid://iqompr37b88l")
@export var enemy: Resource = REESES 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var all_houses = get_tree().get_nodes_in_group("house")
	for house in all_houses:
		house.dialogue = dialogue
		house.battle = battle
		
		if house.enemy_resource == null: 
			house.enemy_resource = REESES
