extends MAIN

# extremely basic button controls implementation. 
# TODO: refactor later lol
var button_pre = preload("res://MAIN/button/song button.tscn")

# UI references
onready var scrubber = $controls/time
onready var pause = $controls/buttons/play
onready var forward = $controls/buttons/forward
onready var backward = $controls/buttons/backward
onready var song_container = $"songs/song container"
onready var song_label = $controls/name
onready var time_label = $"controls/time label"
onready var directory_label = $directory/text
onready var directory_change = $directory/change
onready var file_panel = $popup
func _ready():
	# connecting signals from main script
	connect("refresh_dir",self,"refresh_songs")
	connect("update_ui",self,"update_ui")
	# connecting UI signals
	scrubber.connect("value_changed",self,"scrub")
	pause.connect("toggled",self,"play_toggled")
	forward.connect("pressed",self,"song_forward")
	backward.connect("pressed",self,"song_backward")
	directory_change.connect("pressed",self,"change_dir_pressed")

func _process(_delta):
	if audio_stream_player.stream == null:
		return
	# updating the scrubber position each frame
	song_position = audio_stream_player.get_playback_position()
	scrubber.value = song_position
	time_label.text = str(secs_to_mins(song_position)," / ",secs_to_mins(song_length))
func secs_to_mins(seconds:float):
	seconds = round(seconds)
	var minutes = floor(seconds/60)
	var new_seconds = fmod(seconds,60)
	if str(new_seconds).length() < 2:
		new_seconds = str("0",new_seconds)
	return str(minutes,":",new_seconds)
func scrub(value):
	if abs(value - audio_stream_player.get_playback_position()) <= 0.1:
		return
	audio_stream_player.seek(value)

func update_ui():
	pause.pressed = get_tree().paused
	song_length = audio_stream_player.stream.get_length()
	scrubber.max_value = song_length
	song_label.text = song_name

func song_backward():
	next_song(-1)
func song_forward():
	next_song(1)

func song_pressed(button):
	song_idx = button.get_position_in_parent()
	next_song(0)
func change_dir_pressed():
	file_panel.current_dir = music_dir_path
	file_panel.popup_centered(Vector2(500,350))
	file_panel.connect("dir_selected",self,"dir_selected")
func dir_selected(dir):
	music_dir_path = dir
	song_idx = null
	refresh_dir()
func refresh_songs():
	for I in song_container.get_children():
		I.queue_free()
	for I in song_names:
		var button_inst = button_pre.instance()
		button_inst.name = I
		button_inst.text = I
		button_inst.connect("button_pressed",self,"song_pressed")
		song_container.add_child(button_inst)
	directory_label.text = "Current Folder: "+music_dir_path

func play_toggled(button_pressed):
	get_tree().paused = button_pressed
