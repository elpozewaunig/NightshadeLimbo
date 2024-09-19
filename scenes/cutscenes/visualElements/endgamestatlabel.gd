extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = time_string() + "\n" + death_string()

func time_string():
	var rawtime = int(Data.run_time)
	var hours = rawtime/3600
	var minutes = (rawtime/60)%60
	var seconds = rawtime%60
	var s = ""
	if hours>0:
		s+=str(hours)+"h "
	if minutes>0:
		s+=str(minutes)+"m "
	s+=str(seconds)+"s"
	return s
	
func death_string():
	if Data.run_deaths == 0 and Data.remnant_attempt == false:
		add_theme_color_override("font_color",Color.GOLD)
		$TextureRect.self_modulate = Color.GOLD
		$TextureRect2.self_modulate = Color.GOLD
	return str(Data.run_deaths)+"x"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
