extends Helper

var lines = [
	"Need to tidy things up NEED TO TIDY THINGS UP",
	"Spick and span, everything tidied away.",
	"A place for everything, and everything in its place.",
	"Just move this over here...",
	"I'll just scooch this over here for you, no need to thank me."
]

var active_lines = []
var numbers = range(5)

# Called when the node enters the scene tree for the first time.
func _ready():
	numbers.shuffle()
	active_lines = lines.duplicate()
	active_lines.shuffle()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func act():
	if numbers[0] == 0:
		clean()
		var line = active_lines.pop_front()
		get_node("OutputLabel").clear()
		get_node("OutputLabel").push_color(Color.WHITE)
		get_node("OutputLabel").push_outline_color(Color.BLACK)
		get_node("OutputLabel").push_outline_size(4)
		get_node("OutputLabel").push_font_size(24)
		get_node("OutputLabel").append_text(line)
		get_node("OutputLabel").visible_characters = 0
		if (active_lines.is_empty()):
			active_lines = lines.duplicate()
			active_lines.shuffle()
	numbers.pop_front()
	if numbers.is_empty():
		numbers = range(0, 5)
		numbers.shuffle()
	
func clean():
	# Try to make a single match anywhere on the board
	var original: Vector2
	var target: Vector2
	var good_to_go: bool = false
	while (!good_to_go):
		# 1. Choose a random location which has neighbours on all sides
		var x = randi_range(1, 6)
		var y = randi_range(1, 7)
		original = Vector2(x, y)
		# 2. Get all the neighbours of that location, and keep track of the colour of the original
		var orig_colour = get_node("/root/BaseScene/gameboard/Grid").all_pieces[x][y].colour
		if (orig_colour == "Stone" || orig_colour == "XStone" || orig_colour == "Virus" || orig_colour == "XVirus" || orig_colour == "rotate" || orig_colour == "Xrotate"):
			continue
		var neighbours = get_node("/root/BaseScene/gameboard/Grid").get_neighbours(x, y)
		# 3. If any neighbour has the same colour, return to step 1
		var matching_colour = false
		for n in neighbours:
			x = n.x
			y = n.y
			if (get_node("/root/BaseScene/gameboard/Grid").all_pieces[x][y].matches(orig_colour)):
				matching_colour = true
				break
		if (matching_colour):
			continue
		# 4. For each neighbour, look for a neighbour of that which is the same colour as original
		var next_neighbours = []
		for n in neighbours:
			var n_neighbours = get_node("/root/BaseScene/gameboard/Grid").get_neighbours(n.x, n.y)
			for nn in n_neighbours:
				x = nn.x
				y = nn.y
				if (get_node("/root/BaseScene/gameboard/Grid").all_pieces[x][y].matches(orig_colour)):
					next_neighbours.append(n)
					break
		# 5. If there is no such neighbour, return to step 1
		if (next_neighbours.size() == 0):
			continue
		else:
			good_to_go = true
			target = next_neighbours.pick_random()
			var target_colour = get_node("/root/BaseScene/gameboard/Grid").all_pieces[target.x][target.y].colour
			if (target_colour == "Stone" || target_colour == "XStone" || target_colour == "Virus" || target_colour == "XVirus" || target_colour == "rotate" || target_colour == "Xrotate"):
				good_to_go = false
				continue
	# 6. Swap the original location with the chosen neighbour
	get_node("/root/BaseScene/gameboard/Grid").move_pieces(original, target)
