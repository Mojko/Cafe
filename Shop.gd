extends "res://Inventory.gd"

const Table = preload("res://Scenes/Furniture/Table/Table.tscn")
const Chair = preload("res://Scenes/Furniture/Chair/Chair.tscn")

func _ready():
	add_item(0, Table.get_instance_id())
	add_item(1, Chair.get_instance_id())
	pass
	
#Buy Item
func _on_inventory_slot_click(item):
	selectedItem = instansiate_item(item)
	
#Put item on grid cell if holding
func _on_tile_select(tile):
	var ui = get_3d_ui()
	ui.remove_from_ui(selectedItem)
	
	if(is_holding_item()):
		var tilePosition = tile.global_transform.origin
		selectedItem.global_transform.origin = Vector3(tilePosition.x, 0, tilePosition.z)
		
	if(should_release_item()):
		selectedItem = null

#Remove item from hand
func _on_tile_remove():
	if(selectedItem == null):
		return
		
	if(should_release_item()):
		print("REelased item")
		selectedItem.queue_free()
		selectedItem = null
	else:
		var ui = get_3d_ui()
		ui.put_on_ui(selectedItem)
		ui.follow_mouse(selectedItem)
	
#Create a gameobject out of item
func instansiate_item(item):
	var tscn = instance_from_id(item)
	var instance = tscn.instance()
	get_owner().add_child(instance)
	return instance

func is_holding_item():
	return Input.is_action_pressed("mouse_left") and selectedItem != null

func should_release_item():
	return Input.is_action_just_released("mouse_left")

func get_3d_ui():
	return get_owner().get_node(NodeDefinition.MAIN_CAMERA).get_node(NodeDefinition.UI_3D)

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
