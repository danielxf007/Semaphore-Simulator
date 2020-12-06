extends Object

class_name Instruction

var _content: String
var _exec_time: float

func _init(content: String, exec_time: float) -> void:
	self._content = content
	self._exec_time = exec_time

func get_content() -> String:
	return self._content

func get_exec_time() -> float:
	return self._exec_time

func set_exec_time(exec_time: float) -> void:
	self._exec_time = exec_time

func destroy() -> void:
	self.free()
