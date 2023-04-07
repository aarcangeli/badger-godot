extends Node2D

var speed = 220


func _ready():
	$SnakeSprite.get_node("sprite").play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$SnakeSprite.position.x += delta * speed


func _on_audio_stream_player_finished():
	$Timeout.start()


func _on_timeout_timeout():
	queue_free()
