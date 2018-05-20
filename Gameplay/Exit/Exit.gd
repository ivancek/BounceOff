extends Area2D

export (int) var COINS_NEEDED = 0
export (Resource) var LEVEL_TO_LOAD

var player
var is_open = false

func _ready():
	player = get_tree().get_current_scene().get_node("Player")
	player.connect("coin_collected", self, "_on_Player_coin_collected")
	connect("area_entered", self, "on_area_entered")

func _on_Player_coin_collected(newAmount):
	if newAmount >= COINS_NEEDED:
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