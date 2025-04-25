extends Control
class_name Hud

signal équation_soumis
signal boutton_menu_pesser

@onready var panel_équation: Panel = $Panel

@onready var niveau_id: Label = $NiveauId

@onready var cano_edit: LineEdit = $"Panel/ÉcriveurCanonique/CanoniqueEdit"
@onready var message_erreur_canonique: Label = $"Panel/ÉcriveurCanonique/Erreur"

@onready var écriveur_canonique: Control = $Panel/ÉcriveurCanonique
@onready var écriveur_transformations: Control = $Panel/ÉcriveurTransformations
@onready var second_degrée: Control = $Panel/ÉcriveurTransformations/SecondDegrée

@export var équation: String = "0"
@export var expression: String = "0"

var opérateurs: Array = ["*", "+", "-", "/"]
var chiffres: Array = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
var symboles_avant: Array = ["√", "n", "s"]


#region Canonique

func _on_line_edit_text_submitted(new_text: String) -> void:
	équation = new_text
	expression = await équation_en_expression(équation)
	
	# Tester l'expression
	
	if expression == "":
		message_erreur_canonique.show()
		await get_tree().create_timer(1.0).timeout
		message_erreur_canonique.hide()
		return
	
	var test_expression: Expression = Expression.new()
	test_expression.parse(expression, ["x"])
	test_expression.execute([1])
	
	if test_expression.has_execute_failed():
		équation_briser()
	elif test_expression.execute([1]) is float or test_expression.execute([1]) is String or test_expression.execute([1]) is int:
		équation_soumis.emit()
		panel_équation.hide()
		print("submit")
	else:
		équation_briser()

func équation_en_expression(nouveau_équation: String):
	
	# Convertis le String en formule ultilisable par Godot
	print(nouveau_équation)
	
	nouveau_équation = nouveau_équation.to_lower()
	nouveau_équation = nouveau_équation.replace(" ", "") # Enlève tout les espaces vide
	nouveau_équation = nouveau_équation.replace("x", "(x)") # Separer les variables des chiffres
	nouveau_équation = nouveau_équation.replace(",", ".") # Pour les équations française
	
	print(nouveau_équation)
	
	for i in nouveau_équation.length() + 1: 
		if i > 0: 
			
			if !opérateurs.has(nouveau_équation.substr(i-1, 1)) and !symboles_avant.has(nouveau_équation.substr(i-1, 1)) and nouveau_équation.substr(i-1, 1) != "(":
				
				if nouveau_équation.substr(i, 1) == "(" or nouveau_équation.substr(i, 3) == "sin" or nouveau_équation.substr(i, 3) == "cos" or nouveau_équation.substr(i, 3) == "tan":
					nouveau_équation = nouveau_équation.insert(i, "*")
	
	print(nouveau_équation)

	while nouveau_équation.contains("²") or nouveau_équation.contains("³"):
		await get_tree().create_timer(0.01).timeout
		
		for i in nouveau_équation.length() + 1:
			
			if nouveau_équation.substr(i, 1) == "²" or nouveau_équation.substr(i, 1) == "³":
				print("power found")
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
		
	for i in nouveau_équation.length() + 1:
		if nouveau_équation.substr(i, 1) == "√":
		
			var clôt: int
			
			if nouveau_équation.substr(i+1, 1) == "(":
				clôt = trouveau_parathèse_correspondante(nouveau_équation, i, -1)
				
			elif chiffres.has(nouveau_équation.substr(i+1, 1)):
				clôt =  trouveau_chiffres_correspondante(nouveau_équation, i, -1)
			
		
			nouveau_équation = nouveau_équation.replace( "√" + nouveau_équation.substr(i+1, ((i+clôt+1) - (i+1))), "sqrt(" + nouveau_équation.substr(i+1, ((i+clôt+1) - (i+1))) + ")" )
	
	for i in nouveau_équation.length() + 1:
		if nouveau_équation.substr(i, 3) == "sin" or nouveau_équation.substr(i, 3) == "cos" or nouveau_équation.substr(i, 3) == "tan":
			print("sin found")
			
			var clôt: int
			
			if nouveau_équation.substr(i+3, 1) == "(":
				clôt = trouveau_parathèse_correspondante(nouveau_équation, i+2, -1)
				
			elif chiffres.has(nouveau_équation.substr(i+3, 1)):
				clôt =  trouveau_chiffres_correspondante(nouveau_équation, i+2, -1)
			
			if nouveau_équation.substr(i+3, ((i+clôt+3) - (i+3))) == "":
				return ""
			
			if nouveau_équation.substr(i, 3) == "sin":
				nouveau_équation = nouveau_équation.replace( "sin" + nouveau_équation.substr(i+3, ((i+clôt+3) - (i+3))), "sin(" + nouveau_équation.substr(i+3, ((i+clôt+3) - (i+3))) + ")" )
			elif nouveau_équation.substr(i, 3) == "cos":
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


func _on_puissance_2_pressed() -> void:
	cano_edit.text += "²"

func _on_puissance_3_pressed() -> void:
	cano_edit.text += "³"

func _on_puissance_4_pressed() -> void:
	cano_edit.text += "√"

func équation_briser():
	message_erreur_canonique.show()
	await get_tree().create_timer(1.0).timeout
	message_erreur_canonique.hide()


#endregion

#region Transformations Second Degrée

@onready var av_edit: SpinBox = $Panel/ÉcriveurTransformations/SecondDegrée/AgrV/AVedit
@onready var th_edit: SpinBox = $Panel/ÉcriveurTransformations/SecondDegrée/TranslH/THedit
@onready var tv_edit: SpinBox = $Panel/ÉcriveurTransformations/SecondDegrée/TranslV/TVedit

func _on_boutton_soumettre_pressed() -> void:
	expression = var_to_str(av_edit.value) + "* pow( (x - " + var_to_str(th_edit.value) + "), 2) + " + var_to_str(tv_edit.value)
	
	print("submit")
	équation_soumis.emit()
	panel_équation.hide()

#endregion

#region Tutoriel

@onready var tutoriel: Panel = $Tutoriel
@onready var image_1: TextureRect = $Tutoriel/Images/Image1
@onready var image_2: TextureRect = $Tutoriel/Images/Image2
@onready var label: Label = $Tutoriel/Label
@onready var boutton_tutoriel: Button = $BouttonTutoriel
@onready var tag_1: Label = $Tutoriel/Images/Image1/Tag1
@onready var tag_2: Label = $Tutoriel/Images/Image2/Tag2

func _on_boutton_fermer_pressed() -> void:
	tutoriel.hide()

func _on_boutton_tutoriel_pressed() -> void:
	tutoriel.visible = !tutoriel.visible

func load_tutoriel(niveau: NiveauResource):
	if niveau.tutoriel_actif:
		boutton_tutoriel.show()
		tutoriel.show()
		label.text = niveau.texte
		
		if niveau.image_1:
			image_1.show()
			image_1.texture = niveau.image_1
			tag_1.text = niveau.tag_1
		if niveau.image_2:
			image_2.show()
			image_2.texture = niveau.image_2
			tag_2.text = niveau.tag_2
		
	else:
		return

#endregion

func _on_boutton_menu_pressed() -> void:
	boutton_menu_pesser.emit()
