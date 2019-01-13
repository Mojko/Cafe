extends Node

func reparent(node, parent):
	call_deferred("private_reparent", node, parent)
	pass
	
func private_reparent(node, parent):
	node.get_parent().remove_child(node)
	parent.add_child(node)
	