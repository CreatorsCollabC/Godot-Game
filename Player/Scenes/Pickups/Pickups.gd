tool
extends Area2D


const image_path = "res://Player/Assets/Powers/"

export(SpicePowerup.SpicePowerup) var spice : int setget set_spice
export var respawn_delay: float = 2.0

var spice_name 
var spice_respawn_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.spice = spice
	spice_respawn_timer = Timer.new();
	spice_respawn_timer.wait_time = respawn_delay;
	spice_respawn_timer.one_shot = true
	spice_respawn_timer.connect("timeout", self, "spawn_spice")
	add_child(spice_respawn_timer)
	spawn_spice()

func set_spice(p_spice : int):
	spice = p_spice
	spice_name = SpicePowerup.SpicePowerup.keys()[spice].to_lower()
	$Pickups_sprite.texture = load(image_path + spice_name + ".png")
	

func spawn_spice():
	print_debug("spawn_spice")
	$Pickups_sprite.show()


func _on_Pickups_body_entered(body: Node) -> void:
	if $Pickups_sprite.visible :
		spice_respawn_timer.start();
		$Pickups_sprite.hide()
		# the body can only be the player thanks to proper layer/mask
		body.pickup_spice(spice)
