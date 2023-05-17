extends AspectRatioContainer
class_name SpicePowerup

signal use_spice
signal end_spice

enum SpicePowerup {
	GREEN_CHILLI = 0,
	RED_CHILLI = 1,
	BLACK_PEPPER = 2,
	GHOST_CHILLI = 3,
}

var durations = {
	SpicePowerup.RED_CHILLI : 5,
	SpicePowerup.GREEN_CHILLI : 5,
	SpicePowerup.BLACK_PEPPER : 5,
	SpicePowerup.GHOST_CHILLI : 2,
}

var colors = {
	SpicePowerup.RED_CHILLI : Color.red,
	SpicePowerup.GREEN_CHILLI : Color.green,
	SpicePowerup.BLACK_PEPPER : Color.brown,
	SpicePowerup.GHOST_CHILLI : Color.cornflower,
}

const image_path = "res://Player/Assets/Powers/"


var spice_name : String
var duration : float 
var time_until_powerup_end : float

export(SpicePowerup) var spice : int setget set_spice, get_spice
func set_spice(value : int):
	spice = value
	duration = durations[spice]
	spice_name = SpicePowerup.keys()[spice].to_lower()
	if !is_inside_tree() :
		yield(self,"ready")
	$Overlay/progress_bar/ColorRect.color = colors[spice]/4.0 + Color.black * 3/4.0
	$Overlay.self_modulate = colors[spice] / 4.0 + Color.black * 3/4.0

func get_spice():
	return spice

var spice_available : bool setget set_spice_available, get_spice_available
func set_spice_available(value):
	if value :
		$Overlay/progress_bar.value = 0
	else : 
		$Overlay/progress_bar.value = 100
	$Overlay/progress_bar/Button.disabled = !value
func get_spice_available():
	if is_inside_tree() :
		return $Overlay/progress_bar/Button.disabled
	return false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Overlay/progress_bar.material = $Overlay/progress_bar.material.duplicate(true)
	var tooltip = "to activate this power you can ether click on it or use one of these shortcut :"
	for event in InputMap.get_action_list(spice_name):
		tooltip += "\n\t - " + event.as_text()
	$Overlay/TextureRect/Label.text = InputMap.get_action_list(spice_name)[0].as_text().trim_suffix("(Physical)")
	$Overlay/progress_bar/Button.hint_tooltip = tooltip
	$Overlay/progress_bar/Button.shortcut.shortcut.action = spice_name
	$Overlay/progress_bar/spice_image.texture = load(image_path + spice_name + ".png")


func _process(delta: float) -> void:
	if time_until_powerup_end :
		time_until_powerup_end -= delta 
		if time_until_powerup_end <= 0 :
			time_until_powerup_end = 0
			emit_signal("end_spice")
			
		$Overlay/progress_bar.value = 100.0 -  time_until_powerup_end / duration * 100
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Button_pressed() -> void:
	time_until_powerup_end = duration 
	self.spice_available = false #use self to trigger the setter
	emit_signal("use_spice")

func pickup():
	if time_until_powerup_end > 0: # prolongued effect if the powerup is already running
		time_until_powerup_end = duration
	else:
		self.spice_available = true
