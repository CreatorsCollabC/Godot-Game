extends Sprite

var t = 1
var dir = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_visible(false)

func start_transition():
	if dir == 0:
		t = 1
		dir = -1
		set_visible(true)

func reverse():
	if dir == 0:
		t = 0
		dir = 1
		set_visible(true)

func _process(delta):
	t += delta * dir
	if dir != 0:
		get_material().set_shader_param("t",t)
	
	if t <= 0 and dir < 0:
		dir = 1
		t = 0
		get_tree().reload_current_scene()
	elif t >= 1 and dir > 0:
		dir = 0
		set_visible(false)
