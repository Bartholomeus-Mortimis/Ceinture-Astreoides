extends Node2D
class_name Bombe

signal bombe_exploser

@export var position_relatif: Vector2 = Vector2(0,0)

@onready var label: Label = $SourisHover/Label

func _on_souris_hover_mouse_entered() -> void:
	label.text = "(" + var_to_str(snappedf(position_relatif.x, Singleton.niveau_présent.point_arrondissement)) + ", " + var_to_str(snappedf(position_relatif.y, Singleton.niveau_présent.point_arrondissement)) + ")"
	label.show()

func _on_souris_hover_mouse_exited() -> void:
	label.hide()

func _on_area_2d_area_entered(area: Area2D) -> void:
	bombe_exploser.emit()
	queue_free()
