tool
extends AnimatedSprite


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func set_powerup_animation(spice, value : bool) :
	var shader_param = ""
	match spice:
		SpicePowerup.SpicePowerup.GREEN_CHILLI :
			shader_param = "green_chilli_aura"
		SpicePowerup.SpicePowerup.RED_CHILLI :
			shader_param = "red_chilli_aura"
		SpicePowerup.SpicePowerup.GHOST_CHILLI :
			shader_param = "ghost_chilli_effect"
	material.set_shader_param(shader_param, value)

func _set(property, value):
	if property == "animation" :
		if animation != value :
			print(value)
			animation = value
			var offset = Vector2.UP
			match value :
				"run" :
					offset.x = -0.6
				"falling" :
					offset.y = -1.5
				"jump up" :
					offset.y = 0.5
			material.set_shader_param("offset", offset)
		return true
