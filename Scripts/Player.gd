extends KinematicBody2D



#ANIMATION TREE AND RAYCAST
onready var cast := $RayCast2D
onready var animation_tree=$AnimationTree
onready var animation_node=$AnimationTree.get("parameters/playback")

#MOVEMENT VARIABLES
var vel:Vector2
var momentum:Vector2
export var speed:int = 175
var is_attacking=false

#DIRECTION VARIABLES
enum direction{vertical,horizontal,diagonal}
var dir

#REWIND VARIABLES
var rewind:Array
var time:float = 0
signal Rewind(rewind,time)
var frame:int


#MAIN PHYSICS PROCESS FUNCTION-------------------------------------------------
func _physics_process(delta):
	
	time += delta
	frame += 1
	
	#MOVE HORIZONTALLY
	if Input.is_action_pressed("ui_left"):
		vel.x = -speed
		flip_sprites(true)
	elif Input.is_action_pressed("ui_right"):
		vel.x = speed
		flip_sprites(false)
	else:
		vel.x = 0
		
	#MOVE VERTICALLY 	
	if Input.is_action_pressed("ui_up"):
		vel.y = -speed
	elif Input.is_action_pressed("ui_down"):
		vel.y = speed
	else:
		vel.y = 0
	
	#ATTACK ON CLICK IF ATTACK ANIMATION NOT PLAYING
	if Input.is_action_just_pressed("Click") and animation_node.get_current_node()!="Attack":
		vel=Vector2.ZERO
		is_attacking=true
	
	
	#MOVE THE MOMENTUM TOWARDS ZERO EVERY FRAME
	momentum.x = move_toward(momentum.x,0,Physics2DServer.AREA_PARAM_LINEAR_DAMP*pow(momentum.x,2)*delta)
	momentum.y = move_toward(momentum.y,0,Physics2DServer.AREA_PARAM_LINEAR_DAMP*pow(momentum.y,2)*delta)
	
	#IF MOVING LERP MOMENTUM TOWARDS VELOCITY
	if vel.x != 0:
		momentum.x = move_toward(momentum.x,vel.x,speed*35*delta)
	if vel.y != 0:
		momentum.y = move_toward(momentum.y,vel.y,speed*35*delta)

	#MOVE AND ANIMATE PLAYER
	animate()
	move_and_slide(momentum)

	
	#REWIND MECHANISM STILL TO BE FIGURED OUT
	if (Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_left") or Input.is_action_just_released("ui_down") or Input.is_action_just_released("ui_up") or Input.is_action_just_released("ui_right") or Input.is_action_just_released("ui_left")) and frame >=3:
		rewind.append(Vector3(position.x,position.y,time))
		frame = 0




#FUNCTION THAT ANIMATES THE PLAYER SPRITE
func animate():
	
	#Play walking animation if momentum not zero
	if momentum!=Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position",momentum.normalized())
		animation_tree.set("parameters/Walk/blend_position",momentum.normalized())
		animation_node.travel("Walk")
	#Play idle animation
	else:
		animation_node.travel("Idle")
	
	#Play attack animation
	if is_attacking:
		cast.look_at(get_global_mouse_position())
		cast.rotation_degrees=0 if abs(cast.rotation_degrees)>=360 else cast.rotation_degrees
		#SET ATTACK DIRECTION ON SPRITES
		var attack_direction=position.direction_to(get_global_mouse_position())
		animation_tree.set("parameters/Attack/blend_position",attack_direction)
		animation_tree.set("parameters/Idle/blend_position",attack_direction)
		animation_node.travel("Attack")
		is_attacking=false



#FLIP_H  ON WALK AND ATTACK SPRITES
func flip_sprites(value):
	$AttackSprites.flip_h=value
	$WalkSprites.flip_h=value




