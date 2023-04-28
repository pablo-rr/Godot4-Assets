@icon("res://Addons/HealthSystem/Icons/Health.svg")
class_name HealthSystem
extends Node

signal healed(ammount : int)
signal fully_healed
signal damaged(ammount : int)
signal fatally_damaged
signal health_changed(new_health : int)

@export_range(1, 1000000) var max_health : int = 100:
	get:
		return max_health

@onready var health = max_health:
	get:
		return health
	set(ammount):
		health = ammount
		emit_signal("healed", ammount)
		emit_signal("health_changed", health)
		fix_excedent_health()

func fix_excedent_health() -> void:
	if(health < 0):
		health = 0
		emit_signal("fully_healed")
		emit_signal("health_changed", health)
	elif(health > max_health):
		health = max_health
		emit_signal("fatally_damaged")
		emit_signal("health_changed", health)
		
func heal(ammount : int) -> void:
	health += ammount
	emit_signal("healed", ammount)
	emit_signal("health_changed", health)
	fix_excedent_health()
	
func damage(ammount : int) -> void:
	health -= ammount
	emit_signal("damaged", ammount)
	emit_signal("health_changed", health)
	fix_excedent_health()
	
func fully_heal() -> void:
	var health_healed : int = max_health - health
	health = max_health
	emit_signal("healed", health_healed)
	emit_signal("health_changed", health)
	emit_signal("fully_healed")
	
func fatally_damage() -> void:
	var health_damaged : int = health
	health = 0
	emit_signal("damaged", health_damaged)
	emit_signal("health_changed", health)
	emit_signal("fatally_damaged")
