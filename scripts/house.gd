extends StaticBody3D

@onready var prompt : Label3D = $Label3D

var has_been_visted = false

func interact():
	print("trick or treat!")
	has_been_visted = true	

func show_prompt():
	if has_been_visted != true:
		prompt.visible = true
	
func hide_prompt():
	prompt.visible = false
