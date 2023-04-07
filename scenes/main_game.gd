extends Node2D

var min_size = 0.1
var max_size = 1.4
var current_side = false
var last_mushroom
var last_snake

@onready var _badger_prefab = preload("res://prefabs/badger.tscn")
@onready var _mushroom_prefab = preload("res://prefabs/mushroom.tscn")
@onready var _spawn_location = $SpawnLocation
@onready var _horizon: Node2D = $Horizon
@onready var _bottom: Node2D = $Bottom


func _ready():
	$Detail1.z_index = $Detail1Loc.global_position.y
	$Detail2.z_index = 1000


func _input(event):
	if event is InputEventKey and event.is_action_pressed("ui_cancel"):
		get_tree().quit()
		return

	if event is InputEventMouseButton and event.is_pressed():
		_on_click(event)


func _reset():
	for itm in _spawn_location.get_children():
		itm.free()
	_reset_popups()


func _reset_popups():
	if is_instance_valid(last_snake):
		last_snake.queue_free()
	if is_instance_valid(last_mushroom):
		last_mushroom.queue_free()
		current_side = false


func _on_click(event: InputEventMouseButton):
	# left click
	if event.button_index == 1:
		spawn_badger(event)

	# right click
	if event.button_index == 2:
		if not is_instance_valid(last_mushroom):
			_reset()
			last_mushroom = _mushroom_prefab.instantiate()
			last_mushroom.z_index = 1001
			add_child(last_mushroom)

	# middle click
	if event.button_index == 3:
		_reset()
		last_snake = preload("res://prefabs/snake.tscn").instantiate()
		last_snake.z_index = 1002
		add_child(last_snake)


func spawn_badger(event: InputEventMouseButton):
	_reset_popups()

	var badger: AnimatedSprite2D = _badger_prefab.instantiate()
	_spawn_location.add_child(badger)
	badger.global_position = event.position

	# Adjust the scale
	var min = _horizon.global_position.y
	var max = _bottom.global_position.y
	var alpha = (badger.global_position.y - min) / (max - min)
	if alpha < 0:
		alpha = 0
		badger.global_position.y = min

	var scale = lerp(min_size, max_size, alpha)
	#var side = 1 if randi() % 2 == 0 else -1
	var side = 1 if current_side else -1
	badger.scale = Vector2(scale * side, scale)

	if randf() < 0.8:
		current_side = not current_side

	# set z-index
	badger.z_index = badger.get_node("Pivot").global_position.y
