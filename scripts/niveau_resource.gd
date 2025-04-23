extends Resource
class_name NiveauResource

@export_group("Générale")

@export var canonique: bool = true
@export var second_degrée: bool
@export var prochaine_niveau: NiveauResource
@export var niveau_page: int = 0
@export var niveau_nombre: int = 0


@export_group("Graphique")

@export var étirage_h: float = 1.0
@export var étirage_v: float = 1.0

@export var origine_h: int = 0
@export var origine_v: int = 0


@export_group("Obstacles")

@export var astreoides: Array[Vector2]
@export var bombes: Array[Vector2]


@export_group("Tutoriel")

@export var tutoriel_actif: bool = false
@export var texte: String = ""
@export var image_1: Texture
@export var image_2: Texture
@export var tag_1: String = ""
@export var tag_2: String = ""
