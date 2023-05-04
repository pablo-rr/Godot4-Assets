@icon("res://Addons/PawnFunctionality/Icons/progression.svg")
class_name PawnTextureProgressBar
extends TextureProgressBar

enum AnimationStyles{
	BACK = Tween.TRANS_BACK
	,BOUNCE = Tween.TRANS_BOUNCE
	,CIRC = Tween.TRANS_CIRC
	,CUBIC = Tween.TRANS_CUBIC
	,ELASTIC = Tween.TRANS_ELASTIC
	,LINEAR = Tween.TRANS_LINEAR
	,QUAD = Tween.TRANS_QUAD
	,QUART = Tween.TRANS_QUART
	,QUINT = Tween.TRANS_QUINT
	,SINE = Tween.TRANS_SINE
}

enum AnimationEases{
	IN = Tween.EASE_IN
	,OUT = Tween.EASE_OUT
	,IN_OUT = Tween.EASE_IN_OUT
	,OUT_IN = Tween.EASE_OUT_IN
}

@export_category("Progress")
@export var progress_node : Node
@export_enum("Health", "Stamina") var progress_type : String = "Health"
@export_category("Animation")
@export var animation_time : float = 0.3
@export var yield_before_animation : float = 0.0
@export var animation_style : int = AnimationStyles.LINEAR
@export var animation_easing : int = AnimationEases.OUT_IN

var progress_system

func _ready() -> void:
	if(progress_node is HealthSystem or progress_node is StaminaSystem):
		progress_system = progress_node
	else:
		if(progress_type == "Health"):
			progress_system = get_health_system(progress_node)
		elif(progress_type == "Stamina"):
			progress_system = get_stamina_system(progress_node)
			
	min_value = 0
	if(progress_type == "Health"):
		max_value = progress_system.max_health
		value = progress_system.max_health
		progress_system.health_changed.connect(Callable(self, "update_progress_bar"))
	elif(progress_type == "Stamina"):
		max_value = progress_system.max_stamina
		value = progress_system.max_stamina
		progress_system.stamina_changed.connect(Callable(self, "update_progress_bar"))

func get_health_system(node : Node):
	for child in node.get_children():
		if(child is HealthSystem):
			return child
	
	return null
	
func get_stamina_system(node : Node):
	for child in node.get_children():
		print(child is StaminaSystem)
		if(child is StaminaSystem):
			return child
	
	return null

func update_progress_bar(new_health : int):
	await(get_tree().create_timer(yield_before_animation).timeout)
	var tween : Tween = get_tree().create_tween()
	tween.set_ease(animation_easing)
	tween.set_trans(animation_style)
	tween.tween_property(self, "value", new_health, animation_time)
