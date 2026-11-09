extends CanvasLayer

@export var label: Label
@export var treat_button: Button
@export var trick_button: Button

signal treat
signal trick

func _on_trick_button_pressed() -> void:
	print("well, okay..")
	treat_button.visible = false
	trick_button.visible = false
	label.text = "i don't really have any treats"
	
	await get_tree().create_timer(1.5).timeout 
	
	label.text = "uh oh i hear something"
	
	await get_tree().create_timer(.5).timeout
	
	trick.emit()

func _on_treat_button_pressed() -> void:
	print("treat mode...")
	treat_button.visible = false
	trick_button.visible = false
	label.text = "you asked for it!"
	
	await get_tree().create_timer(.5).timeout
	
	treat.emit()
