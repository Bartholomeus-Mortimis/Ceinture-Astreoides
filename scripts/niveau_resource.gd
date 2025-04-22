extends Resource
class_name NiveauResource

@export_group("Générale")

@export var canonique: bool = true
@export var second_degrée: bool

@export_group("Graphique")

@export var étirage_h: float = 1.0
@export var étirage_v: float = 1.0

@export var origine_h: int = 0
@export var origine_v: int = 0


@export_group("Obstacles")

@export var astreoides: Array[Vector2]
@export var bombes: Array[Vector2]
