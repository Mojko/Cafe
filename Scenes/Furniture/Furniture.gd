extends Spatial

func _ready():
	pass

func _process(delta):
	if(get_meta("on_ui") == true):
		rotate_y(0.1)
		rotate_x(0.3)
		rotate_z(0.2)
	else:
		rotation = Vector3(0, 0, 0)