class_name Niveau
extends Node2D

@onready var markeur_1: Marker2D = $Canvas/Markeur1
@onready var markeur_2: Marker2D = $Canvas/Markeur2
@onready var hud: Hud = $UI/Hud

var étirage_v: float = 1.0
var étirage_h: float = 10


var bonds_v: int = 100
var bonds_h: int = 100

var label_font: FontFile = preload('res://assets/ui/Jellee_1223/TTF/Jellee-Bold.ttf')

var points: Array = []

func _draw() -> void:
	draw_line( Vector2(markeur_1.position.x, markeur_1.position.y), Vector2(markeur_1.position.x, markeur_2.position.y), Color(255, 255, 255), 3.0)
	draw_line( Vector2(markeur_2.position.x, markeur_2.position.y), Vector2(markeur_1.position.x, markeur_2.position.y), Color(255, 255, 255), 3.0)
	
	for i in range(markeur_2.position.x - markeur_1.position.x):
		if i % bonds_h == 0:
			draw_line(Vector2(markeur_1.position.x + i, markeur_2.position.y), Vector2(markeur_1.position.x + i, markeur_2.position.y + 10), Color(255, 255, 255), 3.0)
			draw_string(label_font, Vector2(markeur_1.position.x + i, markeur_2.position.y + 30), var_to_str(roundi(i / étirage_h)) )
	
	for i in range(markeur_2.position.y - markeur_1.position.y):
		if i % bonds_v == 0:
			draw_line(Vector2(markeur_1.position.x, markeur_2.position.y - i), Vector2(markeur_1.position.x - 10, markeur_2.position.y - i), Color(255, 255, 255), 3.0)
			draw_string(label_font, Vector2(markeur_1.position.x - 45, markeur_2.position.y - i), var_to_str(roundi(i / étirage_v)))
	
	for t: Traceur in get_tree().get_nodes_in_group("traceurs"): # Dessine une ligne entre chaque point, créeant la courbe visuel.
		var valeur_pré: Vector2
		for p in t.points:
			if valeur_pré:
				draw_line(p, valeur_pré, Color("#29ADFF"), 2.0, true)
			valeur_pré = p


func _ready() -> void:
	queue_redraw()
	temps_bonds = 2.5 / étirage_h

func _process(delta: float) -> void:
	jouer_traceurs()

var traceur_path: PackedScene = preload("res://objets/tracer/traceur.tscn")
var traceur_existe: bool = false

var temps: float = 0.0
var temps_bonds: float = 1

func jouer_traceurs():
	for traceur in get_tree().get_nodes_in_group("traceurs"):
		print( Vector2( (traceur.position.x - markeur_1.position.x), traceur.position.y - markeur_2.position.y) )
		
		traceur.position.y = -(traceur.calculer_position((traceur.temps_passer)) * étirage_v) + markeur_2.position.y
		traceur.position.x = ( (traceur.temps_passer) * étirage_h) + markeur_1.position.x 
		
		# Vérifier que le traceur se situe dans les extremitées du graphique
		if traceur.position.x <= markeur_2.position.x and traceur.position.x >= markeur_1.position.x and traceur.position.y <= markeur_1.position.y and traceur.position.y >= markeur_2.position.y:
			traceur.visible = false
		else:
			traceur.visible = true
	

func crée_traceur_de_équation(équation: String):
	
	print("received")
	var nouveau_traceur: Traceur = traceur_path.instantiate()
	
	nouveau_traceur.équation = équation
	nouveau_traceur.position = Vector2(markeur_1.position.x, markeur_2.position.y)
	#nouveau_traceur.visible = false
	
	get_tree().root.add_child(nouveau_traceur)


func _on_hud_équation_soumis() -> void:
	if !traceur_existe:
		crée_traceur_de_équation(hud.expression)
		traceur_existe = true


@onready var temps_timer: Timer = $TempsTimer


func _on_temps_timer_timeout() -> void:
	temps += temps_bonds
	temps_timer.start(0.01)
	
	for t: Traceur in get_tree().get_nodes_in_group("traceurs"):
		t.temps_passer += temps_bonds
		t.points.append(t.global_position) # Ajouter un point pour tracer la courbe
		#if t.points.size() > (500):
		#	t.points.pop_front()
	
	queue_redraw()
