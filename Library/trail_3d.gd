class_name Trail3D extends MeshInstance3D

"""
Original Author: Oussama BOUKHELF
License: MIT
Version: 0.1
Email: o.boukhelf@gmail.com
Description: Advanced 2D/3D Trail system.
"""

var _points = []
var _widths = []
var _lifePoints = []

@export var _trailEnabled : bool = true

@export var _fromWidth : float = 0.5
@export var _toWidth : float = 0.0
@export_range(0.5, 1.5) var _scaleAcceleration : float = 1.0

@export var _motionDelta : float = 0.1
@export var _lifespan : float = 1.0

var _oldPos : Vector3
var referenceObject

var relative_basis :
	get:
		if referenceObject != null:
			return (global_position - referenceObject.position).normalized()
		else:
			return global_transform.basis.x
var reference_offset:
	get:
		if referenceObject != null:
			return referenceObject.position
		else:
			return Vector3.ZERO

func _ready():
	_oldPos = global_transform.origin
	mesh = ImmediateMesh.new()

func clear_points():
	_points.clear()
	_widths.clear()
	_lifePoints.clear()
	
func _process(delta):
	if (_oldPos - global_transform.origin).length() > _motionDelta and _trailEnabled:
		AppendPoint()
		_oldPos = global_transform.origin
	
	var p = 0
	var max_points = _points.size()
	while p < max_points:
		_lifePoints[p] += delta
		if _lifePoints[p] > _lifespan:
			RemovePoints(p)
			p-= 1
			if (p < 0): p = 0
			
		max_points = _points.size()
		p += 1
	
	mesh.clear_surfaces()
	
	if _points.size() < 2:
		return
	
	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	for i in range(_points.size()):
		var t = float(i) / (_points.size() - 1.0)
		
		var currWidth = _widths[i][0] - pow(1 - t, _scaleAcceleration) * _widths[i][1]
		
		var t0 = i / _points.size()
		var t1 = t
		
		mesh.surface_set_uv(Vector2(t0, 0))
		mesh.surface_add_vertex(to_local(_points[i] + reference_offset + currWidth))
		mesh.surface_set_uv(Vector2(t1, 1))
		mesh.surface_add_vertex(to_local(_points[i] + reference_offset - currWidth))
	mesh.surface_end()

func AppendPoint():
	_points.append(global_transform.origin - reference_offset)
	_widths.append([
		relative_basis * _fromWidth,
		relative_basis * _fromWidth - relative_basis * _toWidth])
	_lifePoints.append(0.0)

func RemovePoints(i):
	_points.remove_at(i)
	_widths.remove_at(i)
	_lifePoints.remove_at(i)
