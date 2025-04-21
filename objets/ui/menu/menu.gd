extends Control
class_name Menu

@onready var astreoides: Control = $ArrièrePlan/Astreoides

func _process(delta: float) -> void:
	for a: TextureRect in astreoides.get_children():
		if a.position.x < 900:
			a.position.x += randi_range(8, 12) * delta
		else:
			a.position.x = -100


#region Selection de Niveaux

@onready var niveaux: Panel = $Niveaux

func _on_boutton_jouer_pressed() -> void:
	niveaux.show()
