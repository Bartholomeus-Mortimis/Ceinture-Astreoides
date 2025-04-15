extends Control
class_name Menu

@onready var astreoides: Control = $ArrièrePlan/Astreoides

func _on_boutton_jouer_pressed() -> void:
	Singleton.niveau_présent = load("res://resources/test_level.tres")
	Singleton.scene_viser = "res://objets/niveau/niveau.tscn"
	
	get_tree().change_scene_to_file("res://objets/ui/écran_téléchargement/écran_téléchargement.tscn")

func _process(delta: float) -> void:
	for a: TextureRect in astreoides.get_children():
		if a.position.x < 900:
			a.position.x += randi_range(8, 12) * delta
		else:
			a.position.x = -100
