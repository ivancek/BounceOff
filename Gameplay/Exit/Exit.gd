extends Area2D

export (Resource) var LEVEL_TO_LOAD

var coins_needed
var player
var is_open = false

func _ready():
	player = get_tree().get_current_scene().get_node("Player")
	player.connect("coin_amount_changed", self, "_on_Player_coin_amount_changed")
	connect("area_entered", self, "on_area_entered")


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

func on_area_entered(otherArea):
	if is_open:
		get_node("/root/global").load_level(LEVEL_TO_LOAD.resource_path)
	else:
		if otherArea.has_method("prepare_new_bounce"):
			otherArea.prepare_new_bounce(position, -1, 0)