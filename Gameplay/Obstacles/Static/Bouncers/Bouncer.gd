extends Area2D

const PlayerClass = preload("res://Gameplay/Player/Player.gd")
enum BounceDirection { Left, Right, Up, Down, Opposite }

export (Texture) var TEXTURE
export (int) var ADDED_POWER = 0
export (BounceDirection) var BOUNCE_DIRECTION = BounceDirection.Left

var bounce_direction = { 
	BounceDirection.Left : Vector2(-1, 0), 
	BounceDirection.Right : Vector2(1, 0),
	BounceDirection.Up : Vector2(0, -1),
	BounceDirection.Down : Vector2(0, 1),
	BounceDirection.Opposite : -1
}



func _ready():
	$Sprite.texture = TEXTURE
	connect("area_entered", self, "on_area_entered")

func on_area_entered(otherArea):
	if otherArea.has_method("prepare_new_bounce"):
		otherArea.prepare_new_bounce(position, bounce_direction[BOUNCE_DIRECTION], ADDED_POWER)