extends Sprite

class_name CPU

var _clock: Timer
var _thread: SimuThread
var _instruction: Instruction

func init(wait_time: float) -> void:
	self._clock = Timer.new()
	self._clock.wait_time = wait_time
	self._clock.one_shot = true
	self.add_child(self._clock)
# warning-ignore:return_value_discarded
	self._clock.connect("timeout", self, "process_thread")

func set_thread(thread: SimuThread) -> void:
	self._thread = thread

func play() -> void:
	self._clock.start()

func pause() -> void:
	self._clock.stop()

func clear() -> void:
	self._clock.stop()
	self._thread = null

func is_available() -> bool:
	return not self._thread

func process_thread() -> void:
	if not self._thread.has_finished():
		self._instruction = self._thread.get_instruction()
		self._instruction.increment_curr_exec_clock_cycles()
		if self._instruction.has_been_executed():
			self._thread.increment_PC()
		self._clock.start()
	else:
		self.clear()
