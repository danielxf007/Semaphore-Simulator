extends Sprite
signal wait_executed(thread, sem_id)
signal post_executed(sem_id)
class_name CPU

const WAIT: String = ".wait()"
const POST: String = ".post()"
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
			var content: String = self._instruction.get_content()
			var w_index: int = content.find(self.WAIT)
			var p_index: int = content.find(self.POST)
			if w_index != -1:
				self.emit_signal("wait_executed", self._thread,
				content.substr(0, w_index))
			elif p_index != -1:
				self.emit_signal("post_executed", content.substr(0, p_index))
			self._thread.increment_PC()
		self._clock.start()
	else:
		self.clear()
