extends Area2D

export var move:Vector2 = Vector2(250,0)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	move = move.rotated(rotation)
	pass # Replace with function body.s


# Called every frame. 'delta' is the elapsed time since the previous frame.ss
func _process(delta):
	translate(move*delta)
	pass


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	pass # Replace with function body.
