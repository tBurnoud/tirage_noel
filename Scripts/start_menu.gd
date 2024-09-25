extends Node2D

var optionsScene = null
var mainContainer = null

func _ready():
	optionsScene = preload("res://Scenes/options.tscn")
	mainContainer = $PanelContainer
	

func _process(_delta):
	mainContainer.size = get_viewport_rect().size


func _on_options_pressed():
	get_tree().change_scene_to_file("res://Scenes/options.tscn")
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_launch_pressed():
	get_tree().change_scene_to_file("res://Scenes/tirage.tscn")
