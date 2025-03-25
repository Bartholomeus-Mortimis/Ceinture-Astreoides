extends Control
class_name Hud

signal équation_soumis

@export var équation: String = "x"
@export var expression: String = "x"

func _on_line_edit_text_submitted(new_text: String) -> void:
	équation = new_text
	équation_soumis.emit()
	
