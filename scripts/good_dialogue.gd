extends CanvasLayer

@export var label: Label
@export var treat_button: Button

@export var dialogue: Array[String] = []
signal yay
signal next_dialogue

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		next_dialogue.emit()

func open_dialogue() -> void:
	visible = true
	treat_button.visible = true
	
	print(dialogue)
	
	if dialogue != null:
		var count = 0
		var max_lines = dialogue.size()
		for line in dialogue:
			count += 1
			label.text = ""
			label.text = line
			await next_dialogue
			
func _on_treat_button_pressed() -> void:
	print("treat mode...")
	treat_button.visible = false
	label.text = "you asked for it!"
