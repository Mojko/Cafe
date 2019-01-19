extends Spatial

var uiElements = []
var uiParentsElements = []
var nodeFollowingMouse = null

func _ready():
	pass

func _process(delta):
	if(nodeFollowingMouse != null):
		nodeFollowingMouse.global_transform.origin = get_parent().get_ray_normal()
	pass

func put_on_ui(node):
	if(node == null or node.get_meta(Meta.ON_UI) == true):
		return
	
	node.set_meta(Meta.ON_UI, true)
	uiElements.append(node)
	uiParentsElements.append(node.get_parent())
	
	set_parent(node, self)
	pass
	
func remove_from_ui(node):
	if(node == null or node.get_meta(Meta.ON_UI) == false):
		return
		
	var index = uiElements.find(node)
	node.set_meta(Meta.ON_UI, false)
	set_parent(node, uiParentsElements[index])
	uiElements.remove(index)
	uiParentsElements.remove(index)
	print("Removed from ui")
	pass
	
func follow_mouse(node):
	if(node == null or node.get_meta(Meta.ON_UI) == false):
		return
		
	nodeFollowingMouse = node
	
func stop_follow_mouse():
	nodeFollowingMouse = null
	
func free(node):
	stop_follow_mouse()
	remove_from_ui(node)
	
func set_parent(node, parent):
	call_deferred("private_set_parent", node, parent)
	pass

func private_set_parent(node, parent):
	node.get_parent().remove_child(node)
	parent.add_child(node)
	pass
