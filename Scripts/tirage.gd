extends Node2D

@export var filepath = "user://data.ini"

@export var next_button : Button
@export var mainContainer : Container
@export var tirage_container1 : Container
@export var tirage_container2 : Container
@export var shuffle_timer : Timer

@export var nb_shuffle = 30
@export var shuffle_delay = 0.1
@export var activate_shuffle = false

var label_settings = null
var data = []
var tmp_person = null
var tmp_text2 = null
var rng = null

var liste_transi = []

var l = 0
var cpt = 0
var personName = ""

func _process(_delta):
	mainContainer.size = get_viewport_rect().size

func transiOK(transi):
	for i in range(0,len(transi)):
		if transi[i] == i:
			return false
	return true
	
func tirage():
	liste_transi = []
	data.shuffle()
	for i in range(0, len(data)):
		liste_transi.append(i)
	liste_transi.shuffle()
	
	while not transiOK(liste_transi):
		liste_transi.shuffle()
		

func load_save() -> void:
	var config_file := ConfigFile.new()
	var error := config_file.load(filepath)
	var endOfFile = false
	
	if error:
		print("An error happened while loading data: ", error)
		endOfFile = true
		get_tree().change_scene_to_file("res://Scenes/options.tscn")
		return
		
		
	var i = 0
	while not endOfFile:
		var key = str(i)
		var tmp = config_file.get_value("Joueurs", key, null)
		if tmp != null:
			print(tmp)
			data.append(tmp)
			tmp_person = LineEdit.new()
			if tmp_person:
				tmp_person.text = tmp
		else:
			endOfFile = true
		i += 1
		
	
	nb_shuffle = int(config_file.get_value("Options", "shuffleNumber", -1))
	shuffle_delay = float(config_file.get_value("Options", "shuffleDelay", -1))
	activate_shuffle = (config_file.get_value("Options", "activateShuffle", false))
	print(nb_shuffle, " ", shuffle_delay, " " ,activate_shuffle)

func _ready():
	l = 0
	label_settings = LabelSettings.new()
	label_settings.font_size = 32
	#label_settings.
	
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
	load_save()
	tirage()
	

func displayNextPerson():
	if l >= len(data):
		next_button.set_disabled(true)
		return
	tmp_person = Label.new()
	tmp_text2 = Label.new()
	tmp_person.set_label_settings(label_settings)
	tmp_text2.set_label_settings(label_settings)
	
	tmp_person.text = str(data[liste_transi[l]])
	tmp_person.text += " donne à "
	personName = data[l]
	
	tirage_container1.add_child(tmp_person)
	cpt = 0
	if activate_shuffle == "true":
		shuffle_timer.start(shuffle_delay)
		next_button.set_disabled(true)
	else:
		tmp_text2.text = personName
	tirage_container2.add_child(tmp_text2)
	l += 1
	next_button.text = "Prochaine Personne (" + str(len(data) - l) + " restants)"



func shuffle_text():
	if cpt < nb_shuffle and activate_shuffle == "true":
		#var characters = 'abcdefghijklmnopqrstuvwxyz abcdefghijklmnopqrstuvwxyz abcdefghijklmnopqrstuvwxyz abcdefghijklmnopqrstuvwxyz abcdefghijklmnopqrstuvwxyz abcdefghijklmnopqrstuvwxyz abcdefghijklmnopqrstuvwxyz abcdefghijklmnopqrstuvwxyz abcdefghijklmnopqrstuvwxyz ÉÈÀ'
		var characters = 'abcdefghijklmnopqrstuvwxyz abcdefghijklmnopqrstuvwxyz abcdefghijklmnopqrstuvwxyz ȕǻǽȃȅȇȉȋȩȧȗœǽǣ'
		var name_length = len(data)
		var tmp = generate_word(characters, rng.randi_range(name_length-1, name_length+1))
		tmp_text2.text = tmp
		cpt += 1
		shuffle_timer.start(shuffle_delay)
	else:
		next_button.set_disabled(false)
		tmp_text2.text = personName

func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")

func generate_word(chars, length):
	var word: String
	var n_char = len(chars)
	for i in range(length):
		word += chars[randi()% n_char]
	return word
