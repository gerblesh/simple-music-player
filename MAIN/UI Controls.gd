extends MAIN

# extremely basic button controls implementation. 
# TODO: refactor later lol
var button_pre = preload("res://button/song button.tscn")

onready var scrubber = $controls/time
onready var pause = $controls/buttons/play
onready var forward = $controls/buttons/forward
onready var backward = $controls/buttons/backward
onready var song_container = $"songs/song container"
onready var song_label = $controls/name

func _ready():
	scrubber.connect("value_changed",self,"scrub")
	pause.connect("toggled",self,"play_toggled")
	connect("refresh_dir",self,"refresh_songs")
	connect("refresh_dir",self,"refresh_songs")

func play_toggled(button_pressed):
	get_tree().paused = button_pressed

func _process(_delta):
	scrubber.max_value = audio_stream_player.stream.get_length()
	scrubber.value = audio_stream_player.get_playback_position()
	song_label.text = music[current_song]

func scrub(value):
	if abs(value - audio_stream_player.get_playback_position()) < 1:
		return
	audio_stream_player.seek(value)

func refresh_songs():
	for I in song_container.get_children():
		I.queue_free()
	for I in music:
		var button_inst = button_pre.instance()
		button_inst.name = I
		button_inst.text = I
		button_inst.connect("button_pressed",self,"song_pressed")
		song_container.add_child(button_inst)
func song_pressed(button):
	current_song = button.get_position_in_parent()
	next_song(0)
