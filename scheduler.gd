extends Node

var _schedule_clock: Timer
var _interrupt_clock: Timer
var _threads: Array
var _processors: Array
var _n_available_processors: int
var _curr_index: int = 0
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
	self._end_index = n-1

func start_schedule() -> void:
	self._schedule_clock.start()
	self._interrupt_clock.start()

func stop_schedule() -> void:
	self._schedule_clock.stop()
	self._interrupt_clock.stop()

func schedule_threads() -> void:
	pass

func interrupt_threads() -> void:
	pass
