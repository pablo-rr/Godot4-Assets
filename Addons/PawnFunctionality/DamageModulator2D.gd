@icon("res://Addons/PawnFunctionality/Icons/punch-blast.svg")
class_name DamageModulator2D
extends GPUParticles2D

@export_category("Nodes")
@export var health_system : HealthSystem
@export var node_to_modulate : Node2D
@export_category("Modulation")
@export var modulation : Color = Color(Color.RED)
@export_subgroup("Modulation time")
@export var sync_with_invulnerability : bool = false
@export var sync_with_blinking : bool = false
@export var max_modulation_time : float = 0.15

@onready var modulation_time : float = 0.0

func _ready() -> void:
	health_system.connect("damaged", Callable(func(ammount : int) -> void: modulation_time = max_modulation_time))
	emitting = false
	
func _process(delta: float) -> void:
	if(!sync_with_invulnerability and !sync_with_blinking):
		modulation_time -= delta
		if(modulation_time <= 0.0):
			node_to_modulate.modulate = Color(1, 1, 1)
			emitting = true
		else:
			node_to_modulate.modulate = modulation
			emitting = false
	elif(sync_with_blinking):
		if(health_system.blinking):
			node_to_modulate.modulate = modulation
		else:
			node_to_modulate.modulate = Color(1, 1, 1)
	elif(sync_with_invulnerability):
		if(health_system.invulnerable):
			node_to_modulate.modulate = modulation
		else:
			node_to_modulate.modulate = Color(1, 1, 1)
