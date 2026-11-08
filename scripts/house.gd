extends StaticBody3D

@onready var prompt : Label3D = $Label3D

func interact():
	print("trick or treat!")
	queue_free()

func show_prompt():
	prompt.visible = true
	
func hide_prompt():
	prompt.visible = false
