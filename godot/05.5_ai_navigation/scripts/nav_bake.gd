# SESIÓN B · escena 07 — hornear el navmesh desde el tilemap.  ✅ demo (apoyo)
#
# El "camino del motor": en vez de una grilla de celdas (AStarGrid2D), Godot usa
# un NAVMESH: un polígono del área caminable. Acá lo HORNEAMOS en runtime a partir
# del mismo mundo de tiles:
#   - área caminable  = el cuarto entero (un rectángulo adentro del borde).
#   - obstáculos       = un cuadrado por cada celda pintada en "Paredes".
# bake_from_source_geometry_data recorta los obstáculos del área caminable y arma
# el polígono. Después el NavigationAgent2D navega sobre él.

extends NavigationRegion2D

@export var mundo_path: NodePath
@export var margen: float = 4.0   # radio del agente: encoge el área caminable

func _ready() -> void:
	call_deferred("_hornear")

func _hornear() -> void:
	var mundo := get_node(mundo_path)
	var paredes: TileMapLayer = mundo.get_node("Paredes")

	var poly := NavigationPolygon.new()
	poly.agent_radius = margen

	var src := NavigationMeshSourceGeometryData2D.new()
	# área caminable: el cuarto entero (adentro del cerco de borde, 1 tile = 16px)
	src.add_traversable_outline(PackedVector2Array([
		Vector2(16, 16), Vector2(304, 16), Vector2(304, 176), Vector2(16, 176)
	]))
	# obstáculos: un cuadrado de 16x16 centrado en cada celda de pared
	for c in paredes.get_used_cells():
		var centro := paredes.map_to_local(c)
		src.add_obstruction_outline(PackedVector2Array([
			centro + Vector2(-8, -8), centro + Vector2(8, -8),
			centro + Vector2(8, 8), centro + Vector2(-8, 8)
		]))

	NavigationServer2D.bake_from_source_geometry_data(poly, src)
	navigation_polygon = poly
