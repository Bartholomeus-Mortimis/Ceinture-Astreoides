class_name Niveau
extends Node2D

@onready var markeur_1: Marker2D = $Canvas/Markeur1
@onready var markeur_2: Marker2D = $Canvas/Markeur2

var étirage_v: float = 1.0
var étirage_h: float = 1.0

var bonds_v: float = 1.0
var bonds_h: float = 1.0

func cree_canvas() -> void:
	queue_redraw()

func _draw() -> void:
	draw_line( Vector2(markeur_1.position.x, markeur_1.position.y), Vector2(markeur_1.position.x, markeur_2.position.y), Color(255, 255, 255), 3.0)
	draw_line( Vector2(markeur_2.position.x, markeur_2.position.y), Vector2(markeur_1.position.x, markeur_2.position.y), Color(255, 255, 255), 3.0)

func _ready() -> void:
	cree_canvas()
