extends Sprite
class_name SimuSemaphore

const ZERO:int = 0
const VALUE: String = "Value: "
var _id: String
var _init_value: int
var _value: int
var _threads: Array
var _up_label: Label
var _down_label: Label

func init(id: String, value: int) -> void:
	self._id = id
	self._init_value = value
	self._value = value
	self._threads = []

func get_id() -> String:
	return self._id

func get_value() -> int:
	return self._value

func wait(simu_thread: SimuThread) -> void:
	self._value -= 1
	self._down_label.text = self.VALUE + str(self._value)
	if self._value < self.ZERO:
		simu_thread.set_active(false)
		self._threads.append(simu_thread)

func post() -> void:
	self._value += 1
	self._down_label.text = self.VALUE + str(self._value)
	if not self._threads.empty():
		var thread: SimuThread =  self._threads.pop_front()
		thread.set_active(true)

func set_labels(up_label: Label, down_label: Label) -> void:
	self._up_label = up_label
	self._down_label = down_label

func reset() -> void:
	self._value = self._init_value
	self._down_label.text = self.VALUE + str(self._value)

func destroy() -> void:
	self.free()
