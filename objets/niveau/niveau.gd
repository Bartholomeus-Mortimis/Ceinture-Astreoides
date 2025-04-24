class_name Niveau
extends Node2D

@onready var markeur_1: Marker2D = $Canvas/Markeur1
@onready var markeur_2: Marker2D = $Canvas/Markeur2
@onready var hud: Hud = $UI/Hud
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var temps_timer: Timer = $TempsTimer
@onready var boutton_prochaine: Control = $UI/WinScreen/BouttonProchaine

var étirage_v: float = 1.0
var étirage_h: float = 10

var origine_v: int = 0
var origine_h: int = 0

var bonds_v: int = 100
var bonds_h: int = 100

var label_font: FontFile = preload('res://assets/ui/Jellee_1223/TTF/Jellee-Bold.ttf')

var points: Array = []

#region Processus

func _ready() -> void:
	queue_redraw()
	load_niveau(Singleton.niveau_présent)
	hud.load_tutoriel(Singleton.niveau_présent)
	
	temps_bonds = 2.5 / étirage_h
	temps_timer.start()
	
	animation_player.play_backwards("transition_niveau")
	await animation_player.animation_finished
	animation_player.play("hover")
	

func _process(delta: float) -> void:
	jouer_traceurs()

func _draw() -> void:
	draw_line( Vector2(markeur_1.position.x, markeur_1.position.y), Vector2(markeur_1.position.x, markeur_2.position.y), Color(255, 255, 255), 3.0)
	draw_line( Vector2(markeur_2.position.x, markeur_2.position.y), Vector2(markeur_1.position.x, markeur_2.position.y), Color(255, 255, 255), 3.0)
	
	for i in range(markeur_2.position.x - markeur_1.position.x):
		if i % bonds_h == 0:
			draw_line(Vector2(markeur_1.position.x + i, markeur_2.position.y), Vector2(markeur_1.position.x + i, markeur_2.position.y + 10), Color(255, 255, 255), 3.0)
			draw_string(label_font, Vector2(markeur_1.position.x + i, markeur_2.position.y + 30), var_to_str(roundi(i / étirage_h) + origine_h), 0, -1, 18)
	
	for i in range(markeur_2.position.y - markeur_1.position.y):
		if i % bonds_v == 0:
			draw_line(Vector2(markeur_1.position.x, markeur_2.position.y - i), Vector2(markeur_1.position.x - 10, markeur_2.position.y - i), Color(255, 255, 255), 3.0)
			draw_string(label_font, Vector2(markeur_1.position.x - 80, markeur_2.position.y - i), var_to_str(roundi(i / étirage_v) + origine_v), HORIZONTAL_ALIGNMENT_RIGHT, 70, 18)
	
	for t: Traceur in get_tree().get_nodes_in_group("traceurs"): # Dessine une ligne entre chaque point, créeant la courbe visuel.
		var valeur_pré: Vector2
		for p in t.points:
			if valeur_pré:
				draw_line(p, valeur_pré, Color("#29ADFF"), 2.0, true)
			valeur_pré = p

#endregion

#region Traceurs

var traceur_path: PackedScene = preload("res://objets/tracer/traceur.tscn")
var traceur_existe: bool = false

var temps: float = 0.0
var temps_bonds: float = 1

func jouer_traceurs():
	for traceur in get_tree().get_nodes_in_group("traceurs"):
		#print( Vector2( (traceur.position.x - markeur_1.position.x), traceur.position.y - markeur_2.position.y) )
		
		traceur.position.y = -((traceur.calculer_position((traceur.temps_passer + Singleton.niveau_présent.origine_h)) - Singleton.niveau_présent.origine_v)* étirage_v) + markeur_2.position.y
		traceur.position.x = ( (traceur.temps_passer) * étirage_h) + markeur_1.position.x 
		
		# Vérifier que le traceur se situe dans les extremitées du graphique
		if traceur.position.x <= markeur_2.position.x and traceur.position.x >= markeur_1.position.x and traceur.position.y <= markeur_1.position.y and traceur.position.y >= markeur_2.position.y:
			traceur.visible = false
		else:
			traceur.visible = true
	

func crée_traceur_de_équation(équation: String):

	var nouveau_traceur: Traceur = traceur_path.instantiate()
	
	nouveau_traceur.équation = équation
	nouveau_traceur.position = Vector2(markeur_1.position.x, markeur_2.position.y)
	
	get_tree().root.add_child(nouveau_traceur)

func _on_temps_timer_timeout() -> void:
	temps += temps_bonds
	temps_timer.start(0.01)
	
	for t: Traceur in get_tree().get_nodes_in_group("traceurs"):
		
		if t.actif:
			t.temps_passer += temps_bonds
			t.points.append(t.global_position) # Ajouter un point pour tracer la courbe
		
		if t.position.x >= 1000 or t.position.y < -50:
			if !résultat_vérifier and t.actif:
				résultat_vérifier = true
				vérifier_résultat()
			
		#if t.points.size() > (500):
		#	t.points.pop_front()
	
	queue_redraw()

#endregion

#region Niveau Resources

var astreoide_path: PackedScene = preload("res://objets/astreoid/astreoid.tscn")
var bombe_path: PackedScene = preload("res://objets/bombe/bombe.tscn")

func load_niveau(niveau: NiveauResource):
	
	# Une resource est ultiliser pour crée les niveaux.
	
	hud.niveau_id.text = var_to_str(niveau.niveau_page) + " - "  + var_to_str(niveau.niveau_nombre)
	
	étirage_h = niveau.étirage_h
	étirage_v = niveau.étirage_v
	origine_h = niveau.origine_h
	origine_v = niveau.origine_v
	
	if niveau.prochaine_niveau:
		boutton_prochaine.show()
	
	if niveau.canonique:
		hud.écriveur_canonique.show()
	else:
		
		hud.écriveur_transformations.show()
		
		if niveau.second_degrée:
			hud.second_degrée.show()
	
	queue_redraw()
	
	for a: Vector2 in niveau.astreoides:
		
		var nouveau_astreoide: Astreoide = astreoide_path.instantiate()
		
		nouveau_astreoide.position_relatif = a
		nouveau_astreoide.position = Vector2(
			((a.x - niveau.origine_h) * étirage_h) + markeur_1.position.x,
			-((a.y - niveau.origine_v) * étirage_v) + markeur_2.position.y
		)
		
		get_tree().root.add_child.call_deferred(nouveau_astreoide)
	
	for b: Vector2 in niveau.bombes:
		
		var nouveau_bombe: Bombe = bombe_path.instantiate()
		
		nouveau_bombe.position_relatif = b
		nouveau_bombe.position = Vector2(
			(b.x - niveau.origine_h * étirage_h) + markeur_1.position.x ,
			-(b.y - niveau.origine_v * étirage_v) + markeur_2.position.y
		)
		
		nouveau_bombe.bombe_exploser.connect(bombe_exploser)
		
		get_tree().root.add_child.call_deferred(nouveau_bombe)

func _on_hud_équation_soumis() -> void:
	if !traceur_existe:
		crée_traceur_de_équation(hud.expression)
		traceur_existe = true


#endregion

#region Réussite/Faillite

var résultat_vérifier: bool = false # Assure que l'animation de faillite/réussite n'est pas jouer 2 fois


func bombe_exploser():
	résultat_vérifier = true
	animation_player.play("AnimationFaillite")

func _on_boutton_recommence_pressed() -> void:
	Singleton.scene_viser = "res://objets/niveau/niveau.tscn"
	fermer_niveau()

func vérifier_résultat():
	if get_tree().get_node_count_in_group("astreoides") > 0:
		animation_player.play("AnimationFaillite")
	else:
		animation_player.play("AnimationReussite")

func fermer_niveau():
	
	animation_player.play("transition_niveau")
	await animation_player.animation_finished
	
	while get_tree().get_node_count_in_group("obstacles") > 0:
		await get_tree().create_timer(0.01).timeout
		var obstacle_a_détruire: Node2D = get_tree().get_first_node_in_group("obstacles")
		if obstacle_a_détruire:
			obstacle_a_détruire.queue_free()
	
	for t: Traceur in get_tree().get_nodes_in_group("traceurs"):  # Désactiver les traceur dans le scene
		t.actif = false
		t.points.clear()
		t.position.x = -100.0
		t.équation = ""
	
	queue_redraw()
	
	
	get_tree().change_scene_to_file("res://objets/ui/écran_téléchargement/écran_téléchargement.tscn")

func _on_boutton_prochaine_pressed() -> void:
	Singleton.niveau_présent = Singleton.niveau_présent.prochaine_niveau
	Singleton.scene_viser = "res://objets/niveau/niveau.tscn"
	fermer_niveau()

func _on_boutton_menu_pressed() -> void:
	Singleton.scene_viser = "res://objets/ui/menu/menu.tscn"
	fermer_niveau()

func _on_hud_boutton_menu_pesser() -> void:
	Singleton.scene_viser = "res://objets/ui/menu/menu.tscn"
	fermer_niveau()

#endregion
