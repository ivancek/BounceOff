extends Area2D

signal player_exited()

export (Resource) var LEVEL_TO_LOAD


var coins_needed
var player
var is_open = false
var is_occupied = false

func _ready():
	connect("area_entered", self, "on_area_entered")
	connect("area_exited", self, "on_area_exited")


func subscribe_to(playerRef):
	player = playerRef
	player.connect("coin_amount_changed", self, "_on_Player_coin_amount_changed")


func load_next_level():
	if LEVEL_TO_LOAD:
		get_node("/root/Game").load_level(LEVEL_TO_LOAD.resource_path)
	else:
		get_node("/root/Game").finish_game()


func _on_Player_jump_finished():
	if is_occupied:
		emit_signal("player_exited")
		player.disconnect("jump_finished", self, "_on_Player_jump_finished")


func _on_Player_coin_amount_changed(new_amount):
	if new_amount < coins_needed && is_open:
		is_open = false
		$DoorAnim.play("CloseDoor")
		$DoorSound.play(0.5)
	elif new_amount == coins_needed && !is_open:
		is_open = true
		$DoorAnim.play("OpenDoor")
		$DoorSound.play(0.5)
	
# ------------------------------------


func on_area_exited(otherArea):
	is_occupied = false


func on_area_entered(otherArea):
	if is_open:
		is_occupied = true
		if !player.is_connected("jump_finished", self, "_on_Player_jump_finished"):
			player.connect("jump_finished", self, "_on_Player_jump_finished")
	else:
		if otherArea.has_method("prepare_new_bounce"):
			otherArea.prepare_new_bounce(position, -1, 0)