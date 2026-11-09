extends CanvasLayer

@export var label: Label
@export var treat_button: Button
@export var trick_button: Button
@export var dialogue: Array[String]

signal treat
signal trick
signal next_dialogue
signal done_dialogue

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		next_dialogue.emit()

func open_dialogue() -> void:
	show()
	label.visible = true
	treat_button.visible = false
	trick_button.visible = false
	
	print(dialogue)
	
	if dialogue != null:
		if dialogue.size() > 0:
			for line in dialogue:
				label.text = ""
				label.text = line
				await next_dialogue
		done_dialogue.emit()
		print("done with dialogue")
		treat_button.visible = true
		trick_button.visible = true
			
func _on_treat_button_pressed() -> void:
	print("treat mode...")
	
	treat_button.visible = false
	trick_button.visible = false
	label.text = "you asked for it!"
	
	await get_tree().create_timer(.5).timeout
	
	treat.emit()
	
func _on_trick_button_pressed() -> void:
	print("trick mode...")
	
	treat_button.visible = false
	trick_button.visible = false
	label.text = "prepare for no mercy!"
	
	await get_tree().create_timer(.5).timeout
	
	trick.emit()
