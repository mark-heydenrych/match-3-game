extends Node2D
class_name Helper

var text_lines = []
var time_delta = 0
var timespan = 0.05

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (get_node("OutputLabel").visible_characters == -1):
		return
	time_delta += delta
	if (time_delta >= timespan):
		time_delta -= timespan
		get_node("OutputLabel").visible_characters = get_node("OutputLabel").visible_characters + 1
		if (get_node("OutputLabel").visible_characters == len(get_node("OutputLabel").text)):
			get_node("OutputLabel").visible_characters = -1
	pass


func act():
	pass
