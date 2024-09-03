extends Node2D

@export var speed : float = 1

var dots : Array[Sprite2D] = []
var modulate_step = 0
var disappear = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		dots.append(child)
		child.modulate.a = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not disappear:
		modulate_step += delta * speed
		
		for i in range(0, dots.size()):
			if modulate_step >= i:
				dots[i].modulate.a = modulate_step - i
				if dots[i].modulate.a >= 1:
					dots[i].modulate.a = 1
		
		if modulate_step >= dots.size():
			disappear = true
			modulate_step = 0
			
	
	if disappear:
		for dot in dots:
			dot.modulate.a -= delta * speed
			if dot.modulate.a <= 0:
				dot.modulate.a = 0
				disappear = false
