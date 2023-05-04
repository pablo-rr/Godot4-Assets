@icon("res://Addons/PawnFunctionality/Icons/jumping-rope.svg")
class_name StaminaSystem
extends Node

signal restored(ammount : int)
signal fully_restored
signal wasted(ammount : int)
signal totally_wasted
signal stamina_changed(new_stamina : int)

@export_range(1, 1000000) var max_stamina : int = 100
@export_range(0.1, 10) var time_to_regen : float = 2.0
@export_range(0.1, 5000) var regen_interval : float = 20.0
@export_range(0.1, 5000) var waste_interval : float = 40.0
@onready var stamina : float = max_stamina
@onready var time_since_waste : float = time_to_regen

func _process(delta: float) -> void:
	time_since_waste += delta
	if(time_since_waste >= time_to_regen):
		regen(delta)

func fix_excedent_stamina() -> void:
	if(stamina < 0):
		stamina = 0
		emit_signal("fully_restored")
		emit_signal("stamina_changed", stamina)
	elif(stamina > max_stamina):
		stamina = max_stamina
		emit_signal("totally_wasted")
		emit_signal("stamina_changed", stamina)
		
func regen(delta : float) -> void:
	stamina += delta * regen_interval
	emit_signal("restored", delta * regen_interval)
	emit_signal("stamina_changed", stamina)
	fix_excedent_stamina()
	
func waste(delta : float) -> void:
	stamina -= delta * waste_interval
	time_since_waste = 0.0
	emit_signal("wasted", delta * waste_interval)
	emit_signal("stamina_changed", stamina)
	fix_excedent_stamina()
	
func fully_regen() -> void:
	var stamina_restored : int = max_stamina - stamina
	stamina = max_stamina
	emit_signal("restored", stamina_restored)
	emit_signal("stamina_changed", stamina)
	emit_signal("fully_restored")
	
func totally_waste() -> void:
	var stamina_wasted : int = stamina
	stamina = 0
	time_since_waste = 0.0
	emit_signal("wasted", stamina_wasted)
	emit_signal("stamina_changed", stamina)
	emit_signal("totally_wasted")
