@icon("res://Addons/Functionality/help.svg")
class_name Functionality
extends Node

static func get_first_node_of_class(node : Node, class_find : String) -> Node:
	print(class_find)
	for child in node.get_children():
		print(child.get_class())
		if(child.is_class(class_find)):
			return child
			
	return null
	
static func get_nodes_of_class(node : Node, class_find : String) -> Array:
	var nodes : Array = []
	for child in node.get_children():
		if(child.is_class(class_find)):
			nodes.append(child)
			
	return nodes
