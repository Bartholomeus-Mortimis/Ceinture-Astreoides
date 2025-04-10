extends Node2D
class_name Traceur

@export var équation: String = "x"
@export var temps_passer: float = 0.0
@export_group("Transformations")
@export var mode_transformations: bool = false
@export var type: String = "parabole"
@export var agr_v: float = 1.0
@export var agr_h: float = 1.0
@export var transl_v: float
@export var transl_h: float

var points: Array[Vector2] = []

func calculer_position(valeur_x: float):
	
	var valeur_y: float
	
	if mode_transformations:
		
		if type.to_lower() == "parabole":
			valeur_y = agr_v * pow(( 1/agr_h * valeur_x - transl_h), 2) + transl_v
		elif type.to_lower() == "sinus":
			valeur_y = agr_v * sin( deg_to_rad( 1/agr_h * valeur_x - transl_h )) + transl_v
		
	else:
		
		var expression: Expression = Expression.new()
		expression.parse(équation, ["x"])
		
		valeur_y = expression.execute([valeur_x])
	
	return valeur_y

func ajouter_point(p: Vector2):
	points.append(p)
	if points.size() > 100:
		points.pop_front()
