extends Camera

signal on_tile_select(tile)
signal on_tile_remove()

var position = Vector2()
var velocity = Vector2()

func _ready():
	pass

func _process(delta):
	
	velocity.x = lerp(velocity.x, 0, 0.1)
	velocity.y = lerp(velocity.y, 0, 0.1)
	
	self.translate(Vector3(velocity.x, -velocity.y, 0) * delta)
	
	
	var hit = raycast()
	if(hit):
		var root = hit.collider.get_owner()
		if(root.get_meta(Tag.META_GROUP) == Tag.GRID_TILE):
			emit_signal("on_tile_select", root)
	else:
		emit_signal("on_tile_remove")
		
			
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
	var hit = get_world().get_direct_space_state().intersect_ray(origin, direction)
	
	return hit
	
func get_ray_normal():
	var mousePos = get_viewport().get_mouse_position()
	var origin = self.project_ray_origin(mousePos)
	var direction = self.project_ray_normal(mousePos)
	var to = origin + direction * 10
	return to
	
func get_3d_ui():
	return get_node("UI3D")