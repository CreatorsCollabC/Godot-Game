extends Area2D


# Declare member variables here. Examples:
var falling = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if falling == true:
		self.position.y += 10
		if self.position.y >= 230:
			falling = false

func _on_Fire_body_entered(body: Node) -> void:
	if body.has_method("lose_life"):
		print("Lose Life")
		body.lose_life()

func commence():
	falling = true
