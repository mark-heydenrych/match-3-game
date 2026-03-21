class_name RewardScreen
extends Node2D

var active: bool = true

var card = null

# Called when the node enters the scene tree for the first time.
func _ready():
	# Add cards from the globals
	var _card = get_tree().get_root().get_node("BaseScene").get_node("Globals").get_shop_cards(1)[0]
	card = Card.new_card(_card[0], _card[1], _card[2])
	add_child(card)
	card.position = Vector2(206, 170)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_take_it_button_pressed():
	get_parent().add_reward(card)
	get_parent().level_select()
	print("Took it!")
	pass # Replace with function body.


func _on_leave_it_button_pressed():
	print("Left it!")
	get_parent().level_select()
	pass # Replace with function body.
