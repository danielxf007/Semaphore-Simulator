extends Node

signal timer_finished()
const _INTERRUPT_TIME: float = 3.0
var _interrupt_timer: Timer
var _threads: Array
var _processors: Array
var _curr_processors_available: int
var _random_generator: RandomNumberGenerator

func _ready():
	self._threads = []
	self._processors = []
	self._curr_processors_available = 0
	self._interrupt_timer = Timer.new()
	self._interrupt_timer.wait_time = self._INTERRUPT_TIME
	self._interrupt_timer.one_shot = true
	self._interrupt_timer.paused = false
	self.add_child(self._interrupt_timer)
# warning-ignore:return_value_discarded
	self._interrupt_timer.connect("timeout", self, "_on_InterruptTimer_timeout")
	self._random_generator = RandomNumberGenerator.new()

func play() -> void:
	if self._interrupt_timer.paused:
		self._interrupt_timer.paused = false
	elif not self.all_threads_finished():
		self.schedule_threads()
		self._interrupt_timer.start()

func pause() -> void:
	self._interrupt_timer.paused = true

func add_thread(thread: SimuThread) -> void:
	self._threads.append(thread)

func get_current_thread() -> SimuThread:
	return self._threads[self._curr_index]

func all_threads_finished() -> bool:
	var finished: bool = true
	for thread in self._threads:
		if not thread.has_finished():
			finished = false
			break
	return finished

func add_processor(processor: CPU) -> void:
	self._processors.append(processor)
	self._curr_processors_available += 1

func schedule_threads() -> void:
	for processor in self._processors:
		for thread in self._threads:
			if thread.can_be_executed():
				processor.set_thread(thread)
				self.decrement_curr_n_processors_available()
				break

func decrement_curr_n_processors_available() -> void:
	self._curr_processors_available -= 1

func reset() -> void:
	self._interrupt_timer.stop()
	self._curr_processors_available = self._processors.size()

func clear() -> void:
	self._interrupt_timer.stop()
	self._threads.clear()
	self._processors.clear()
	self._curr_processors_available = 0

func random_sort_list(list: Array) -> Array:
	var new_list: Array = []
	var _list: Array = list.duplicate()
	var index: int
	while _list:
		index = self._random_generator.randi()%_list.size()
		new_list.append(_list[index])
		_list.remove(index)
	return new_list

func increment_curr_n_processors_available() -> void:
	self._curr_processors_available += 1
	if self._curr_processors_available == self._processors.size():
		self._threads = self.random_sort_list(self._threads)
		self.play()

func _on_InterruptTimer_timeout():
	self.emit_signal("timer_finished")
