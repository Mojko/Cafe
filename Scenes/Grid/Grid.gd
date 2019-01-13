extends Spatial

export(int) var width
export(int) var height
export(Color) var selectedColor
export(Color) var defaultColor

const GridTile = preload("res://Scenes/Grid/GridTile/GridTile.tscn")
const Array2D = preload("res://Library/Array2D.gd")

var grid
var selectedTile

func _ready():

	grid = Array2D.new().create(width, height)

	for y in height:
		for x in width:
			var tile = GridTile.instance()
			tile.set_meta(Tag.META_GROUP, Tag.GRID_TILE)

			var material = SpatialMaterial.new()
			material.albedo_color = Color(1.0, 1.0, 1.0)
			tile.get_node(NodeDefinition.MESH).set_material_override(material)

			add_child(tile)
			var scale = tile.global_transform.basis.get_scale()
			tile.global_transform.origin = Vector3(x * (scale.x * 2), 0, y * (scale.z * 2))
			pass
		pass
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_tile_select(tile):
	if(selectedTile != null):
		change_tile_color(defaultColor)

	selectedTile = tile
	change_tile_color(selectedColor)

func _on_tile_remove():
	if(selectedTile == null):
		return

	change_tile_color(defaultColor)

func change_tile_color(color):
	selectedTile.get_node(NodeDefinition.MESH).material_override.albedo_color = color
