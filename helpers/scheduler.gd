extends Node

signal timer_finished()
signal played()
const _INTERRUPT_TIME: float = 2.5
var _interrupt_timer: Timer
var _threads: Array
var _curr_index: int
var _n_processors_available: int
var _curr_processors_available: int

func _ready():
	self._threads = []
	self._curr_index = 0
	self._n_processors_available = 0
	self._curr_processors_available = 0
	self._interrupt_timer = Timer.new()
	self._interrupt_timer.wait_time = self._INTERRUPT_TIME
	self._interrupt_timer.one_shot = true
	self.add_child(self._interrupt_timer)
# warning-ignore:return_value_discarded
	self._interrupt_timer.connect("timeout", self, "_on_InterruptTimer_timeout")

func play() -> void:
	self._interrupt_timer.start()

func pause() -> void:
	self._interrupt_timer.stop()

func add_thread(thread: SimuThread) -> void:
	self._threads.append(thread)

func add_processor(_processor) -> void:
	self._n_processors_available += 1
	self._curr_processors_available += 1

func schedule_threads(cpu: CPU) -> void:
	var thread: SimuThread = self._threads[self._curr_index]
	if  not thread.has_finished() and not thread.is_active():
		cpu.set_thread(thread)
		self.decrement_curr_n_processors_available()
		self.update_curr_index()
	else:
		self.update_curr_index()

func update_curr_index() -> void:
	self._curr_index += 1
	self._curr_index %= self._threads.size()

func decrement_curr_n_processors_available() -> void:
	self._curr_processors_available -= 1

func reset() -> void:
	self._interrupt_timer.stop()
	self._threads.clear()
	self._curr_index = 0
	self._n_processors_available = 0

func increment_curr_n_processors_available() -> void:
	self._curr_processors_available += 1
	if self._n_processors_available == self._curr_processors_available:
		self.emit_signal("played")
		self._interrupt_timer.start()

func _on_InterruptTimer_timeout():
	self.emit_signal("timer_finished")
