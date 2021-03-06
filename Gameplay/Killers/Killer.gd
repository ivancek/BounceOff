extends Area2D

var is_occupied = false
var occupant

func _ready():
	connect("area_entered", self, "on_area_entered")
	connect("area_exited", self, "on_area_exited")

func on_area_entered(otherArea):
	is_occupied = true
	occupant = otherArea
	
	if otherArea.has_method("prepare_new_bounce"): # its the player
		occupant.connect("jump_finished", self, "on_player_jump_finished")

func on_area_exited(otherArea):
	if is_occupied:
		if occupant.has_method("prepare_new_bounce"): # it is the player that is occupying
			occupant.disconnect("jump_finished", self, "on_player_jump_finished")
	is_occupied = false

func on_player_jump_finished():
	if is_occupied:
		if occupant.has_method("die"): # it is the player that is occupying
			occupant.die()
		else: # must be something else
			occupant.queue_free()













