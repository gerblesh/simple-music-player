extends Control
class_name MAIN
# signals
signal refresh_dir
# audiostreamplayer
var audio_stream_player = AudioStreamPlayer.new()
# music directory and song variables
onready var music_dir_path = OS.get_system_dir(OS.SYSTEM_DIR_MUSIC)
var current_song = 0
var music_dir
var music = []
func _ready():
	yield(get_tree(), "idle_frame")
	add_child(audio_stream_player)
	audio_stream_player.connect("finished",self,"next_song")
	audio_stream_player.pause_mode = Node.PAUSE_MODE_STOP
	refresh_dir()
	next_song(0)

func next_song(next = 1):
	current_song = wrapi(current_song + next,0,music.size()) # constrains the index from getting outside of the array
	var file_path = music_dir_path+"/"+music[current_song]
	audio_stream_player.stream = AudioLoader.new().loadfile(file_path)
	audio_stream_player.play()

func refresh_dir():
	music_dir = Directory.new()
	if music_dir.open(music_dir_path) == OK: # checking if the file can be opened
		music_dir.list_dir_begin()
		var name = music_dir.get_next()
		while true:
			name = music_dir.get_next()
			if !music_dir.current_is_dir():
				if name == "":
					emit_signal("refresh_dir")
					return
				music.append(name)  # adding the file name to the array
	else:
		print("failed to open file")
