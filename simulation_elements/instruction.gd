extends Object

class_name Instruction

const ZERO: int = 0
var _content: String
var _exec_clock_cycles: int
var _curr_clock_cycles: int

func init(content: String, exec_clock_cycles: int) -> void:
	self._content = content
	self._exec_clock_cycles = exec_clock_cycles
	self._curr_clock_cycles = self.ZERO

func get_content() -> String:
	return self._content

func increment_curr_exec_clock_cycles() -> void:
	self._curr_clock_cycles += 1

func get_percentage() -> float:
	return (float(self._curr_clock_cycles)/float(self._exec_clock_cycles))*100

func reset() -> void:
	self._curr_clock_cycles = self.ZERO

func has_been_executed() -> bool:
	return self._exec_clock_cycles == self._curr_clock_cycles

func destroy() -> void:
	self.free()
