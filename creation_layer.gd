extends Node2D
signal processor_created(processor)
signal sem_created(sem)
const EMPTY_MESSAGE: String = ""
const PROCESSOR_CREATED: String = "Processor Created"
const SEM_CREATED: String = "Semaphore Created"
const THREAD_CREATED: String = "Thread Created"
const ERR_FILL_MESSAGE: String = "Fill all the fields"
const ERR_SAME_NAME: String = "Name already used"
const ERR_INVALID_CYCLE_TIME: String = "Invalid Cycle Time"
var processor_name: TextEdit
var sem_name: TextEdit
var thread_name: TextEdit
var clock_cycles: TextEdit
var sem_value: TextEdit
var instructions: TextEdit
var processor_message: Label
var sem_message: Label
var instruction_message: Label
var processors: Array
var semaphores: Array
var threads: Array

func _ready():
	self.processor_name = $ProcessorName
	self.sem_name = $SemName
	self.thread_name = $ThreadName
	self.clock_cycles = $ClockCycles
	self.sem_value = $SemValue
	self.instructions = $Instructions
	self.processor_message = $ProcessorMessage
	self.sem_message = $SemMessage
	self.instruction_message = $InstructionMessage
	self.processors = []
	self.semaphores = []
	self.threads = []

func is_name_already_used(elements: Array, _name: String) -> bool:
	var already_used = false
	for element in elements:
		if element.get_id() == _name:
			already_used = true
			break
	return already_used

func _on_CreateProcessor_button_down():
	var _name: String = self.processor_name.text
	var _clock_cycles: String = self.clock_cycles.text
	var wait_time: float = float(_clock_cycles)
	if not _name or not _clock_cycles:
		self.processor_message.text = self.ERR_FILL_MESSAGE
	elif self.is_name_already_used(self.processors, _name):
		self.processor_message.text = self.ERR_SAME_NAME
	elif not wait_time:
		self.processor_message.text = self.ERR_INVALID_CYCLE_TIME
	else:
		var processor: CPU = CPU.new()
		processor.init(_name, wait_time)
		self.processors.append(processor)
		self.emit_signal("processor_created", processor)
		self.processor_message.text = self.PROCESSOR_CREATED
		self.processor_name.text = self.EMPTY_MESSAGE
		self.clock_cycles.text = self.EMPTY_MESSAGE
	$ProcessorTimer.start()


func _on_CreateSem_button_down():
	pass # Replace with function body.


func _on_CreateInstructions_button_down():
	pass # Replace with function body.



func _on_ProcessorTimer_timeout():
	self.processor_message.text = self.EMPTY_MESSAGE


func _on_SemTimer_timeout():
	self.sem_message.text = self.EMPTY_MESSAGE


func _on_ThreadTimer_timeout():
	self.instruction_message.text = self.EMPTY_MESSAGE
