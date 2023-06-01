extends KinematicBody2D
class_name Player

export var gravity = 50 #this is the rate the y velocity is changed
export var max_fall_speed = 1000
export var acceleration = 40
export var jump_power = 200
export var max_speed = 280
export var friction : int = 15 #in percentage
export var coyote_time = .2
export var reduced_gravity_factor_on_coyote_time = 0.1

var baseGravity = 0
var base_max_speed = 0

export var max_speed_scale_factor = 1.5
export var acceleration_scale_factor = 1.5
export var size_scale_factor = 3
export var jump_power_scale_factor = 0.5

var friction_scale : float = 1.0 - friction / 100.0
var velocity = Vector2(0,0) #the speed is changed when player moves horizontally
var coyote_timer : Timer;
var is_jumping: bool;
var was_on_floor: bool;

var spice_powerup_scene = preload("res://Player/Scenes/Spice powerup/Spice powerup.tscn")
var spice_scenes : Dictionary

#Health
var health_scene = preload("res://Player/Scenes/Stats/Health.tscn")
var healthcount = 3

func _ready() -> void:
	for spice in  SpicePowerup.SpicePowerup.values() :
		var instanced_scene = spice_powerup_scene.instance()
		instanced_scene.spice = spice
		instanced_scene.connect("use_spice",self,"use_spice",[spice])
		instanced_scene.connect("end_spice",self,"end_spice",[spice])
		instanced_scene.spice_available = false
		spice_scenes[spice] = instanced_scene
		$AnimationSprite.set_powerup_animation(spice, false)
		$GUI/Control/MarginContainer/HBoxContainer.add_child(instanced_scene)
	
	#Health
	var health_bar1 = health_scene.instance()
	$GUI/Control2/MarginContainer/HBoxContainer.add_child(health_bar1)
	
	#Transition.new_pos(position)
	$Transition.reverse()
	
	coyote_timer = Timer.new()
	coyote_timer.one_shot = true
	coyote_timer.wait_time = coyote_time
	add_child(coyote_timer)

func _process(_delta: float) -> void:
	if velocity.x < 0 :
		$AnimationSprite.flip_h = true
	if velocity.x > 0 :
		$AnimationSprite.flip_h = false
	
	if gravity == 0:
		$AnimationSprite.animation = "default"
	elif is_on_floor() :
		if velocity.x != 0:
			$AnimationSprite.speed_scale = abs(velocity.x) / 300
			$AnimationSprite.animation = "run"
		else :
			$AnimationSprite.animation = "default"
	else :
		if abs(velocity.y) < 3 * gravity:
			$AnimationSprite.animation = "floating"
		elif velocity.y > 0 : 
			$AnimationSprite.animation = "falling"
		else:
			$AnimationSprite.animation = "jump up"

func _physics_process(_delta): 
	
	if gravity == 0 : #handles input in ghost form
		var direction := Vector2.ZERO
		if Input.is_action_pressed("Right"):
			direction.x+= 1
		if Input.is_action_pressed("Left"):
			direction.x-=1
		if Input.is_action_pressed("Jump"):
			direction.y-=1
		if Input.is_action_pressed("ui_down"):
			direction.y+=1
		velocity = max_speed * direction.normalized()
		position += velocity * _delta
		return
	
	var speed = velocity.x
	
	if Input.is_action_pressed("Right"): #move right
		if speed > max_speed: # if you are too fast you're gonna burn 
			speed -= (speed - max_speed) * friction / 100.0
		elif speed < -acceleration * 100.0 / friction : # fast brake on trying to move on adiffernet direction than where you are currently going
			speed *= friction_scale
			speed += acceleration
		else : # normal acceleration
			speed += acceleration

	elif Input.is_action_pressed("Left"): #move left just as move right
		if speed < -max_speed: 
			speed -= (speed + max_speed) * friction / 100.0
		elif speed > acceleration * 100.0 / friction :
			speed *= friction_scale
			speed += -acceleration
		else :
			speed += -acceleration

	elif is_on_floor():
		if abs(speed) < acceleration :
			speed = 0
		if abs(speed) < acceleration * 100 / friction:
			speed -= acceleration * sign(speed) 
		else : 
			speed *= (friction_scale + 3)/4

	velocity.x = speed
	
	if(is_on_floor()):
		velocity.y = 1 # at least 1 just to make sure we touch the floor every frame and is_on_floor stay true
		is_jumping = false
	elif not coyote_timer.is_stopped() and Input.is_action_pressed("Jump"):
		velocity.y += gravity *reduced_gravity_factor_on_coyote_time
	else:
		velocity.y += gravity #makes the player fall
		velocity.y = min(velocity.y, max_fall_speed)

	if is_on_floor() :
		if Input.is_action_just_pressed("Jump"): #jumping
			velocity.y = -jump_power 
			is_jumping = true
			coyote_timer.start()

	var new_velocity = move_and_slide(velocity,Vector2.UP) #able to move
	
		 
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider is MovableObject :
			collision.collider.push_object(velocity.length() * collision.normal)
	velocity = new_velocity


func use_spice(spice : int) : #called when a spice efects starts
	match spice :
		SpicePowerup.SpicePowerup.BLACK_PEPPER : #makes the player larger
			var tween := create_tween()
# warning-ignore:return_value_discarded
			tween.tween_property(self,"scale",size_scale_factor * Vector2.ONE,0.2)

		SpicePowerup.SpicePowerup.GREEN_CHILLI: #makes the player faster
			acceleration *= acceleration_scale_factor
			max_speed *= max_speed_scale_factor

		SpicePowerup.SpicePowerup.RED_CHILLI: # makes the player jump higher
			jump_power *= jump_power_scale_factor
			
		SpicePowerup.SpicePowerup.GHOST_CHILLI:
			baseGravity = gravity
			$AnimationSprite.get_material().set_shader_param("effect",1)
			gravity = 0
			velocity.y = 0
			set_collision_mask_bit(0,false)
			set_collision_layer_bit(0,false)
	
	$AnimationSprite.set_powerup_animation(spice, true)

func end_spice(spice : int) : #called when a spice effects ends
	match spice :
		SpicePowerup.SpicePowerup.BLACK_PEPPER : #return player to its normal size
			var tween := create_tween()
# warning-ignore:return_value_discarded
			tween.tween_property(self,"scale", Vector2.ONE,0.2) 

		SpicePowerup.SpicePowerup.GREEN_CHILLI: #return player to its normal speed
			acceleration /= acceleration_scale_factor
			max_speed /= max_speed_scale_factor

		SpicePowerup.SpicePowerup.RED_CHILLI: # return player to its normal jump power
			jump_power /= jump_power_scale_factor
			
		SpicePowerup.SpicePowerup.GHOST_CHILLI:
			$AnimationSprite.get_material().set_shader_param("effect",0)
			gravity = baseGravity
			set_collision_mask_bit(0,true)
			set_collision_layer_bit(0,true)
			var coor = (position - Vector2(0,50)) / 32 
			if get_node("/root/Level").get_cell(coor.x,coor.y) == 0:
				#get_node("/root/Level").set_cell(coor.x,coor.y,-1)
				$Transition.start_transition()

	$AnimationSprite.set_powerup_animation(spice, false)


func pickup_spice(spice : int) : #called when you pickup a spice
	spice_scenes[spice].pickup()
	
func lose_life() : #called when you take damage
	healthcount -= 1
	if healthcount == 2:
		$GUI/Control2/MarginContainer/HBoxContainer/Control/Health3.hide()
	elif healthcount == 1:
		$GUI/Control2/MarginContainer/HBoxContainer/Control/Health2.hide()
	elif healthcount == 0:
		$GUI/Control2/MarginContainer/HBoxContainer/Control/Health1.hide()
		
