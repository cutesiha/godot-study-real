extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var label_node = Label.new()
	label_node.text = "welcome GODOT"
	$UI.add_child(label_node)
