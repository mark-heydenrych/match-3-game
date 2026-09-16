extends Node2D

var costs = []
var durations = []
var effects = []
var buttons = ["Red", "Orange", "Yellow", "Green", "Blue", "Purple"]

# Called when the node enters the scene tree for the first time.
func _ready():
	var fragments = get_parent().chip_fragments
	for frag in fragments:
		if frag[0] == 'COST':
			costs.append(frag)
			get_node("GridContainer/CostSelector").add_item(str(frag[1]))
		if frag[0] == 'EFFECT':
			effects.append(frag)
			get_node("GridContainer/EffectSelector").add_item(frag[1])
		if frag[0] == 'DURATION':
			durations.append(frag)
			get_node("GridContainer/DurationSelector").add_item(str(frag[1]))
	for colour in buttons:
		get_node("GridContainer/ColourSelector").add_item(colour)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_fuse_button_pressed():
	var cost_index = get_node("GridContainer/CostSelector").get_selected_id()
	var effect_index = get_node("GridContainer/EffectSelector").get_selected_id()
	var duration_index = get_node("GridContainer/DurationSelector").get_selected_id()
	var cost = get_node("GridContainer/CostSelector").get_item_text(cost_index)
	var effect = get_node("GridContainer/EffectSelector").get_item_text(effect_index)
	var duration = get_node("GridContainer/DurationSelector").get_item_text(duration_index)
	print("++++++++ " + cost + ", " + effect + ", " + duration)
	# Remove these items from the selectors
	get_node("GridContainer/CostSelector").remove_item(cost_index)
	get_node("GridContainer/EffectSelector").remove_item(effect_index)
	get_node("GridContainer/DurationSelector").remove_item(duration_index)
	# Remove these items from the black market list as well
	# TBD
	# Refill the selectors with the new list
	# TBD
	var new_chip = Microchip.new_microchip(cost.to_int(), effect, duration.to_float())
	var colour_index = get_node("GridContainer/ColourSelector").get_selected_id()
	get_parent().microchips[colour_index] = new_chip
	pass # Replace with function body.
