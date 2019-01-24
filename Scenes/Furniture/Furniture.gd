extends Spatial

export(int) var renderedParts

var BaseMaterial = preload("res://Scenes/Furniture/wood.material")

var staticBody
var dropped
var selected
var camera

func _ready():
	staticBody = get_node("StaticBody")
	set_meta(Meta.TAG, Tag.FURNITURE)
	
	var material = BaseMaterial.duplicate()
	set_material(material)
	pass
	
func _process(delta):
	if(selected and dropped):
		if(Input.is_action_just_pressed("q")):
			rotation = Vector3(rotation.x, rotation.y + 150, rotation.z)
			
		if(Input.is_action_just_pressed("e")):
			rotation = Vector3(rotation.x, rotation.y - 150, rotation.z)
		pass
		
		var ray = camera.raycast_with_exception(self)
		var mouseDelta = camera.get_mouse_delta()
		
		if(ray.size() != 0 and (abs(mouseDelta.x) + abs(mouseDelta.y)) > 4):
			global_transform.origin = Vector3(int(ray["position"].x),0,int(ray["position"].z))#camera.get_ray_normal()["position"]#Vector3(-int(mouseDelta.x)%16, 0, -int(mouseDelta.y)%16)
			
func _on_node_entered_ui():
	if(staticBody == null):
		return
		
	staticBody.set_collision_layer_bit(CollisionLayer.BIT_GENERAL, false)
	staticBody.set_collision_layer_bit(CollisionLayer.BIT_IGNORE_RAYCAST, true)
	
func _on_node_left_ui():
	if(staticBody == null):
		return
		
	staticBody.set_collision_layer_bit(CollisionLayer.BIT_GENERAL, true)
	staticBody.set_collision_layer_bit(CollisionLayer.BIT_IGNORE_RAYCAST, false)
	
	var ray = camera.raycast()
	global_transform.origin = Vector3(ray["position"].x,0,ray["position"].z)
	
	drop()

func _on_item_select():
	ignore_raycast()

func _on_item_deselect():
	stop_ignore_raycast()

func drop():
	dropped = true
	
func pickup():
	dropped = false
	
func select():
	selected = true
	ignore_raycast()
	for i in renderedParts:
		get_child(i).get_surface_material(0).set_shader_param("selected", selected)

func unselect():
	selected = false
	stop_ignore_raycast()
	for i in renderedParts:
		get_child(i).get_surface_material(0).set_shader_param("selected", selected)
		
func set_material(material):
	for i in renderedParts:
		get_child(i).set_surface_material(0, material)

func set_shader_params():
	for i in renderedParts:
		get_child(i).get_surface_material(0).set_shader_param("selected", selected)
		
func ignore_raycast():
	staticBody.set_collision_layer_bit(CollisionLayer.BIT_GENERAL, false)
	staticBody.set_collision_layer_bit(CollisionLayer.BIT_IGNORE_RAYCAST, true)
	
func stop_ignore_raycast():
	staticBody.set_collision_layer_bit(CollisionLayer.BIT_GENERAL, true)
	staticBody.set_collision_layer_bit(CollisionLayer.BIT_IGNORE_RAYCAST, false)
	
func is_ignoring_raycast():
	return staticBody.get_collision_layer_bit(CollisionLayer.BIT_IGNORE_RAYCAST)
	
	
	
#	if(get_meta(Meta.ON_UI) == true):
#		#rotate_y(0.1)
#		#rotate_x(0.3)
#		#rotate_z(0.2)
#		#Make it instead so that a signal will cause this to happend instead of
#		#having it run every frame
#		if(staticBody != null):
#			staticBody.set_collision_layer_bit(CollisionLayer.BIT_GENERAL, false)
#			staticBody.set_collision_layer_bit(CollisionLayer.BIT_IGNORE_RAYCAST, true)
#	else:
#		if(!dropped):
#			rotation = Vector3(0, 0, 0)
#		#same here tie this to a signal this shouldnt run every frame
#		if(staticBody != null):
#			staticBody.set_collision_layer_bit(CollisionLayer.BIT_GENERAL, true)
#			staticBody.set_collision_layer_bit(CollisionLayer.BIT_IGNORE_RAYCAST, false)
