@icon("res://Addons/HealthSystem/Icons/HealthControl.svg")
class_name ProgressBarHealthSystem
extends ProgressBar

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

@export var progress_node : Node
@export_category("Animation")
@export var animation_time : float = 0.3
@export var yield_before_animation : float = 0.0
@export var animation_style : int = AnimationStyles.LINEAR
@export var animation_easing : int = AnimationEases.OUT_IN

var health_system

func _ready() -> void:
	if(progress_node.is_class("ProgressBarHealthSystem")):
		health_system = progress_node
	else:
		health_system = get_health_system(progress_node)
	
	min_value = 0
	max_value = health_system.max_health
	value = health_system.health
	health_system.health_changed.connect(Callable(self, "update_progress_bar"))

func get_health_system(node : Node):
	for child in node.get_children():
		if(child is HealthSystem):
			return child
	
	return null

func update_progress_bar(new_health : int):
	await(get_tree().create_timer(yield_before_animation).timeout)
	var tween : Tween = get_tree().create_tween()
	tween.set_ease(animation_easing)
	tween.set_trans(animation_style)
	tween.tween_property(self, "value", new_health, animation_time)
