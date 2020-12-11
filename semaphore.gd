extends Sprite
class_name SimuSemaphore

const ZERO:int = 0
var _id: String
var _value: int
var _threads: Array

func init(id: String, value: int) -> void:
	self._id = id
	self._value = value
	self._threads = []

func get_id() -> String:
	return self._id

func wait(simu_thread: SimuThread) -> void:
	self._value -= 1
	if self._value < self.ZERO:
		simu_thread.set_active(false)
		self._threads.append(simu_thread)

func post() -> void:
	self._value += 1
	if not self._threads.empty():
		var thread: SimuThread =  self._threads.pop_front()
		thread.set_active(true)

func destroy() -> void:
	self.free()
