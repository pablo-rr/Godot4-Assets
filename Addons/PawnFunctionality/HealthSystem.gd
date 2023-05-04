@icon("res://Addons/PawnFunctionality/Icons/Health.svg")
class_name HealthSystem
extends Node

signal healed(ammount : int)
signal fully_healed
signal damaged(ammount : int)
signal fatally_damaged
signal health_changed(new_health : int)

@export_category("Health")
@export_range(1, 1000000) var max_health : int = 100
@export_category("Invulnerability")
@export var invulnerable_on_damage : bool = false
@export var heal_when_invulnerable : bool = true
@export var invulnerability_time : float = 0.111
@export_category("Blinking")
@export var blink_node : Node2D
@export var hit_blinks : int = 5
@export var blink_time : float = 0.1
@export var invulnerable_while_blinking : bool = true

@onready var health : int = max_health
@onready var invulnerable : bool = false
@onready var blinking : bool = false
@onready var time_since_invulnerable : float = invulnerability_time

func _process(delta: float) -> void:
	time_since_invulnerable += delta
	if(time_since_invulnerable >= invulnerability_time and !invulnerable_while_blinking):
		invulnerable = false
	
	if(invulnerable_while_blinking and blinking):
		invulnerable = true

func blink() -> void:
	blinking = true
	for i in range(0, hit_blinks * 2):
		blink_node.visible = false
		await(get_tree().create_timer(blink_time / 2).timeout)
		blink_node.visible = true
		await(get_tree().create_timer(blink_time / 2).timeout)
		
	blinking = false
	invulnerable = false

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
	if((heal_when_invulnerable and invulnerable) or !invulnerable):
		health += ammount
		emit_signal("healed", ammount)
		emit_signal("health_changed", health)
		fix_excedent_health()
	
func damage(ammount : int) -> void:
	if(!invulnerable):
		health -= ammount
		blink()
		if(invulnerable_on_damage and !invulnerable_while_blinking):
			time_since_invulnerable = 0.0
			invulnerable = true
		emit_signal("damaged", ammount)
		emit_signal("health_changed", health)
		fix_excedent_health()
	
func fully_heal() -> void:
	if((heal_when_invulnerable and invulnerable) or !invulnerable):
		var health_healed : int = max_health - health
		health = max_health
		emit_signal("healed", health_healed)
		emit_signal("health_changed", health)
		emit_signal("fully_healed")
	
func fatally_damage() -> void:
	if(!invulnerable):
		var health_damaged : int = health
		health = 0
		emit_signal("damaged", health_damaged)
		emit_signal("health_changed", health)
		emit_signal("fatally_damaged")
