extends Object

class_name SimuThread

var _id: String
var _instructions: Array

func _init(id: String, instructions: Array) -> void:
	self._id = id
	self._instructions = instructions

func remove_instruction() -> void:
	self._instructions.pop_front().destroy()

func destroy() -> void:
	self.free()
