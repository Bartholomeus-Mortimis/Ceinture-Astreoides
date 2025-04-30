extends Node2D
class_name Astreoide

@export var position_relatif: Vector2 = Vector2(0,0)
@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var label: Label = $SourisHover/Label

var sprite_paths: Array[String] = ["res://assets/sprites/astreoid1.png", "res://assets/sprites/astreoid2.png", "res://assets/sprites/astreoid3.png"]
func _ready() -> void:
	sprite_2d.texture = load(sprite_paths.pick_random())
	

func _on_souris_hover_mouse_entered() -> void:
	label.text = "(" + var_to_str(snappedf(position_relatif.x, Singleton.niveau_présent.point_arrondissement)) + ", " + var_to_str(snappedf(position_relatif.y, Singleton.niveau_présent.point_arrondissement)) + ")"
	label.show()

func _on_souris_hover_mouse_exited() -> void:
	label.hide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	queue_free()
