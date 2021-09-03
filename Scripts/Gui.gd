extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
class_name Gui
onready var Hpool = $Hpool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func updateHp(value:float):
	Hpool.value = value
	pass
