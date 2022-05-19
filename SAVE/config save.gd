extends Node

var config = ConfigFile.new()
var config_path = "user://config"

func save_value(section: String, key: String, value):
	config.set_value(section,key,value)
	config.save(config_path)

func load_value(section: String, key: String, defualt):
	var err = config.load(config_path)
	if err != OK:
		return defualt
	return config.get_value(section,key,defualt)
