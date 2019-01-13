extends Node

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func create(columns, rows):
	var arr = []
	for i in rows:
		arr.append([])
		for j in columns:
			arr[i].append(0)
	return arr