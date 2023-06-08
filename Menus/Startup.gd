extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/Start.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Start_pressed():
	get_tree().change_scene_to_file("res://Levels/Level 1/Level 1.tscn")

func _on_Levels_pressed():
	var levels = load("res://Menus/Levels.tscn").instantiate()
	get_tree().current_scene.add_child(levels)
	
func _on_Options_pressed():
	var options = load("res://Menus/Options.tscn").instantiate()
	get_tree().current_scene.add_child(options)
	
func _on_Quit_pressed():
	get_tree().quit()






