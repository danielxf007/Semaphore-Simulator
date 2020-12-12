extends Object

class_name SimuThread

const ZERO: int = 0
var _id: String
var _instructions: Array
var _PC: int
var _active: bool

func init(id: String, instructions: Array) -> void:
	self._id = id
	self._instructions = instructions
	self._PC = self.ZERO
	self._active = true

func get_id() -> String:
	return self._id

func set_active(value: bool) -> void:
	self._active = value

func is_active() -> bool:
	return self._active

func get_instruction() -> Instruction:
	return self._instructions[self._PC]

func increment_PC() -> void:
	self._PC += 1

func reset() -> void:
	self._PC = self.ZERO

func has_finished() -> bool:
	return self._PC == self._instructions.size()

func destroy() -> void:
	for instruction in self._instructions:
		instruction.destroy()
	self.free()
