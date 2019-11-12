extends RigidBody2D

onready var Game = get_node("/root/Game")
onready var Camera = get_node("/root/Game/Camera")
onready var Starting = get_node("/root/Game/Starting")

var _decay_rate = 0.8
var _max_offset = 4


var _start_size
var _start_position
var _trauma = 0.0
var _rotation = 0
var _rotation_speed = 0.05


func _ready():
	contact_monitor = true
	set_max_contacts_reported(4)
	
	
	
	
func _physics_process(delta):
	# Check for collisions
	var bodies = get_colliding_bodies()
	for body in bodies:
		Camera.add_trauma(0.4)
		add_trauma(1.0)
		if body.is_in_group("Tiles"):
			Game.change_score(body.points)
			body.kill()
		if body.name == "Paddle":
			var tile_rows = get_tree().get_nodes_in_group("Tile Row")
			for tile in tile_rows:
				tile.add_trauma(0.2)
	
	if position.y > get_viewport().size.y:
		Game.change_lives(-1)
		Starting.startCountdown(3)
		queue_free()
		
		
func add_trauma(amount):
	_trauma = min(_trauma + amount, 1)
	
func _decay_trauma(delta):
	var change = _decay_rate * delta
	_trauma = max(_trauma - change, 0)
	
func _apply_shake():
	var shake = _trauma * _trauma
	var o_x = _max_offset * shake * _get_neg_or_pos_scalar()
	var o_y = _max_offset * shake * _get_neg_or_pos_scalar()
	$Sprite.rect_position = _start_position +Vector2(o_x,o_y)
	
	
func _get_neg_or_pos_scalar():
	return rand_range(-1.0,1.0)
	