extends Node2D

@export var submenus : Array[Submenu] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect to all submenu's opened signal
	for submenu in submenus:
		submenu.opened.connect(_on_submenu_opened)

func _on_submenu_opened(menu_opened: Submenu) -> void:
	# Hide all other menus when one is opened
	for submenu in submenus:
		if submenu == menu_opened:
			submenu.show()
		else:
			submenu.hide()
