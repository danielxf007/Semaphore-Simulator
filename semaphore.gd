extends Sprite
signal thread_slept(simu_thread)
signal thread_awakened(simu_thread)
class_name SimuSemaphore

const ZERO:int = 0
var _id: String
var _value: int
var _threads: Array

func init(id: String, value: int) -> void:
	self._id = id
	self._value = value
	self._threads = []

func wait(simu_thread: SimuThread) -> void:
	self._value -= 1
	if self._value < self.ZERO:
		self.emit_signal("thread_slept", simu_thread)
		self._threads.append(simu_thread)

func post() -> void:
	self._value += 1
	if not self._threads.empty():
		self.emit_signal("thread_awakened", self._threads.pop_front())

func destroy() -> void:
	self.free()
