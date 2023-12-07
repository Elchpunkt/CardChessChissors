extends MarginContainer
var choice : int
var plus_minus : bool = false
var aktivate : bool = false
var available_resources : int = 1
var resource_type : String

signal Choice_is_made(choice)

func set_choice_name(thisname : String):
	$Choice_name.text = thisname

func set_up_choice_popup(possiblities : int):
	var children : Array[Node] = get_node("GridContainer").get_children()
	for child in children:
		child.visible = false
	for i in range(0,1+(possiblities-1)*2):
		children[i].visible = true
		
func set_up_plus_minus(available_resources_in : int, resource_name : String):
	plus_minus = true
	resource_type = resource_name
	available_resources = available_resources_in
	set_up_choice_popup(2)
	$GridContainer/Button1/Button1_Text.text = "-"
	$GridContainer/Button2/Button2_Text.text = "+"
	update_value()
		
func set_up_activate(ability : String):
	aktivate = true
	set_up_choice_popup(1)
	$GridContainer/Button1/Button1_Text.text = "Aktivate : " + ability 
	$Button.text = "Cancel"
	
func update_value():
	$GridContainer/Seperator1/Seperator1_Text.text = resource_type + "\n" + str(choice)
	
func _on_button_pressed():
	Choice_is_made.emit(choice)


func _on_button_1_pressed():
	if plus_minus:
		choice = clamp((choice - 1),0,available_resources)
		update_value()
	if aktivate:
		choice = 1
		Choice_is_made.emit(choice)


func _on_button_2_pressed():
	if plus_minus:
		choice = clamp((choice + 1),0,available_resources)
		update_value()

func _on_button_3_pressed():
	pass # Replace with function body.


func _on_button_4_pressed():
	pass # Replace with function body.
