extends Node2D

var current_scene


func _ready():
	load_main_menu()
	pass


func load_main_menu():
	var main_menu = load("res://Core/MainMenu.tscn")
	current_scene = main_menu.instance()
	current_scene.name = "MainMenu"
	$GUI.add_child(current_scene)
	
	if !$Audio.is_playing():
		$Audio.play()
	
	pass


func start_game(path):
	$GUI.remove_child(current_scene)
	current_scene.queue_free()
	var new_level = load(path)
	current_scene = new_level.instance()
	current_scene.name = "CurrentLevel"
	add_child(current_scene)
	pass


func finish_game():
	remove_child(current_scene)
	current_scene.queue_free()
	load_main_menu()
	pass


func load_level(path):
	remove_child(current_scene)
	current_scene.queue_free()
	var new_level = load(path)
	current_scene = new_level.instance()
	current_scene.name = "CurrentLevel"
	add_child(current_scene)
	pass