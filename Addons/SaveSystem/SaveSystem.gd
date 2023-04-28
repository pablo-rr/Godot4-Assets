@icon("res://Addons/SaveSystem/save.svg")
class_name SaveSystem
extends Node

## Class to save and load resources used as save and config files.
## 
## The resources can be changed to new ones in the const values 'SAVE_FILE' and 'CONFIG_FILE'.

## The default save file included in this package. You can specify your own save file, or modify the
## default one.
const SAVE_FILE : String = "mgsave.tres"

## The default config file included in this package. You can specify your own save file, or modify
## the default one.
const CONFIG_FILE : String = "mgconf.tres"

## All the functions using this one have it set up as 'from_resources = false' to save and load
## files directly to the user data instead of the project resources.
##
## Add the parameter 'from_resources = true' in any of the save or load functions to save and load
## to the project's files.
static func get_file_path(from_resources : bool) -> String:
	if(from_resources):
		return "res://"
	else:
		return "user://"


## This function saves the 'save' [Resource] as the SAVE_FILE. The passed resource must have been
## previously loaded.
static func save_game(save : Resource, from_resources : bool = false) -> Error:
	var path : String = get_file_path(from_resources)
	var result : Error = ResourceSaver.save(save, path + SAVE_FILE)
	return result
	
	
## This function saves the 'save' [Resource] as the CONFIG_FILE. The passed resource must have been
## previously loaded.
static func save_config(config : Resource, from_resources : bool = false) -> Error:
	var path : String = get_file_path(from_resources)
	var result : Error = ResourceSaver.save(config, path + CONFIG_FILE)
	return result
	
	
static func load_game(from_resources : bool = false) -> Resource:
	var path : String = get_file_path(from_resources)
	
	if(ResourceLoader.exists(path + SAVE_FILE)):
		var save_res : Resource = ResourceLoader.load(path + SAVE_FILE)
		if(save_res is SaveFile):
			return save_res
		
	return null
	
	
static func load_config(from_resources : bool = false) -> Resource:
	var path : String = get_file_path(from_resources)
	
	if(ResourceLoader.exists(path + CONFIG_FILE)):
		var config_res : Resource = ResourceLoader.load(path + CONFIG_FILE)
		if(config_res is ConfigurationFile):
			return config_res
	
	return null
