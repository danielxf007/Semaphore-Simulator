extends Node2D
signal processor_created(processor)
signal sem_created(sem)
const EMPTY_MESSAGE: String = ""
export(float) var CYCLE_TIME: float
export(int) var N_CYCLES: int
export(Dictionary) var TEXTURES: Dictionary
var err_messages: Dictionary = {"empty_fields": "Fill all the fields",
"same_name": "Name is already used", "sem_value": "Invalid Semaphore Value"}
var creations_messages: Dictionary = {"processor": "Processor Created",
"sem": "Semaphore Created", "thread": "Thread Created"}
var text_fields: Dictionary
var label_messages: Dictionary
var processors: Array
var semaphores: Array
var threads: Array

func _ready():
	self.text_fields = {"processor_name": $ProcessorName, "sem_name": $SemName,
	"thread_name": $ThreadName, "sem_value": $SemValue,
	"instructions": $Instructions}
	self.label_messages = {"processor_message": $ProcessorMessage,
	"sem_message": $SemMessage, "thread_message": $InstructionMessage}
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
	var _name: String = self.text_fields["processor_name"].text
	if not _name:
		self.label_messages["processor_message"].text = self.err_messages["empty_fields"]
	elif self.is_name_already_used(self.processors, _name):
		self.label_messages["processor_message"].text = self.err_messages["same_name"]
	else:
		var processor: CPU = CPU.new()
		processor.init(_name, self.CYCLE_TIME)
		processor.texture = self.TEXTURES["cpu"]
		self.processors.append(processor)
		self.emit_signal("processor_created", processor)
		self.label_messages["processor_message"].text = self.creations_messages["processor"]
		self.text_fields["processor_name"].text = self.EMPTY_MESSAGE
	$ProcessorTimer.start()


func _on_CreateSem_button_down():
	var _name: String = self.text_fields["sem_name"].text
	var _value: String = self.text_fields["sem_value"].text
	var _sem_value: int = int(_value)
	if not _name or not _value:
		self.label_messages["sem_message"].text = self.err_messages["empty_fields"]
	elif self.is_name_already_used(self.semaphores, _name):
		self.label_messages["sem_message"].text = self.err_messages["same_name"]
	elif not _sem_value:
		self.label_messages["sem_message"].text = self.err_messages["sem_value"]
	else:
		var sem: SimuSemaphore = SimuSemaphore.new()
		sem.init(_name, _sem_value)
		sem.texture = self.TEXTURES["sem"]
		self.semaphores.append(sem)
		self.emit_signal("sem_created", sem)
		self.label_messages["sem_message"].text = self.creations_messages["sem"]
		self.text_fields["sem_name"].text = self.EMPTY_MESSAGE
		self.text_fields["sem_value"].text = self.EMPTY_MESSAGE
	$SemTimer.start()

func create_instructions(instructions: Array) -> Array:
	var elements: Array = []
	var instruction: Instruction
	for inst in instructions:
		instruction = Instruction.new()
		instruction.init(inst, self.N_CYCLES)
		elements.append(instruction)
	return elements
	
func _on_CreateInstructions_button_down():
	var _name: String = self.text_fields["thread_name"].text
	var _instructions: String = self.text_fields["instructions"].text
	if not _name or not _instructions:
		self.label_messages["thread_message"].text = self.err_messages["empty_fields"]
	elif self.is_name_already_used(self.threads, _name):
		self.label_messages["thread_message"].text = self.err_messages["same_name"]
	else:
		var instructions: Array = Array(_instructions.split("\n"))
		var thread: SimuThread = SimuThread.new()
		var thread_instructions: Array = self.create_instructions(instructions)
		thread.init(_name, thread_instructions)
		self.threads.append(thread)
		self.label_messages["thread_message"].text = self.creations_messages["thread"]
		self.text_fields["thread_name"].text = self.EMPTY_MESSAGE
		self.text_fields["instructions"].text = self.EMPTY_MESSAGE
	$ThreadTimer.start()


func _on_ProcessorTimer_timeout():
	self.label_messages["processor_message"].text = self.EMPTY_MESSAGE

func _on_SemTimer_timeout():
	self.label_messages["sem_message"].text = self.EMPTY_MESSAGE

func _on_ThreadTimer_timeout():
	self.label_messages["thread_message"].text = self.EMPTY_MESSAGE
