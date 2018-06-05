extends Area2D

signal level_complete()

export (Resource) var LEVEL_TO_LOAD


var coins_needed
var player
var is_open = false
var is_occupied = false

func _ready():
	connect("area_entered", self, "on_area_entered")
	connect("area_exited", self, "on_area_exited")

func subscribe(playerRef):
	player = playerRef
	player.connect("coin_amount_changed", self, "_on_Player_coin_amount_changed")


func _on_Player_jump_finished():
	if is_occupied:
		player.disconnect("jump_finished", self, "_on_Player_jump_finished")
		get_node("/root/global").load_level(LEVEL_TO_LOAD.resource_path)


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
		player.connect("jump_finished", self, "_on_Player_jump_finished")
	else:
		if otherArea.has_method("prepare_new_bounce"):
			otherArea.prepare_new_bounce(position, -1, 0)