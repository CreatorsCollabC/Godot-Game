extends TileMap


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	if event.is_action("restart"):
		$Player/Transition.start_transition()
