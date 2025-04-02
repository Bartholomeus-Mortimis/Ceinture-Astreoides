extends Control
class_name Hud

signal équation_soumis

@export var équation: String = "0"
@export var expression: String = "0"

var opérateurs: Array = ["*", "+", "-", "/"]
var chiffres: Array = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
var symboles_avant: Array = ["√", "n", "s"]

func _on_line_edit_text_submitted(new_text: String) -> void:
	équation = new_text
	expression = équation_en_expression(équation)
	équation_soumis.emit()
	

func équation_en_expression(nouveau_équation: String):
	
	# Convertis le String en formule ultilisable par Godot
	print(nouveau_équation)
	
	nouveau_équation = nouveau_équation.replace(" ", "") # Enlève tout les espaces vide
	nouveau_équation = nouveau_équation.replace("x", "(x)") # Separer les variables des chiffres
	print(nouveau_équation)
	
	for i in nouveau_équation.length(): 
		if i > 0: 
			
			if nouveau_équation.substr(i, 1) == "(" and !opérateurs.has(nouveau_équation.substr(i-1, 1)) and !symboles_avant.has(nouveau_équation.substr(i-1, 1)) and nouveau_équation.substr(i-1, 1) != "(":
				# Ajoute des signes de multiplications au parathèses
				nouveau_équation = nouveau_équation.insert(i, "*")
	
	print(nouveau_équation)
	
	for i in nouveau_équation.length():
		if i > 0:
			if nouveau_équation.substr(i, 1) == "²" or nouveau_équation.substr(i, 1) == "³":
				
				var clôt: int
				
				if nouveau_équation.substr(i-1, 1) == ")":
					# Isoler la partie en parathèses qui doit être mise au exponentielle.
					clôt = trouveau_parathèse_correspondante(nouveau_équation, i)
					
				elif chiffres.has(nouveau_équation.substr(i-1, 1)) or nouveau_équation.substr(i-1, 1) == "x":
					# Isoler le nombre (ou variable) qui doit être mise au exponentielle.
					clôt = trouveau_chiffres_correspondante(nouveau_équation, i)
				
				if nouveau_équation.substr(i, 1) == "²":
					nouveau_équation = nouveau_équation.replace(nouveau_équation.substr(i-clôt, ( (i-1) - (i-clôt-1) )) + "²",  "pow(" + nouveau_équation.substr(i-clôt, ( (i-1) - (i-clôt-1) ) ) + ", 2)")
				elif nouveau_équation.substr(i, 1) == "³":
					nouveau_équation = nouveau_équation.replace(nouveau_équation.substr(i-clôt, ( (i-1) - (i-clôt-1) )) + "³",  "pow(" + nouveau_équation.substr(i-clôt, ( (i-1) - (i-clôt-1) ) ) + ", 3)")
		
		
		if nouveau_équation.substr(i, 1) == "√":
		
			var clôt: int
			
			if nouveau_équation.substr(i+1, 1) == "(":
				clôt = trouveau_parathèse_correspondante(nouveau_équation, i, -1)
				
			elif chiffres.has(nouveau_équation.substr(i+1, 1)):
				clôt =  trouveau_chiffres_correspondante(nouveau_équation, i, -1)
			
		
			nouveau_équation = nouveau_équation.replace( "√" + nouveau_équation.substr(i+1, ((i+clôt+1) - (i+1))), "sqrt(" + nouveau_équation.substr(i+1, ((i+clôt+1) - (i+1))) + ")" )
		
		if nouveau_équation.substr(i, 3) == "sin" or nouveau_équation.substr(i, 3) == "cos" or nouveau_équation.substr(i, 3) == "tan":
			
			var clôt: int
			
			if nouveau_équation.substr(i+3, 1) == "(":
				clôt = trouveau_parathèse_correspondante(nouveau_équation, i+2, -1)
				
			elif chiffres.has(nouveau_équation.substr(i+3, 1)):
				clôt =  trouveau_chiffres_correspondante(nouveau_équation, i+2, -1)
			
			if nouveau_équation.substr(i, 3) == "sin":
				nouveau_équation = nouveau_équation.replace( "sin" + nouveau_équation.substr(i+3, ((i+clôt+3) - (i+3))), "sin(" + nouveau_équation.substr(i+3, ((i+clôt+3) - (i+3))) + ")" )
			elif nouveau_équation.substr(i, 3) == "sin":
				nouveau_équation = nouveau_équation.replace( "cos" + nouveau_équation.substr(i+3, ((i+clôt+3) - (i+3))), "cos(" + nouveau_équation.substr(i+3, ((i+clôt+3) - (i+3))) + ")" )
			elif nouveau_équation.substr(i, 3) == "tan":
				nouveau_équation = nouveau_équation.replace( "tan" + nouveau_équation.substr(i+3, ((i+clôt+3) - (i+3))), "tan(" + nouveau_équation.substr(i+3, ((i+clôt+3) - (i+3))) + ")" )
		
		
	
	print(nouveau_équation)
	return nouveau_équation

func trouveau_parathèse_correspondante(string: String, position_départ: int, direction: int = 1): ## Recherche inversé par défaut.
	var paranthèse_voulu: int = 1
	var x: int = 1
	
	while paranthèse_voulu > 0:
		
		if string.substr(position_départ-( (1+x) * direction), 1) == "(":
			paranthèse_voulu -= (1 * direction)
		elif string.substr(position_départ-( (1+x) * direction), 1) == ")":
			paranthèse_voulu += (1 * direction)
		
		x += 1
	
	return x

func trouveau_chiffres_correspondante(string: String, position_départ: int, direction = 1): ## Recherche inversé par défaut. Le variable de l'équation "x" est compté comme une chiffre
	
	var x: int = 0
	
	while chiffres.has( string.substr(position_départ-( (1+x) * direction), 1) ) or string.substr(position_départ-( (1+x) * direction), 1).to_lower() == "x":
		x += 1
	
	return x
