@tool
extends Area2D


var next_scene = "res://Levels/Level 1/Level 1.tscn" 
@export var end_game = false: set = set_end_game

func set_end_game(value):
	end_game = value
	notify_property_list_changed()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Game_End_body_entered(body):
	if(end_game):
		get_tree().change_scene_to_file("res://Levels/Level 1/Level 1.tscn")
		
	get_tree().change_scene_to_file(next_scene)


func _get_property_list() -> Array:
	var res : Array
	if !end_game :
		res.append({
			name = "next_scene",
			type = TYPE_STRING,
			usage = PROPERTY_USAGE_DEFAULT
		})
	return res
