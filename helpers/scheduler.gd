extends Node

var _schedule_clock: Timer
var _interrupt_clock: Timer
var _threads: Array
var _processors: Array
var _n_available_processors: int
var _curr_index: int
var _end_index: int

func set_schedule_clock(schedule_clock: Timer) -> void:
	self._schedule_clock = schedule_clock
	self.add_child(self._schedule_clock)
# warning-ignore:return_value_discarded
	self._schedule_clock.connect("timeout", self, "schedule_threads")

func set_interrupt_clock(interrupt_clock: Timer) -> void:
	self._interrupt_clock = interrupt_clock
	self.add_child(self._interrupt_clock)
# warning-ignore:return_value_discarded
	self._interrupt_clock.connect("timeout", self, "interrupt_threads")

func set_threads(threads: Array) -> void:
	self._threads = threads

func set_processors(processors: Array) -> void:
	self._processors = processors

func set_n_available_processors(n: int) -> void:
	self._n_available_processors = n

func set_curr_index(value: int) -> void:
	self._curr_index = value

func set_end_index(value: int) -> void:
	self._end_index = value

func start_schedule() -> void:
	self._schedule_clock.start()
	self._interrupt_clock.start()

func stop_schedule() -> void:
	self._schedule_clock.stop()
	self._interrupt_clock.stop()

func get_available_processor() -> CPU:
	var available_processor: CPU = null
	for cpu in self._processors:
		if cpu.is_available():
			available_processor = cpu
			break
	return available_processor

func schedule_threads() -> void:
	var thread: SimuThread
	var processor: CPU
	for index in range(self._curr_index, self._end_index+1):
		thread = self._threads[index]
		if thread.is_active():
			processor = self.get_available_processor()
			if processor:
				processor.set_thread(thread)
				processor.play()
	self._schedule_clock.start()

func update_curr_index() -> void:
	self._curr_index = self._end_index+1
	self._curr_index %= self._threads.size()

func update_end_index() -> void:
	self._end_index = self._curr_index + self._n_available_processors
	self._end_index %= self._threads.size()

func clear_processors() -> void:
	for cpu in self._processors:
		cpu.clear()

func interrupt_threads() -> void:
	self._schedule_clock.paused = true
	self.update_curr_index()
	self.update_end_index()
	self.clear_processors()
	self._schedule_clock.start()
	self._schedule_clock.paused = false
	self._interrupt_clock.start()
