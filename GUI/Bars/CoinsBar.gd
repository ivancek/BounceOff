extends Control

onready var label = $TextureRect.get_node("Label")

var player

func _ready():
	player = get_node("/root/Game/CurrentLevel/Player")
	player.connect("coin_amount_changed", self, "_on_Player_coin_amount_changed")
	label.text = str(0)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_Player_coin_amount_changed(new_amount):
	label.text = str(new_amount)
# ------------------------------------