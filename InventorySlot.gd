extends Panel

signal on_inventory_slot_click(item)

var item = null

func _ready():
	rect_min_size = Vector2(64, 64)
	modulate = Color(255, 0, 0)
	connect("gui_input", self, "_on_gui_input")
	connect("on_inventory_slot_click", get_parent(), "_on_inventory_slot_click")
	pass

func set_item(item):
	print("Added item: [", item, "]")
	self.item = item
	
func _on_gui_input(event):
	if(event.is_action("mouse_left") and event.pressed):
		emit_signal("on_inventory_slot_click", item)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
