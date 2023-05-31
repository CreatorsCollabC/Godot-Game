extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$"VBoxContainer/Level 1".grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Level_1_pressed():
	get_tree().change_scene("res://Levels/Level 1/Level 1.tscn")

func _on_Level_2_pressed():
	get_tree().change_scene("res://Levels/Level 2/Level 2.tscn")

func _on_Level_3_pressed():
	get_tree().change_scene("res://Levels/Level Containment/Level Containment.tscn")

func _on_Level_4_pressed():
	get_tree().change_scene("res://Levels/Level-Ants-Test/Ants-Test.tscn")

func _on_Level_5_pressed():
	get_tree().change_scene("res://Levels/test level/test_room.tscn")
	
func _on_Level_6_pressed():
	get_tree().change_scene("res://Levels/Level Game Won/Level Game Won.tscn")

func _on_Level_7_pressed():
	pass

func _on_Back_pressed():
	get_tree().change_scene("res://Menus/Startup.tscn")
