extends GridContainer

export(int) var slotCount

var Slot = preload("res://InventorySlot.gd")

var inventory = []
var selectedItem = null

func _ready():
	for i in slotCount:
		var slot = Slot.new()
		add_child(slot)
		inventory.append(slot)
		
func add_item(index, item):
	inventory[index].set_item(item)
	pass
	
func get_selected_item():
	return selectedItem
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
