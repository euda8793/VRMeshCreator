class_name Dot
extends Spatial

export var color = Color.red setget _color_set, _color_get

func _color_set(col : Color):
	var new_mat = SpatialMaterial.new()
	new_mat.albedo_color = col
	$MeshInstance.mesh.surface_set_material(0, new_mat)
	
func _color_get():
	var thingy := $MeshInstance.mesh.surface_get_material(0) as SpatialMaterial
	return thingy.albedo_color
	
