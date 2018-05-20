extends Control

onready var label = $TextureRect.get_node("Label")

var player

func _ready():
	player = get_tree().get_current_scene().get_node("Player")
	player.connect("coin_collected", self, "_on_Player_coin_collected")
	label.text = str(0)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_Player_coin_collected(newAmount):
	label.text = str(newAmount)
# ------------------------------------