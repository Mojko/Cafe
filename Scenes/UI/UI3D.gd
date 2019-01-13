extends Spatial

var uiElements = []
var uiParentsElements = []

func _ready():
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func put_on_ui(node):
	if(node.get_meta("on_ui") == true):
		return
	
	node.set_meta("on_ui", true)
	uiElements.append(node)
	uiParentsElements.append(node.get_parent())
	
	set_parent(node, self)
	pass
	
func remove_from_ui(node):
	if(node == null or node.get_meta("on_ui") == false):
		return
		
	var index = uiElements.find(node)
	node.set_meta("on_ui", false)
	set_parent(node, uiParentsElements[index])
	uiElements.remove(index)
	uiParentsElements.remove(index)
	print("Removed from ui")
	pass
	
func follow_mouse(node):
	if(node.get_meta("on_ui") == true):
		node.global_transform.origin = get_parent().get_ray_normal()
	
func set_parent(node, parent):
	call_deferred("private_set_parent", node, parent)
	pass

func private_set_parent(node, parent):
	node.get_parent().remove_child(node)
	parent.add_child(node)
	pass
