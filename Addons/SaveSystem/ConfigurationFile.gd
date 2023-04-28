@icon("res://Addons/SaveSystem/cog.svg")
class_name ConfigurationFile
extends Resource

# Screen values
@export var screen_resolution : Vector2 = Vector2(1280, 720)
@export var fullscreen : bool = false

# Volume values
@export var db_general : float = 0.0
@export var db_music : float = 0.0
@export var db_effects : float = 0.0
