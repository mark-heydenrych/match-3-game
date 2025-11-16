extends Node2D

var time_delta = 0
var timespan = 0.05

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (get_node("StatusLabel").visible_characters == -1):
		return
	time_delta += delta
	if (time_delta >= timespan):
		time_delta -= timespan
		get_node("StatusLabel").visible_characters = get_node("StatusLabel").visible_characters + 1
		if (get_node("StatusLabel").visible_characters == len(get_node("StatusLabel").text)):
			get_node("StatusLabel").visible_characters = -1
	pass

func status_from_score(score):
	var status_string = ""
	var goal_score = get_parent().get_node("gameboard").goal_score
	status_string += "Money earned: $%.2f\n" % score
	status_string += "Debt remaining: $%.2f\n" % (goal_score - score)
	status_string += "----------\n"
	status_string += "Repair Fee: $%.2f\n" % (score * 0.15)
	status_string += "Recharge Fee: $%.2f\n" % (score * 0.20)
	status_string += "Maintenance Fee: $%.2f\n" % (score * 0.25)
	status_string += "Service Fee: $%.2f\n" % (score * 0.1)
	status_string += "Convenience Fee: $%.2f\n" % (score * 0.14)
	status_string += "Service Convenience Fee: $%.2f\n" % (score * 0.16)
	status_string += "Total Fees: $%.2f\n" % score
	status_string += "Outstanding Indenture: $%.2f\n" % goal_score
	status_string += "\n"
	status_string += "Thank you for working with GalactiCorp!"
	return status_string

func set_label_text(score):
	get_node("StatusLabel").clear()
	get_node("StatusLabel").push_color(Color.BLACK)
	get_node("StatusLabel").push_font_size(20)
	get_node("StatusLabel").append_text(status_from_score(score))
	get_node("StatusLabel").visible_characters = 0
