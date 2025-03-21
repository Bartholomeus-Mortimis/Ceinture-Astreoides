extends Node2D
class_name Traceur

@export_category("Paramètres de fonction")
@export var type: String
@export var agr_v: float = 1.0
@export var agr_h: float = 1.0
@export var transl_v: float
@export var transl_h: float

func calculer_position(valeur_x: float):
	
	var valeur_y: float
	
	if type.to_lower() == "parabole":
		valeur_y = agr_v * pow(( 1/agr_h * valeur_x - transl_h), 2) + transl_v
	elif type.to_lower() == "sinus":
		valeur_y = agr_v * sin( deg_to_rad( 1/agr_h * valeur_x - transl_h )) + transl_v
	
	return valeur_y
