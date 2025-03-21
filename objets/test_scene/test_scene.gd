extends Node2D

@onready var traceur: Traceur = $Traceur
@onready var timer: Timer = $Timer

var temps: float = 0




func _on_timer_timeout() -> void:
	temps += 0.5
	traceur.position.y = -traceur.calculer_position(temps) + 246.0
	traceur.position.x = temps + 102.0
	print(traceur.position)
	timer.start(0.0001)
