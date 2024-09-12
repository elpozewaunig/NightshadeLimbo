extends Node2D
class_name ButtonSelector

@export var button_rows : Array[ButtonRowConfig] = []
@export var default_active : bool = false

var highlight_active = false
var highlight_row = 0
var highlight_col = 0

enum Direction {UP, DOWN, LEFT, RIGHT}

signal set_key_mode(source)
signal set_mouse_mode(source)

signal ext_selected(button)
signal ext_cleared
signal disabled

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get all buttons in all rows
	for row in button_rows:
		for button in row.buttons:
			# Connect all buttons to the external selection signals
			ext_selected.connect(button._on_ext_selected)
			ext_cleared.connect(button._on_ext_cleared)
			disabled.connect(button._on_disabled)
			
			# Connect self to button's select signal
			button.selected.connect(_on_btn_selected)
			
	if default_active:
		set_key_mode.emit(self)
		enable_highlight()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if get_current_button().is_visible_in_tree() and not get_current_button().disabled:
		if Input.is_action_just_pressed("ui_up"):
			activate_or_move(Direction.UP)
		if Input.is_action_just_pressed("ui_down"):
			activate_or_move(Direction.DOWN)
		if Input.is_action_just_pressed("ui_left"):
			activate_or_move(Direction.LEFT)
		if Input.is_action_just_pressed("ui_right"):
			activate_or_move(Direction.RIGHT)

func activate_or_move(move: int) -> void:
	# If a button is currently highlighted
	if highlight_active or get_current_button().mouse_inside:
		if (move == Direction.UP and highlight_row > 0):
			highlight_row -= 1
		elif (move == Direction.DOWN and highlight_row < button_rows.size() - 1):
			highlight_row += 1
		elif (move == Direction.LEFT and highlight_col > 0):
			highlight_col -= 1
		elif (move == Direction.RIGHT and highlight_col < current_row_buttons().size() - 1):
			highlight_col += 1
			
		# If the row that is being switched to has fewer buttons jump to the closest button
		if highlight_col > current_row_buttons().size() - 1:
			highlight_col = current_row_buttons().size() - 1
	
	# Else, just enable the highlight but don't change the position
	set_key_mode.emit(self)
	enable_highlight()

func current_row_buttons() -> Array[SelectableButton]:
	return button_rows[highlight_row].buttons

func get_button(row: int, col: int) -> SelectableButton:
	return button_rows[row].buttons[col]

func get_current_button() -> SelectableButton:
	return get_button(highlight_row, highlight_col)

func _input(event):
	# As soon as the mouse is moved, disable the highlight if currently active
	if event is InputEventMouseMotion and get_current_button().is_visible_in_tree():
		set_mouse_mode.emit(self)
		disable_highlight()

func _on_key_mode_changed(active, source) -> void:
	# Only handle signal if it came from another button selector
	if not source == self:
		
		# Input through keyboard
		if active:
			enable_highlight()
		# Input through mouse
		else:
			disable_highlight()

# When a button reports that it has been selected, update the selection index
func _on_btn_selected(button):
	if not highlight_active:
		
		# Check all buttons to find the index of the selected one
		for row_i in range(0, button_rows.size()):
			for col_i in range(0, button_rows[row_i].buttons.size()):
				var compare_btn = get_button(row_i, col_i)
				if compare_btn == button:
					highlight_row = row_i
					highlight_col = col_i

func enable_highlight():
	highlight_active = true
	# Notify buttons of the currently highlighted button
	ext_selected.emit(get_current_button())

func disable_highlight():
	highlight_active = false
	ext_cleared.emit()

# Can be called to make all buttons unselectable
func disable() -> void:
	disabled.emit()
