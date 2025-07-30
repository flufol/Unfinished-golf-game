extends TextureRect

@onready var hole_label = %HoleLabel
@onready var par_label = %ParLabel
@onready var score_label = %ScoreLabel


func set_hole(value: int):
	hole_label.text = str(value)


func set_par(value: int):
	par_label.text = str(value)


func set_score(value: int):
	score_label.text = str(value)
