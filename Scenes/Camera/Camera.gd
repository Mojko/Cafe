extends Camera

signal on_raycast_hit(node)
signal on_raycast_left()
signal on_raycast_just_hit(node)
signal on_raycast_just_left()
signal on_furniture_select()

var position = Vector2()
var velocity = Vector2()
var hasRayHit = false
var currentRaycastedNode
var zoom = 1
var raycastHits = []
var raycastExceptions = []
var mouseDelta = 0

func _ready():
	var shop = get_owner().get_node("UI/Shop")
	connect("on_raycast_hit", shop, "_on_raycast_hit")
	connect("on_raycast_left", shop, "_on_raycast_left")
	connect("on_raycast_just_hit", shop, "_on_raycast_just_hit")
	connect("on_raycast_just_left", shop, "_on_raycast_just_left")
	
	var grid = get_owner().get_node("Grid")
	connect("on_raycast_hit", grid, "_on_raycast_hit")
	connect("on_raycast_left", grid, "_on_raycast_left")

func _process(delta):
	velocity.x = lerp(velocity.x, 0, 0.1)
	velocity.y = lerp(velocity.y, 0, 0.1)
	
	self.translate(Vector3(velocity.x, -velocity.y/2, zoom * 40) * delta)
	#if(Input.is_action_pressed("lalt")):
	if(Input.is_action_pressed("mouse_middle")):
		var mouseDelta = get_mouse_delta()
		if(Input.is_action_pressed("lalt")):
			if(abs(mouseDelta.y) > 5):
				self.global_rotate(Vector3(sign(mouseDelta.y)/100,0,0).normalized(), deg2rad(1))
				#self.global_rotate(Vector3(sign(mouseDelta.y)/100, 0, 0), 45)
				#self.rotate_x(sign(mouseDelta.y)/100)
		else:
			if(abs(mouseDelta.x) > 5):
				self.global_rotate(Vector3(0,sign(mouseDelta.x)/50,0).normalized(), deg2rad(1))
				#self.global_rotate(Vector3(0, sign(mouseDelta.x)/50, 0), 45)
				#self.rotate_y(sign(mouseDelta.x)/50)
	
	if(zoom != 0):
		zoom = 0
		
	var hit = raycast()
	if(hit):
		var node = hit.collider.get_owner()
		var parent = hit.collider.get_parent()
		
		if(!raycastHits.has(node)):
			raycastHits.append(node)
		
		grid_enter(node)
	else:
		grid_leave()

#Runs every frame upon entering the grid
func grid_enter(node):
	if(node != currentRaycastedNode):
		hasRayHit = !hasRayHit

	emit_signal("on_raycast_hit", node)
	if(!hasRayHit):
		emit_signal("on_raycast_just_hit", node)
		hasRayHit = true
		currentRaycastedNode = node
	
#Runs every frame upon leaving the grid
func grid_leave():
	emit_signal("on_raycast_left")
	if(hasRayHit):
		emit_signal("on_raycast_just_left")
		hasRayHit = false
		currentRaycastedNode = null
	
#Refresh
func _on_inventory_slot_click(item):
	hasRayHit = !hasRayHit
	
func _input(event):
	if(event is InputEventMouseButton):
		if(event.is_pressed()):
			if(event.button_index == BUTTON_WHEEL_UP):
				zoom = -1
				
			if(event.button_index == BUTTON_WHEEL_DOWN):
				zoom = 1
	
	
	if(!(event is InputEventMouseMotion)):
		return
	
	var previous = position
	position += event.relative

	mouseDelta = (previous - position) * 2
	
	if(!(Input.is_action_pressed("mouse_right"))):
		return

	velocity = mouseDelta
	pass

func add_tag_to_raycast_exceptions(tag):
	for i in raycastHits:
		if(i.get_meta(Meta.TAG) == tag):
			if(!raycastExceptions.has(i)):
				print("Ignoring raycast: ", i.get_name())
				raycastExceptions.append(i)

func remove_tag_from_raycast_exceptions(tag):
	for i in raycastExceptions:
		if(i.get_meta(Meta.TAG) == tag):
			if(raycastExceptions.has(i)):
				print("Removed from ignoring raycast: ", i.get_name())
				raycastExceptions.remove(tag)

func raycast():
	var mousePos = get_viewport().get_mouse_position()
	var origin = self.project_ray_origin(mousePos)
	var direction = self.project_ray_normal(mousePos) * 1000
	var hit = get_world().get_direct_space_state().intersect_ray(origin, direction, raycastExceptions, ~CollisionLayer.VAL_IGNORE_RAYCAST)
	
	return hit
	
func raycast_with_exception(exception):
	var mousePos = get_viewport().get_mouse_position()
	var origin = self.project_ray_origin(mousePos)
	var direction = self.project_ray_normal(mousePos) * 1000
	var exceptions = []
	exceptions.append(exception)
	var hit = get_world().get_direct_space_state().intersect_ray(origin, direction, exceptions, ~CollisionLayer.VAL_IGNORE_RAYCAST)
	
	return hit
	
func get_ray_normal():
	var mousePos = get_viewport().get_mouse_position()
	var origin = self.project_ray_origin(mousePos)
	var direction = self.project_ray_normal(mousePos)
	var to = origin + direction * 22
	return to
	
func get_mouse_delta():
	return mouseDelta
	pass
	
func get_3d_ui():
	return get_node("UI3D")