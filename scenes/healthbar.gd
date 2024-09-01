extends Node2D

func setHP(hp:int) -> void:
	if hp <= 0:
		$hp1.visible = false
		$hp2.visible = false
		$hp2.visible = false
	if hp == 1:
		$hp1.visible = true
		$hp2.visible = false
		$hp2.visible = false	
	if hp == 2:
		$hp1.visible = true
		$hp2.visible = true
		$hp2.visible = false	
	if hp >= 3:
		$hp1.visible = true
		$hp2.visible = true
		$hp2.visible = true	
		
		
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
