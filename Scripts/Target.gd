extends Node2D

var time = 4
var x
var y
signal timeout

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("TimeLabel").clear()
	get_node("TimeLabel").append_text(str(time))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func countdown():
	time -= 1
	get_node("TimeLabel").clear()
	get_node("TimeLabel").append_text(str(time))
	if (time == 0):
		timeout.emit()
