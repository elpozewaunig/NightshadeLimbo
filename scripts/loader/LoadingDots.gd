extends Node2D

@export var speed : float = 1

var dots : Array[Sprite2D] = []
var modulate_step = 0
var disappear = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		dots.append(child)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	modulate_step += delta * speed
	
	# Make dots fade in one by one
	if not disappear:
		for i in range(0, dots.size()):
			if modulate_step >= i:
				dots[i].modulate.a = modulate_step - i
				if dots[i].modulate.a >= 1:
					dots[i].modulate.a = 1
		
		if modulate_step >= dots.size():
			disappear = true
			modulate_step = 0
	
	# Make dots fade out one by one
	if disappear:
		for i in range(0, dots.size()):
			if modulate_step >= i:
				dots[i].modulate.a = 1 - (modulate_step - i)
				if dots[i].modulate.a <= 0:
					dots[i].modulate.a = 0
		
		if modulate_step >= dots.size():
			disappear = false
			modulate_step = 0
