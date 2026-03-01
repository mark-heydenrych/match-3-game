class_name LevelSelect
extends Node2D

@export var active = false

# All possible rooms
var left_rooms = ["Shop", "Rest Area"]
var right_rooms = ["Challenge"]
# The rooms we can currently navigate to
var rooms = ["Puzzle"]
# The index of when we should get a special room
var special_index: int
# Which level we're on
var current_index: int
# The debuffs for the next challenge level
var challenge_debuffs: String
# The possible debuffs
var possible_debuffs = ["DR", "DO", "DY", "DG", "DB", "DP", "H5", "B5"]

# Called when the node enters the scene tree for the first time.
func _ready():
	current_index = 0
	special_index = randi_range(1, 2)
	pass # Replace with function body.

func _to_string():
	var values = [special_index, current_index]
	values.append_array(rooms)
	return JSON.stringify(values)

func setup_from_array(_rooms):
	special_index = int(_rooms[0])
	current_index = int(_rooms[1])
	rooms = _rooms.slice(2, 4)
	get_node("Left").text = rooms[0]
	get_node("Left").pressed.connect(choose_level.bind(rooms[0]))
	if (rooms.size() > 1 && get_node("/root/BaseScene/Globals").sideboard_unlocked):
		var right: Button = Button.new()
		right.name = "Right"
		right.position = Vector2(300, 360)
		add_child(right)
		get_node("Right").text = rooms[1]
		get_node("Right").pressed.connect(choose_level.bind(rooms[1]))
		get_node("Right").disabled = false
		get_node("Right").visible = true
	else:
		if (get_node("Right") != null):
			get_node("Right").queue_free()

func setup():
	#print_tree_pretty()
	#if (get_node("Right") != null):
	#	get_node("Right").queue_free()
	# An ugly solution, but it works
	#if (get_node("Right2") != null):
	#	get_node("Right2").queue_free()
	print("Current: " + str(current_index) + " Special: " + str(special_index))
	get_node("Middle").text = "Puzzle"
	get_node("Middle").pressed.connect(choose_level.bind("Puzzle"))
	if (get_node("/root/BaseScene/Globals").sideboard_unlocked):
		print("Adding special rooms")
		challenge_debuffs = ""
		var num_debuffs = (current_index / 3) + 1
		for i in num_debuffs:
			challenge_debuffs += possible_debuffs.pick_random()
		var right = get_node("Right")
		right.text = right_rooms.pick_random()
		right.pressed.disconnect(choose_level)
		right.pressed.connect(choose_level.bind(right.text))
		if (current_index % 3 == 2):
			right.disabled = false
			right.visible = true
			get_node("Radar").visible = true
			if (get_node("/root/BaseScene/Globals").radar_unlocked):
				var adverse = ""
				if (challenge_debuffs.contains("H")):
					adverse += "\nVisual Interference Detected"
				if (challenge_debuffs.contains("B")):
					adverse += "\nUnmineable Areas Detected"
				if (challenge_debuffs.contains("D")):
					if (challenge_debuffs.contains("R")):
						adverse += "\nFake Red Mundanium Detected"
					if (challenge_debuffs.contains("O")):
						adverse += "\nFake Orange Mundanium Detected"
					if (challenge_debuffs.contains("Y")):
						adverse += "\nFake Yellow Mundanium Detected"
					if (challenge_debuffs.contains("G")):
						adverse += "\nFake Green Mundanium Detected"
					if (challenge_debuffs.contains("B")):
						adverse += "\nFake Blue Mundanium Detected"
					if (challenge_debuffs.contains("P")):
						adverse += "\nFake Purple Mundanium Detected"
				get_node("Radar").text = "[center]Rare Mundanium Detected" + adverse + "[/center]"
			else:
				get_node("Radar").text = "[center]Rare Mundanium Detected\nAdverse Conditions Unknown[/center]"
		else:
			right.disabled = true
			right.visible = false
			get_node("Radar").visible = false
		var left = get_node("Left")
		left.text = left_rooms.pick_random()
		left.pressed.disconnect(choose_level)
		left.pressed.connect(choose_level.bind(left.text))
		if (current_index % 3 > 0):
			left.disabled = false
			left.visible = true
		else:
			left.disabled = true
			left.visible = false
	else:
		get_node("Left").disabled = true
		get_node("Left").visible = false
		get_node("Right").disabled = true
		get_node("Right").visible = false
	current_index = current_index + 1

func choose_level(level):
	if (active):
		get_node("/root/BaseScene/AudioManager").play_click()
		print(level)
		get_parent().navigate(level, challenge_debuffs)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
