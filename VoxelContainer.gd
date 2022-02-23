class_name VoxelContainer
extends Spatial

onready var mesh := $VoxelMesh as MeshInstance
onready var right_controller := $"../ARVROrigin/ARVRControllerRight" as ARVRController

var dot_scene := preload("res://Dot.tscn")

var voxel_size = 0.05
var half_vox = voxel_size / 2.0
var start_vox = (voxel_size - half_vox) - voxel_size
var end_vox = (voxel_size + half_vox) - voxel_size
var voxels = {}
	
func _draw_mesh():
	var surface_tool = SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	for voxel in voxels.keys():	
		draw_voxel(voxel, surface_tool)		
		
	surface_tool.generate_normals()
	surface_tool.generate_tangents()
	surface_tool.index()
	
	mesh.mesh = surface_tool.commit()

var sides = [
	[Vector3(end_vox, end_vox, end_vox), Vector3(start_vox, end_vox, end_vox), Vector3(end_vox, start_vox, end_vox), Vector3(start_vox, start_vox, end_vox)],
	[Vector3(end_vox, end_vox, start_vox), Vector3(end_vox, start_vox, start_vox), Vector3(start_vox, end_vox, start_vox), Vector3(start_vox, start_vox, start_vox)],
	[Vector3(start_vox, end_vox, start_vox), Vector3(start_vox, end_vox, end_vox), Vector3(end_vox, end_vox, start_vox), Vector3(end_vox, end_vox, end_vox)],
	[Vector3(start_vox, start_vox, start_vox), Vector3(end_vox, start_vox, start_vox), Vector3(start_vox, start_vox, end_vox), Vector3(end_vox, start_vox, end_vox)],
	[Vector3(end_vox, start_vox, start_vox), Vector3(end_vox, end_vox, start_vox), Vector3(end_vox, start_vox, end_vox), Vector3(end_vox, end_vox, end_vox)],
	[Vector3(start_vox, start_vox, start_vox), Vector3(start_vox, start_vox, end_vox), Vector3(start_vox, end_vox, start_vox), Vector3(start_vox, end_vox, end_vox)]
]

func adjacent(pos: Vector3):
	return [
		voxels.has(pos + Vector3(0, 0, voxel_size)),
		voxels.has(pos + Vector3(0, 0, -voxel_size)),
		voxels.has(pos + Vector3(0, voxel_size, 0)),
		voxels.has(pos + Vector3(0, -voxel_size, 0)),
		voxels.has(pos + Vector3(voxel_size, 0, 0)),
		voxels.has(pos + Vector3(-voxel_size, 0, 0))
	]

func draw_side(side, pos, surface_tool):
	surface_tool.add_vertex(side[2] + pos)
	surface_tool.add_vertex(side[1] + pos)
	surface_tool.add_vertex(side[0] + pos)
	surface_tool.add_vertex(side[2] + pos)
	surface_tool.add_vertex(side[3] + pos)
	surface_tool.add_vertex(side[1] + pos)	
	
func draw_voxel(coord, surface_tool):
	var adjacent_voxels = adjacent(coord)
	for i in 6:
		if !adjacent_voxels[i]:
			draw_side(sides[i], coord, surface_tool)
	 
func _process(delta): 
	var right_global_origin := mesh.to_local(right_controller.global_transform.origin)
	var x = stepify(right_global_origin.x, voxel_size)
	var y = stepify(right_global_origin.y, voxel_size)
	var z = stepify(right_global_origin.z, voxel_size)
	var local_to_container = Vector3(x, y, z)
	if right_controller.is_button_pressed(JOY_VR_TRIGGER):
		voxels[local_to_container] = true
		_draw_mesh()

func _on_ARVRControllerRight_button_pressed(button):
	if button != JOY_VR_GRIP: return
	var new_origin = right_controller.global_transform.origin
	mesh.set_as_toplevel(true)
	global_transform.origin = new_origin
	mesh.set_as_toplevel(false)
	
	
		
