extends Control

signal textbox_closed

@export var enemy : Resource = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_health($CandyContainer/ProgressBar, enemy.health, enemy.health) 
	set_health($PlayerPanel/MarginContainer/PlayerData/ProgressBar, State.current_health, State.max_health) 
	$CandyContainer/Candy.texture = enemy.texture
	
	$Textbox.hide()
	$ActionsPanel.hide()
	
	display_text("A wild %s appears!" % enemy.name)
	await textbox_closed
	$ActionsPanel.show()

func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "HP:%d/%d" % [health, max_health]


func _input(event):
	if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and $Textbox.visible:
		$Textbox.hide()
		emit_signal("textbox_closed")

func display_text(text):
	$Textbox.show()
	$Textbox/Label.text = text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_run_pressed() -> void:
	display_text("got away, no candy for you :(")
	await textbox_closed
	await get_tree().create_timer(.5).timeout
	get_tree().quit()
