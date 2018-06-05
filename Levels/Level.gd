extends Node2D

onready var coins = $World/Coins.get_children()

var coin_states = []
var player_states = []
var allow_undo = true

func _ready():
	$World/Exit.coins_needed = $World/Coins.get_child_count()
	$Player.connect("jump_started", self, "on_player_jump_started")
	$Player.connect("jump_finished", self, "on_player_jump_finished")
	
	$World/Exit.subscribe($Player)
	pass


func _input(event):
	if !allow_undo:
		return
	
	if event.is_action_pressed("undo"):
		undo()
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()


func undo():
	undo_player_state()
	undo_coins_state()


func on_player_jump_started():
	allow_undo = false
	save_coins_state()
	save_player_state()


func on_player_jump_finished():
	allow_undo = true


func save_coins_state():
	var _coin_states = []
	for a in coins:
		_coin_states.append(a.get_state())
	
	coin_states.push_front(_coin_states)


func undo_coins_state():
	if coin_states.size() == 0:
		return
	
	var _coin_states = coin_states.pop_front()
	
	var i = 0
	for a in coins:
		a.set_state(_coin_states[i])
		i += 1


func save_player_state():
	var player_state = {}
	player_state = $Player.get_state().duplicate()
	player_states.push_front(player_state)


func undo_player_state():
	if player_states.size() == 0:
		return
	
	var _p_state = player_states.pop_front()
	$Player.set_state(_p_state)