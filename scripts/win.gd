extends CanvasLayer

@export var dialogue: Array[String]
@export var label: Label

signal next_dialogue

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		next_dialogue.emit()

func open_dialogue() -> void:
	show()
	label.visible = true
	
	dialogue.append("you collected this many: "+str(State.candy))
		
	if dialogue != null:
		if dialogue.size() > 0:
			for line in dialogue:
				label.text = ""
				label.text = line
				await next_dialogue
			
		hide()
