extends Node2D

@onready var traceur: Traceur = $Traceur
@onready var timer: Timer = $Timer
@onready var hud: Hud = $Hud

var temps: float = 0

func _on_timer_timeout() -> void:
	temps += 5.0
	traceur.position.y = -traceur.calculer_position(temps) + 300.0
	traceur.position.x = temps + 102.0
	print(traceur.position.y)
	timer.start(0.000001)


func _on_hud_équation_soumis() -> void:
	traceur.équation = hud.équation
	timer.start(1.0)
