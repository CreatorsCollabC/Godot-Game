extends Area2D


# Declare member variables here. Examples:
var triggered_node

@export var triggered: NodePath

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func _on_Trigger_body_entered(body: Node) -> void:
	if body.has_method("lose_life"):
		print("Something was Triggered")
		triggered_node = get_node(triggered)
		triggered_node.commence()
