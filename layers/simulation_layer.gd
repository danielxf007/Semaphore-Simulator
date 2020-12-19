extends Node2D



func _on_Organizer_element_organized(element) -> void:
	self.add_child(element)
