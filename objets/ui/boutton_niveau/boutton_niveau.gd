extends Button

@export var niveau_resource: NiveauResource


func _on_pressed() -> void:
	if niveau_resource:
		Singleton.niveau_présent = niveau_resource
		Singleton.scene_viser = "res://objets/niveau/niveau.tscn"
		get_tree().change_scene_to_file("res://objets/ui/écran_téléchargement/écran_téléchargement.tscn")
