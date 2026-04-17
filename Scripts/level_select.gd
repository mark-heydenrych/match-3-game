class_name LevelSelect
extends Node2D

@export var active = false

# All possible rooms
var left_rooms = ["Shop", "Rest Area"]
var left_room = ""
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
var possible_debuffs = ["DR", "DO", "DY", "DG", "DB", "DP", "H5", "I5"]

# Called when the node enters the scene tree for the first time.
func _ready():
	current_index = 0
	special_index = randi_range(1, 2)
	pass # Replace with function body.

func _to_string():
	var values = [special_index, current_index, challenge_debuffs, left_room]
	return JSON.stringify(values)

func setup_from_array(_rooms):
	special_index = int(_rooms[0])
	current_index = int(_rooms[1])
	print("Level select with index " + str(current_index))
	challenge_debuffs = _rooms[2]
	left_room = _rooms[3]
	# get_node("Grid/Middle").text = "Puzzle"
	get_node("Grid/Middle").pressed.connect(choose_level.bind("Puzzle"))
	if (get_node("/root/BaseScene/Globals").sideboard_unlocked):
		print("Adding special rooms")
		var right = get_node("Grid/Right")
		var right_room = right_rooms.pick_random()
		# right.text = right_rooms.pick_random()
		right.pressed.disconnect(choose_level)
		right.pressed.connect(choose_level.bind(right_room))
		if (current_index % 3 == 2):
			right.disabled = false
			right.visible = true
			set_radar()
		else:
			right.disabled = true
			right.visible = false
			get_node("Grid/Radar").visible = false
		var left = get_node("Grid/Left")
		# left.text = left_room
		get_node("Grid/LeftLabel").text = "[center][color=3DDA6B]" + left_room + "[/color][center]"
		left.pressed.disconnect(choose_level)
		left.pressed.connect(choose_level.bind(right_room))
		if (current_index % 3 > 0):
			left.disabled = false
			left.visible = true
			get_node("Grid/LeftLabel").visible = true
		else:
			left.disabled = true
			left.visible = false
			get_node("Grid/LeftLabel").visible = false
	else:
		get_node("Grid/Left").disabled = true
		get_node("Grid/Left").visible = false
		get_node("Grid/LeftLabel").visible = false
		get_node("Grid/Right").disabled = true
		get_node("Grid/Right").visible = false
		get_node("Grid/Radar").visible = false
	# Set up the sub controls which keep grid spacing correct
	get_node("Grid/LeftSub").visible = !get_node("Grid/Left").visible
	get_node("Grid/RightSub").visible = !get_node("Grid/Right").visible
	get_node("Grid/LeftLabelSub").visible = !get_node("Grid/LeftLabel").visible

func setup():
	get_node("ScanningLine").position = Vector2(0,-100)
	get_node("ScanningPane").position = Vector2(0,-92)
	get_node("ScanningLabel").visible_characters = 8
	get_node("ScanningLabel").visible = true
	# Set up the buttons and labels
	get_node("Grid/Left").pivot_offset = Vector2(64, 64)
	get_node("Grid/Middle").pivot_offset = Vector2(64, 64)
	get_node("Grid/Right").pivot_offset = Vector2(64, 64)
	print("Current: " + str(current_index) + " Special: " + str(special_index))
	get_node("Grid/Middle").pressed.connect(choose_level.bind("Puzzle"))
	if (get_node("/root/BaseScene/Globals").sideboard_unlocked):
		print("Adding special rooms")
		challenge_debuffs = ""
		var num_debuffs = (current_index / 3) + 1
		for i in num_debuffs:
			challenge_debuffs += possible_debuffs.pick_random()
		var right = get_node("Grid/Right")
		var right_room = right_rooms.pick_random()
		# right.text = right_rooms.pick_random()
		right.pressed.disconnect(choose_level)
		right.pressed.connect(choose_level.bind(right_room))
		if (current_index % 3 == 2):
			right.disabled = false
			right.visible = true
			set_radar()
		else:
			right.disabled = true
			right.visible = false
			get_node("Grid/Radar").visible = false
		var left = get_node("Grid/Left")
		left_room = left_rooms.pick_random()
		# left.text = left_room
		get_node("Grid/LeftLabel").text = "[center][color=3DDA6B]" + left_room + "[/color][center]"
		left.pressed.disconnect(choose_level)
		left.pressed.connect(choose_level.bind(left_room))
		if (current_index % 3 > 0):
			left.disabled = false
			left.visible = true
			get_node("Grid/LeftLabel").visible = true
		else:
			left.disabled = true
			left.visible = false
			get_node("Grid/LeftLabel").visible = false
	else:
		get_node("Grid/Left").disabled = true
		get_node("Grid/Left").visible = false
		get_node("Grid/LeftLabel").visible = false
		get_node("Grid/Right").disabled = true
		get_node("Grid/Right").visible = false
		get_node("Grid/Radar").visible = false
	# Set up the sub controls which keep grid spacing correct
	get_node("Grid/LeftSub").visible = !get_node("Grid/Left").visible
	get_node("Grid/RightSub").visible = !get_node("Grid/Right").visible
	get_node("Grid/LeftLabelSub").visible = !get_node("Grid/LeftLabel").visible
	# Do the scanning animation
	var scanline_tween: Tween = create_tween()
	scanline_tween.tween_property(get_node("ScanningLine"),"position",Vector2(0, 800), 7.5).set_trans(Tween.TRANS_LINEAR)
	scanline_tween.play()
	var scanpane_tween: Tween = create_tween()
	scanpane_tween.tween_property(get_node("ScanningPane"),"position",Vector2(0, 808), 7.5).set_trans(Tween.TRANS_LINEAR)
	scanpane_tween.play()
	var scanlabel_tween: Tween = create_tween()
	scanlabel_tween.tween_property(get_node("ScanningLabel"),"visible_characters",11, 7).set_trans(Tween.TRANS_LINEAR)
	scanlabel_tween.play()
	await get_tree().create_timer(7.5).timeout
	get_node("ScanningLabel").visible = false

func set_radar():
	get_node("Grid/Radar").visible = true
	if (get_node("/root/BaseScene/Globals").radar_unlocked):
		var adverse = ""
		if (challenge_debuffs.contains("H")):
			adverse += "\nVisual Interference Detected"
		if (challenge_debuffs.contains("I")):
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
		get_node("Grid/Radar").text = "[center][color=3DDA6B]Rare Mundanium Detected" + adverse + "[/color][/center]"
	else:
		get_node("Grid/Radar").text = "[center][color=3DDA6B]Rare Mundanium Detected\nAdverse Conditions Unknown[/color][/center]"

func choose_level(level):
	if (active):
		current_index = current_index + 1
		get_node("/root/BaseScene/AudioManager").play_click()
		print(level)
		get_parent().navigate(level, challenge_debuffs)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_node("Grid/Middle").rotation += 1 * delta
	get_node("Grid/Left").rotation += -0.75 * delta
	get_node("Grid/Right").rotation += -0.5 * delta
	pass
