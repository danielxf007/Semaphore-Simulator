extends Object

class_name SimuThread

const ZERO: int = 0
var _id: String
var _instructions: Array
var _PC: int
var _active: bool
var _running: bool

func init(id: String, instructions: Array) -> void:
	self._id = id
	self._instructions = instructions
	self._PC = self.ZERO
	self._active = true
	self._running = false

func get_id() -> String:
	return self._id

func set_active(value: bool) -> void:
	self._active = value

func set_running(value: bool) -> void:
	self._running = value

func has_finished() -> bool:
	return self._PC == self._instructions.size()

func can_be_executed() -> bool:
	return not self.has_finished() and not self._running and self._active

func get_instruction() -> Instruction:
	return self._instructions[self._PC]

func increment_PC() -> void:
	self._PC += 1

func reset() -> void:
	for instruction in self._instructions:
		instruction.reset()
	self._PC = self.ZERO
	self._running = false
	self._active = true

func destroy() -> void:
	for instruction in self._instructions:
		instruction.destroy()
	self.free()
