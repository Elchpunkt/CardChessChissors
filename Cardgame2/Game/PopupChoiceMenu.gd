extends MarginContainer
var choice
var plus_minus : bool = false

signal Choice_is_made(choice)

func set_up_choice_popup(possiblities : int):
	var children : Array[Node] = get_node("GridContainer").get_children()
	for child in children:
		child.visible = false
	for i in range(0,1+(possiblities-1)*2):
		children[i].visible = true
		
func set_up_plus_minus():
	set_up_choice_popup(2)
	$GridContainer/Button1/Button1_Text.text = "-"
	$GridContainer/Button2/Button2_Text.text = "+"
	
func update_value():
	$GridContainer/Seperator1/Seperator1_Text.text = str(choice)
	
func _on_button_pressed():
	Choice_is_made.emit(choice)


func _on_button_1_pressed():
	if plus_minus:
		choice -= 1
		update_value()


func _on_button_2_pressed():
	if plus_minus:
		choice += 1
		update_value()

func _on_button_3_pressed():
	pass # Replace with function body.


func _on_button_4_pressed():
	pass # Replace with function body.
