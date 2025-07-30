extends Control

var section = preload("res://menus/score_sheet/section.tscn")

@onready var sections_container = $SectionsContainer
@onready var level_label = $LevelLabel


func _ready():
	position = Vector2(0, 300)


func _process(_delta):
	if Input.is_action_just_pressed("show_score_sheet"):
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
		tween.tween_property(self, "position", Vector2(0,0), 0.3).from_current()
	elif Input.is_action_just_released("show_score_sheet"):
		var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
		tween.tween_property(self, "position", Vector2(0, 300), 0.3).from_current()


func set_sections(amount: int, pars: Array[int]):
	var current_amount = sections_container.get_child_count()
	if current_amount < amount:
		for i in range(current_amount, amount):
			add_section(i+1, pars[i])
	elif current_amount > amount:
		for i in range(amount, current_amount):
			delete_section()


func set_level_label(text):
	level_label.text = text


func add_section(hole: int, par: int):
	var section_instance = section.instantiate()
	sections_container.add_child(section_instance)
	section_instance.set_hole(hole)
	section_instance.set_par(par)


func delete_section():
	var section_child = sections_container.get_child(-1)
	#sections_container.remove_child(section) MAYBE ADD THIS BACK IDK
	section_child.queue_free()


func change_section_score(section_index: int, amount: int):
	var section_node = sections_container.get_child(section_index)
	section_node.set_score(amount)
