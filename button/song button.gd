extends Button

signal button_pressed(button)

func _ready():
	connect("pressed",self,"_press")
func _press():
	emit_signal("button_pressed",self)
