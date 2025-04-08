class_name Niveau
extends Node2D

@onready var markeur_1: Marker2D = $Canvas/Markeur1
@onready var markeur_2: Marker2D = $Canvas/Markeur2

var étirage_v: float = 10.0
var étirage_h: float = 10.0

var bonds_v: int = 100
var bonds_h: int = 100

var label_font: FontFile = preload('res://assets/ui/Jellee_1223/TTF/Jellee-Bold.ttf')

func cree_canvas() -> void:
	queue_redraw()


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
			draw_string(label_font, Vector2(markeur_1.position.x - 40, markeur_2.position.y - i), var_to_str(roundi(i / étirage_h)))

func _ready() -> void:
	cree_canvas()
