extends Spatial

var position = Vector2(0,0)

func _ready():
	pass

func _process(delta):
	
	pass
func _input(event):
	if(!(event is InputEventMouseMotion)):
		return

#	if(!(Input.is_action_pressed("mouse_middle"))):
#		return
#
#	var previous = position
#	position += event.relative
#
#	var delta = (previous - position) * 2
#
#	rotate_y(sign(delta.x)/10)
	
	pass
