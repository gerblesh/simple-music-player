extends MAIN

# extremely basic button controls implementation. 
# TODO: refactor later lol
var button_pre = preload("res://MAIN/button/song button.tscn")

onready var scrubber = $controls/time
onready var pause = $controls/buttons/play
onready var forward = $controls/buttons/forward
onready var backward = $controls/buttons/backward
onready var song_container = $"songs/song container"
onready var song_label = $controls/name
onready var time_label = $"controls/time label"

func _ready():
	scrubber.connect("value_changed",self,"scrub")
	pause.connect("toggled",self,"play_toggled")
	connect("refresh_dir",self,"refresh_songs")
	connect("refresh_dir",self,"refresh_songs")
	forward.connect("pressed",self,"song_forward")
	backward.connect("pressed",self,"song_backward")
func play_toggled(button_pressed):
	get_tree().paused = button_pressed
func _process(_delta):
	song_length = audio_stream_player.stream.get_length()
	song_position = audio_stream_player.get_playback_position()
	scrubber.max_value = song_length
	scrubber.value = song_position
	song_label.text = song_names[current_song]
	time_label.text = str(secs_to_mins(song_position)," / ",secs_to_mins(song_length))
func secs_to_mins(seconds:float):
	seconds = round(seconds)
	var minutes = floor(seconds/60)
	var new_seconds = fmod(seconds,60)
	if str(new_seconds).length() < 2:
		new_seconds = str("0",new_seconds)
	return str(minutes,":",new_seconds)
func scrub(value):
	if abs(value - audio_stream_player.get_playback_position()) <= 0.01:
		return
	audio_stream_player.seek(value)
func song_backward():
	next_song(-1)
func song_forward():
	next_song(1)
func refresh_songs():
	for I in song_container.get_children():
		I.queue_free()
	for I in song_names:
		var button_inst = button_pre.instance()
		button_inst.name = I
		button_inst.text = I
		button_inst.connect("button_pressed",self,"song_pressed")
		song_container.add_child(button_inst)
func song_pressed(button):
	current_song = button.get_position_in_parent()
	next_song(0)
