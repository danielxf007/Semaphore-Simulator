extends Object

class_name SimuThread

const ZERO: int = 0
var _id: String
var _instructions: Array
var _curr_instruction: int

func _init(id: String, instructions: Array) -> void:
	self._id = id
	self._instructions = instructions
	self._curr_instruction = self.ZERO

func get_curr_instruction() -> Instruction:
	return self._instructions[self._curr_instruction]

func increment_curr_instruction() -> void:
	self._curr_instruction += 1

func reset() -> void:
	self._curr_instruction = self.ZERO

func has_finished() -> bool:
	return self._curr_instruction == self._instructions.size()

func destroy() -> void:
	for instruction in self._instructions:
		instruction.destroy()
	self.free()
