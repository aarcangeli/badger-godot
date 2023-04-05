extends Node2D

var scale_offset = 0.3

func _ready():
	pass

func _on_timer_timeout():
	queue_free()

func _input(event):
	if (event is InputEventMouseButton and event.is_pressed() and event.button_index == 2):
		scale = scale + Vector2(scale_offset, scale_offset)
		$Timeout.start()
		$Sound.stream = preload("res://assets/sounds/BadgerMunchroom2.mp3")
		$Sound.play()
