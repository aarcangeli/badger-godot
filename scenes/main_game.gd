extends Node2D

@onready var _badgerPath = preload("res://prefabs/badger.tscn")
@onready var _mushroomPrefab = preload("res://prefabs/mushroom.tscn")
@onready var _spawnLocation = $SpawnLocation
@onready var _horizon: Node2D = $Horizon
@onready var _bottom: Node2D = $Bottom

var min_size = 0.1
var max_size = 1.4
var current_side = true
var last_mushroom

func _ready():
	$Detail1.z_index = $Detail1Loc.global_position.y
	$Detail2.z_index = 1000

func _input(event):
	if (event is InputEventKey and event.is_action_pressed("ui_cancel")):
		get_tree().quit()
		return

	if (event is InputEventMouseButton and event.is_pressed()):
		_on_click(event)

func _on_click(event: InputEventMouseButton):
	
	# right click
	if (event.button_index == 2):
		for itm in _spawnLocation.get_children():
			itm.free()
		if not is_instance_valid(last_mushroom):
			last_mushroom = _mushroomPrefab.instantiate()
			last_mushroom.z_index = 1001
			add_child(last_mushroom)
		return

	if is_instance_valid(last_mushroom):
		last_mushroom.queue_free()

	var badger: AnimatedSprite2D = _badgerPath.instantiate()
	_spawnLocation.add_child(badger)
	badger.global_position = event.position

	# Adjust the scale
	var min = _horizon.global_position.y
	var max = _bottom.global_position.y
	var alpha = (badger.global_position.y - min) / (max - min)
	if alpha < 0:
		badger.free()
		return

	var scale = lerp(min_size, max_size, alpha)
	#var side = 1 if randi() % 2 == 0 else -1
	var side = 1 if current_side else -1
	badger.scale = Vector2(scale * side, scale)
	
	if (randf() < 0.8):
		current_side = not current_side

	# set z-index
	badger.z_index = badger.get_node("Pivot").global_position.y
