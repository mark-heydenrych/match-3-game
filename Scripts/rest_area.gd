class_name RestArea
extends Node2D

var active: bool = true

var recharge_cost = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_recharge_button_pressed():
	get_node("ClickPlayer").play()
	if (get_parent().spend_diamonds(recharge_cost)):
		if (recharge_cost == 1):
			recharge_cost = 2
		else:
			recharge_cost *= recharge_cost
		print("Recharging")
		get_parent().recharge()
		get_node("RechargeButton").text = str(recharge_cost) + " Shards: Recharge: +5 Turns"
		get_node("DebugButton").text = str(recharge_cost) + " Shard: Debug (Remove Debuffs)"
	pass # Replace with function body.


func _on_debug_button_pressed():
	get_node("ClickPlayer").play()
	if (get_parent().spend_diamonds(recharge_cost)):
		if (recharge_cost == 1):
			recharge_cost = 2
		else:
			recharge_cost *= recharge_cost
		print("Debugging")
		get_parent().get_node("SideBoard").remove_all_debuffs()
		get_node("RechargeButton").text = str(recharge_cost) + " Shards: Recharge: +5 Turns"
		get_node("DebugButton").text = str(recharge_cost) + " Shard: Debug (Remove Debuffs)"
	pass # Replace with function body.


func _on_leave_button_pressed():
	print("Leaving")
	get_parent().level_select()
