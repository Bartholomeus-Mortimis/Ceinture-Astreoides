extends Control
class_name Menu

@onready var astreoides: Control = $ArrièrePlan/Astreoides

func _process(delta: float) -> void:
	for a: TextureRect in astreoides.get_children():
		if a.position.x < 900:
			a.position.x += randi_range(8, 12) * delta
		else:
			a.position.x = -100


func _on_boutton_quitter_pressed() -> void:
	get_tree().quit()

func _on_boutton_fermer_pressed() -> void:
	niveaux.hide()
	paramètres.hide()

#region Selection de Niveaux

@onready var niveaux: Panel = $Niveaux
@onready var tab_container: TabContainer = $Niveaux/TabContainer
@onready var boutton_gauche: Button = $Niveaux/BouttonGauche
@onready var boutton_droite: Button = $Niveaux/BouttonDroite

func _on_boutton_jouer_pressed() -> void:
	niveaux.show()

func _on_boutton_droite_pressed() -> void:
	tab_container.current_tab += 1
	if tab_container.current_tab == 2:
		boutton_droite.hide()
	boutton_gauche.show()

func _on_boutton_gauche_pressed() -> void:
	tab_container.current_tab -= 1
	if tab_container.current_tab == 0:
		boutton_gauche.hide()
	boutton_droite.show()

#endregion

#region Paramètres

@onready var paramètres: Panel = $Paramètres

func _on_boutton_paramètres_pressed() -> void:
	paramètres.show()

#endregion
