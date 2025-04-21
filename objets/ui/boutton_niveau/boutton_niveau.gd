extends Button

@export var niveau_path: String


func _on_pressed() -> void:
	if niveau_path:
		Singleton.niveau_présent = load(niveau_path)
		Singleton.scene_viser = "res://objets/niveau/niveau.tscn"
		get_tree().change_scene_to_file("res://objets/ui/écran_téléchargement/écran_téléchargement.tscn")
