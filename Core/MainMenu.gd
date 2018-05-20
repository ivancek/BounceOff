extends TextureRect

func _ready():
	$ButtonPlay.connect("pressed", self, "_on_ButtonPlay_pressed")
	$ButtonQuit.connect("pressed", self, "_on_ButtonQuit_pressed")



func _on_ButtonPlay_pressed():
	get_node("/root/global").load_level("res://Gameplay/Levels/Level1.tscn")


func _on_ButtonQuit_pressed():
	get_tree().quit()