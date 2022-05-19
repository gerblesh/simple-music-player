extends Control

class_name MAIN

signal refresh_dir
signal update_ui

var audio_stream_player = AudioStreamPlayer.new()

var song_idx = null
var song_path
var song_name
var song_length
var song_position

var music_dir_path
var music_dir

var music = []
var song_names = []
var song_queue = []

func _ready():
	music_dir_path = ConfigSave.load_value("config","last dir",OS.get_system_dir(OS.SYSTEM_DIR_MUSIC))
	yield(get_tree(), "idle_frame") # waiting for the UI ready function to connect it's signals
	add_child(audio_stream_player)
	audio_stream_player.connect("finished",self,"next_song")
	audio_stream_player.pause_mode = Node.PAUSE_MODE_STOP
	refresh_dir()
func next_song(next = 1):
	if music.size() < 1:
		return
	if song_idx == null:
		song_idx = 0
	get_tree().paused = false
	song_idx = wrapi(song_idx + next,0,music.size()) # constrains the index from getting outside of the array
	var file_path = music[song_idx]
	song_name = song_names[song_idx]
	song_path = file_path
	audio_stream_player.stream = AudioLoader.new().loadfile(file_path)
	audio_stream_player.play()
	emit_signal("update_ui")
func is_audio_file(stringname):
	return stringname.ends_with(".wav") or stringname.ends_with(".ogg") or stringname.ends_with(".mp3")
func refresh_dir():
	music_dir = Directory.new()
	music = []
	song_names = []
	if music_dir.open(music_dir_path) == OK: # checking if the file can be opened
		music_dir.list_dir_begin()
		var filepath = music_dir.get_next()
		while true:
			filepath = music_dir.get_next()
			if filepath == "":
				ConfigSave.save_value("config","last dir",music_dir_path)
				emit_signal("refresh_dir")
				return
			if !music_dir.current_is_dir() and is_audio_file(filepath):
				music.append(music_dir_path+"/"+filepath)  # storing the file path
				song_names.append(filepath) # storing the file name
	else:
		print("failed to open file")
