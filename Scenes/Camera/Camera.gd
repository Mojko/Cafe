extends Camera

signal on_raycast_hit(node)
signal on_raycast_left()
signal on_raycast_just_hit(node)
signal on_raycast_just_left()
signal on_furniture_select()

var position = Vector2()
var velocity = Vector2()
var enteredGrid = false

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
	
	self.translate(Vector3(velocity.x, -velocity.y, 0) * delta)
	
	var hit = raycast()
	if(hit):
		var node = hit.collider.get_owner()
		var parent = hit.collider.get_parent()
		
		grid_enter(node)
	else:
		grid_leave()

#Runs every frame upon entering the grid
func grid_enter(node):
	emit_signal("on_raycast_hit", node)
	if(!enteredGrid):
		emit_signal("on_raycast_just_hit", node)
		enteredGrid = true
	
#Runs every frame upon leaving the grid
func grid_leave():
	emit_signal("on_raycast_left")
	if(enteredGrid):
		emit_signal("on_raycast_just_left")
		enteredGrid = false
	
#Refresh
func _on_inventory_slot_click(item):
	enteredGrid = !enteredGrid
	
func _input(event):
	if(!(event is InputEventMouseMotion)):
		return
		
	if(!(Input.is_action_pressed("mouse_right"))):
		return

	var previous = position
	position += event.relative
	
	var delta = (previous - position) * 2
	
	velocity = delta

func raycast():
	var mousePos = get_viewport().get_mouse_position()
	var origin = self.project_ray_origin(mousePos)
	var direction = self.project_ray_normal(mousePos) * 1000
	var hit = get_world().get_direct_space_state().intersect_ray(origin, direction, [], ~CollisionLayer.VAL_IGNORE_RAYCAST)
	
	return hit
	
func get_ray_normal():
	var mousePos = get_viewport().get_mouse_position()
	var origin = self.project_ray_origin(mousePos)
	var direction = self.project_ray_normal(mousePos)
	var to = origin + direction * 10
	return to
	
func get_3d_ui():
	return get_node("UI3D")