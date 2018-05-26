extends Area2D

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	connect("area_entered", self, "on_area_entered")


func on_area_entered(otherArea):
	
	if not visible:
		return
	
	if otherArea.has_method("collect_coin"):
		otherArea.collect_coin()
		visible = false


func get_state():
	return visible

func set_state(is_visible):
	visible = is_visible