extends Spatial

var staticBody

func _ready():
	staticBody = get_node("StaticBody")
	set_meta(Meta.TAG, Tag.FURNITURE)
	pass

func _process(delta):
	if(get_meta(Meta.ON_UI) == true):
		#rotate_y(0.1)
		#rotate_x(0.3)
		#rotate_z(0.2)
		#Make it instead so that a signal will cause this to happend instead of
		#having it run every frame
		if(staticBody != null):
			staticBody.set_collision_layer_bit(CollisionLayer.BIT_GENERAL, false)
			staticBody.set_collision_layer_bit(CollisionLayer.BIT_IGNORE_RAYCAST, true)
	else:
		rotation = Vector3(0, 0, 0)
		#same here tie this to a signal this shouldnt run every frame
		if(staticBody != null):
			staticBody.set_collision_layer_bit(CollisionLayer.BIT_GENERAL, true)
			staticBody.set_collision_layer_bit(CollisionLayer.BIT_IGNORE_RAYCAST, false)