extends "res://Inventory.gd"

const Table = preload("res://Scenes/Furniture/Table/Table.tscn")
const Chair = preload("res://Scenes/Furniture/Chair/Chair.tscn")

signal on_item_select()
signal on_item_deselect()

var camera
var instansiatedObjects = []

#signal on_furniture_select(furniture)

func _ready():
	add_item(0, Table.get_instance_id())
	add_item(1, Chair.get_instance_id())
	camera = get_camera()
	pass
	
#Buy Item
func _on_inventory_slot_click(item):
	if(selectedItem != null):
		unselect_selected()
		
	var instance = instansiate_item(item)
	connect("on_item_select", instance, "_on_item_select")
	connect("on_item_deselect", instance, "_on_item_deselect")
	select_node(instance)
	instansiatedObjects.append(instance)
	
#Put item on grid cell if holding
func _on_raycast_hit(tile):
	if(Input.is_action_just_pressed("mouse_left") and tile.get_meta(Meta.TAG) == Tag.FURNITURE):
		select_node(tile)
		
	if(Input.is_action_just_released("mouse_left") and selectedItem != null):
		unselect_selected()
		return
	
	
#Remove item from hand
func _on_raycast_left():
	if(should_release_item()):
		var ui = get_3d_ui()
		ui.stop_follow_mouse()
		ui.remove_from_ui(selectedItem)
		instansiatedObjects.remove(instansiatedObjects.find(selectedItem))
		selectedItem.queue_free()
		selectedItem = null
		
func _on_raycast_just_hit(node):
#	if(node.get_meta(Meta.TAG) == Tag.FURNITURE and selectedItem == null):
#		select_node(node)
		
	var ui = get_3d_ui()
	ui.stop_follow_mouse()
	ui.remove_from_ui(selectedItem)

func _on_raycast_just_left():
	if(selectedItem == null or selectedItem.dropped):
		return
		
	var ui = get_3d_ui()
	ui.put_on_ui(selectedItem)
	ui.follow_mouse(selectedItem)
	
#Create a gameobject out of item
func instansiate_item(item):
	var tscn = instance_from_id(item)
	var instance = tscn.instance()
	get_owner().add_child(instance)
	instance.camera = get_camera()
	
	return instance
	
#func _on_furniture_select():
	
#	pass
	
func can_pickup_item(node):
	return node != null and node.get_meta(Meta.TAG) == Tag.FURNITURE
	
func tries_to_pickup_item(node):
	return Input.is_action_just_pressed("mouse_left") and can_pickup_item(node)

func is_holding_item():
	return Input.is_action_pressed("mouse_left") and selectedItem != null

func should_release_item():
	return Input.is_action_just_released("mouse_left") and selectedItem != null

func get_3d_ui():
	return get_camera().get_node(NodeDefinition.UI_3D)

func get_camera():
	return get_owner().get_node(NodeDefinition.MAIN_CAMERA)

func select_node(node):
	node.select()
	selectedItem = node
	emit_signal("on_item_select")

func unselect_selected():
	emit_signal("on_item_deselect")
	selectedItem.unselect()
	
#func _process(delta):
#	if(!onGrid and selectedItem != null):
#		selectedItem.rotate_x(0.1)
#		selectedItem.rotate_y(0.1)
#		selectedItem.rotate_z(0.1)
#	elif(onGrid and selectedItem != null):
#		selectedItem.rotation = Vector3(0,0,0)
#
#func _on_tile_select(tile, hold):
#	if(selectedItem == null):
#		return
#
#	if(Input.is_action_just_released("mouse_left")):
#		selectedItem = null
#
#	if(hold):
#		call_deferred("reparent", selectedItem, self)
#		selectedItem.global_transform.origin = Vector3(tile.global_transform.origin.x, 0, tile.global_transform.origin.z)
#		onGrid = true
#	pass
#
#func _on_inventory_slot_click(item):
#	var tscn = instance_from_id(item)
#	var instance = tscn.instance()
#	get_owner().add_child(instance)
#	selectedItem = instance
#
#	print("Selected item [", item, "]")
#	pass
#
#func _on_tile_remove():
#	if(selectedItem == null):
#		return
#
#	var normal = get_owner().get_node(NodeDefinition.MAIN_CAMERA).get_ray_normal()
#	call_deferred("reparent", selectedItem, get_owner().get_node(NodeDefinition.MAIN_CAMERA))
#	selectedItem.global_transform.origin = Vector3(normal.x, normal.y, normal.z)
#	onGrid = false
#
#	if(Input.is_action_just_released("mouse_left")):
#		print(selectedItem.get_parent())
#		call_deferred("reparent", selectedItem, self)
#		selectedItem.global_transform.origin = Vector3(0, -9999, 0)
#		selectedItem = null
#
#func reparent(node, parent):
#	if(node.get_parent() == parent):
#		return
#
#	node.get_parent().remove_child(node)
#	parent.add_child(node)
#	pass








#	if(tries_to_pickup_item(tile)):
#		select_node(tile)
#		selectedItem.pickup()
#
#	if(selectedItem != null):
#		if(tile != selectedItem):
#			for i in instansiatedObjects:
#				i.stop_ignore_raycast()
#		else:
#			for i in instansiatedObjects:
#				if(i != selectedItem):
#					i.ignore_raycast()
#
#	if(is_holding_item()):
#		if(tile != selectedItem):
#			if(selectedItem.dropped):
#				unselect_selected()
#				selectedItem = null
#				print("unselected")
#				return
#
#		#selectedItem != tile and tile.get_meta(Meta.TAG) != Tag.FURNITURE and 
#		var mouseDelta = get_camera().get_mouse_delta()
#		if((abs(mouseDelta.x) + abs(mouseDelta.y)) > 5):
#			var tilePosition = tile.global_transform.origin
#			print(selectedItem.global_transform.origin)
#			#selectedItem.global_transform.origin += Vector3(clamp(mouseDelta.x, -0.5, 0.5), 0, clamp(mouseDelta.y, -0.5, 0.5)) #Vector3(mouseDelta.x, 0, mouseDelta.y)
#		else:
#			selectedItem.ignore_raycast()
#
#	if(Input.is_action_just_released("mouse_left") and selectedItem != null):
#		selectedItem.stop_ignore_raycast()
#
#	if(should_release_item()):
#		selectedItem.drop()
		#camera.remove_tag_from_raycast_exceptions(Tag.FURNITURE)
	
#	if(selectedItem != null):
#		if(selectedItem.is_ignoring_raycast()):
#			print("NOW IGNORING RAYCAST")
#		else:
#			print("wew")

	#if(should_release_item()):
	#	selectedItem.drop()
	#	selectedItem.unselect()
	#	selectedItem = null