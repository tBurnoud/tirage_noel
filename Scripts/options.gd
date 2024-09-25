extends Node2D

var TextContainer = null
var peopleContainer = null

func _ready():
	TextContainer = $Container/HBoxContainer/Label
	peopleContainer = $Container/GridContainer/VBoxContainer
	
	var val = int(TextContainer.text)
	
	for io in range(1, val):
		var tmp = Button.new()
		tmp.text = "John Doe"
		peopleContainer.add_child(tmp)

func _on_button_minus_pressed():
	var val = int(TextContainer.text)
	val -= 1
	var children = peopleContainer.get_children()
	var to_remove = children.pop_back()
	#for c in children:
		#print_debug(c)
	if val < 1:
		val = 1
	else:
		to_remove.queue_free()
	TextContainer.text = str(val)


func _on_button_plus_pressed():
	var val = int(TextContainer.text)
	val += 1
	var tmp = Button.new()
	tmp.text = "ajout"
	peopleContainer.add_child(tmp)
	TextContainer.text = str(val)


func _on_validate_button_pressed():
	var data = []
	var children = peopleContainer.get_children()
	var file = ConfigFile.new()
	var i = 0
	for c in children:
		data.append(c.text)
		file.set_value("Joueurs", str(i),c.text)
		i += 1
	
	var json_string = JSON.stringify(data)
	#print_debug(json_string)
	
	
	
	var error = file.save("res://data.ini")
	if error:
		print("An error occured while saving...", error)
