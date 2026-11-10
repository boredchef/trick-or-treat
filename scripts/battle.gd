extends Control

signal textbox_closed
signal battle_won
signal battle_left

@export var enemy : Resource = null

var current_player_health = 0
var current_enemy_health = 0
var is_defending = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Textbox.hide()
	$ActionsPanel.hide()
	
func start_battle() -> void:
	current_player_health = State.current_health
	current_enemy_health = enemy.health

	
	set_health($CandyContainer/ProgressBar, enemy.health, enemy.health) 
	set_health($PlayerPanel/MarginContainer/PlayerData/ProgressBar, State.current_health, State.max_health) 
	$CandyContainer/Candy.texture = enemy.texture
	$CandyContainer/Candy.modulate = Color(1,1,1,1)
	
	$Textbox.hide()
	$ActionsPanel.hide()
	
	display_text("A wild %s appears!" % enemy.name)
	await textbox_closed
	$ActionsPanel.show()

func set_health(progress_bar, health, max_health):
	progress_bar.max_value = max_health
	progress_bar.value = health
	
	progress_bar.get_node("Label").text = "HP:%d/%d" % [health, max_health]


func _input(event):
	if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and $Textbox.visible:
		$Textbox.hide()
		textbox_closed.emit()

func display_text(text):
	$ActionsPanel.hide()
	$Textbox.show()
	$Textbox/Label.text = text

func enemy_turn():
	display_text("%s uses spooky attack" %  enemy.name)
	await textbox_closed
	
	if is_defending:
		is_defending = false
		$AnimationPlayer.play("mini_shake")
		await $AnimationPlayer.animation_finished
		display_text("you defended against %s successfully" % enemy.name)
		await textbox_closed
	else:
		current_player_health = max(0, current_player_health - enemy.damage)
		set_health($PlayerPanel/MarginContainer/PlayerData/ProgressBar, current_player_health, State.max_health)
		
		$AnimationPlayer.play("shake")
		await $AnimationPlayer.animation_finished
	
		display_text("%s dealt %d damage" % [enemy.name, enemy.damage])
		await textbox_closed
	$ActionsPanel.show()

func _on_run_pressed() -> void:
	display_text("well, heres a candy for the road dont worry :)")
	await textbox_closed
	await get_tree().create_timer(.5).timeout
	hide()
	
	State.candy += 1
	State.candy_collected.append(enemy.name)
		
	print(State.candy)
	print(State.candy_collected)
	
	battle_left.emit()
	
	
func _on_attack_pressed() -> void:
	display_text("you try and reach for the candy!")
	await textbox_closed
	
	current_enemy_health = max(0, current_enemy_health - State.damage)
	set_health($CandyContainer/ProgressBar, current_enemy_health, enemy.health)
	
	$AnimationPlayer.play("enemy_damage")
	await $AnimationPlayer.animation_finished
	
	display_text("you dealt %d damage" % State.damage)
	await textbox_closed
	
	if current_enemy_health == 0:
		display_text("%s is at last yours to eat :D" % enemy.name)
		await textbox_closed
		
		$AnimationPlayer.play("enemy_die")
		await $AnimationPlayer.animation_finished
		
		await get_tree().create_timer(.25).timeout
		hide()
		
		State.candy += 1
		State.candy_collected.append(enemy.name)
		
		print(State.candy)
		print(State.candy_collected)
				
		battle_won.emit()
		return
		
	enemy_turn()
	
func _on_defend_pressed() -> void:
	is_defending = true
	
	display_text("you take a little break!")
	await textbox_closed
	
	await get_tree().create_timer(.25).timeout
	
	enemy_turn()
	
	
