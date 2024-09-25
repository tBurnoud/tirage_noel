extends Node2D

@export var TextContainer : Label 
@export var peopleContainer : Container
@export var mainScene = null
@export var mainContainer : Container
@export var ActivateShuffleButton : Button
@export var ShuffleDelayButton : Range
@export var ShuffleNumberButton : Range
@export var shuffleDelayLabel : Label
@export var shuffleNumberLabel : Label
@export var configPath = "user://data.ini"
@export var popup_panel : PopupPanel

var ActivateShuffle = false
var shuffleDelay = 0.1
var shuffleNumber = 10

var initial_names = ["Anna", "Bob", "Clémence", "Dominique", "Emma", "Florian", "Gérard", "Hector", "Ivan", "Jules", "Kévin", "Lou", "Manon", "Noémie", "Olivier"]
var personList = []

@onready var config_file := ConfigFile.new()

func load_config() -> void:
	print("loading config file...")
	var error := config_file.load(configPath)
	
	if error:
		print("An error happened while loading data: ", error)
		get_tree().change_scene_to_file("res://Scenes/options.tscn")
		return
		
		
	var i = 0
	var endOfFile = false
	while not endOfFile:
		var key = str(i)
		var tmp = config_file.get_value("Joueurs", key, null)
		if tmp != null:
			personList.append(tmp)
			print_debug(key, " ", tmp)
			var tmpLabel = LineEdit.new()
			tmpLabel.text = tmp
			tmpLabel.alignment = HORIZONTAL_ALIGNMENT_CENTER
			peopleContainer.add_child(tmpLabel)
			i += 1
		else:
			endOfFile = true
		
		
		TextContainer.text = str(len(personList))
	
	print_debug(config_file.get_value("Options", "shuffleNumber", 30))
	print_debug(config_file.get_value("Options", "shuffleDelay", 30))
	ShuffleNumberButton.set_value(float(config_file.get_value("Options", "shuffleNumber")))
	ShuffleDelayButton.set_value(float(config_file.get_value("Options", "shuffleDelay")))
	
	if (config_file.get_value("Options", "activateShuffle", false)) == "true":
		ActivateShuffleButton.button_pressed = true

func _ready():
	mainScene = preload("res://Scenes/start_menu.tscn")
	if FileAccess.file_exists(configPath):
		load_config()
	else:
		var val = int(TextContainer.text)
		for i in range(0, val):
			var tmp = LineEdit.new()
			tmp.text = "John Doe"
			tmp.alignment = HORIZONTAL_ALIGNMENT_CENTER
			peopleContainer.add_child(tmp)
			
func _process(_delta):
		mainContainer.size = get_viewport_rect().size
		popup_panel.max_size = get_viewport_rect().size

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
	var tmp = LineEdit.new()
	tmp.text = initial_names[(val-1)%len(initial_names)]
	tmp.alignment = HORIZONTAL_ALIGNMENT_CENTER
	peopleContainer.add_child(tmp)
	TextContainer.text = str(val)


func _on_validate_button_pressed():
	#var data = []
	var children = peopleContainer.get_children()
	if len(children) < 3:
		popup_panel.visible = true
		return
	var file = ConfigFile.new()
	var i = 0
	for c in children:
		#data.append(c.text)
		if c.visible:
			file.set_value("Joueurs", str(i),c.text)
			i += 1
	#var shuffle_val = ActivateShuffleButton.
	file.set_value("Options", "activateShuffle", str(ActivateShuffle))
	file.set_value("Options", "shuffleDelay", str(shuffleDelay))
	file.set_value("Options", "shuffleNumber", str(shuffleNumber))
	
	
	var error = file.save(configPath)
	if error:
		print("An error occured while saving...", error)
		
	get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")
	#get_tree().change_scene_to_packed(mainScene)
	


func _on_button_quit_pressed():
	get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")


func _on_activate_shuffle_button_pressed():
	ActivateShuffle = not ActivateShuffle

func _on_shuffle_delay_slider_value_changed(value):
	shuffleDelay = value
	shuffleDelayLabel.text = "Shuffle delay \n" + str(value)


func _on_shuffle_number_slider_value_changed(value):
	shuffleNumber = value
	shuffleNumberLabel.text = "Number of shuffle \n" + str(value)


func _on_popup_ok_button_pressed():
	popup_panel.visible = false


func _on_tab_container_tab_changed(tab):
	if tab == 1:
		ShuffleNumberButton.set_value_no_signal(float(config_file.get_value("Options", "shuffleNumber")))
		ShuffleDelayButton. set_value_no_signal(float(config_file.get_value("Options", "shuffleDelay" )))
		
		if (config_file.get_value("Options", "activateShuffle")) == "true":
			ActivateShuffleButton.button_pressed = true
		else:
			ActivateShuffleButton.button_pressed = false
