extends Node2D
signal processor_created(processor)
signal sem_created(sem)
signal thread_created(thread)
signal creation_finished()
const EMPTY_MESSAGE: String = ""
const MAX_N_CPUS: int = 8
const MAX_N_SEMS: int = 8
export(float) var CYCLE_TIME: float
export(int) var N_CYCLES: int
export(Dictionary) var TEXTURES: Dictionary
var err_messages: Dictionary = {"empty_fields": "Fill all the fields",
"invalid_n_p": "Invalid Number of Processors",
"same_name": "This Name is Already Used",
"sem_value": "Invalid Semaphore Value",
"max_cpu": "Max Number of Processors Created (8)",
"max_sem": "Max Number of Semaphores Created (8)",
"create_p": "You Must Create at Least One Processor",
"create_s": "You Must Create at Least One Semaphore",
"create_t": "You Must Create at Least One Thread"}
var creations_messages: Dictionary = {"processor": "Processors Created",
"sem": "Semaphore Created", "thread": "Thread Created"}
var text_fields: Dictionary
var label_messages: Dictionary
var semaphores: Array
var threads: Array
var _curr_n_cpus: int
var _curr_n_sems: int

func _ready():
	self.text_fields = {"processor_name": $ProcessorName, "sem_name": $SemName,
	"thread_name": $ThreadName, "sem_value": $SemValue,
	"instructions": $Instructions}
	self.label_messages = {"processor_message": $ProcessorMessage,
	"sem_message": $SemMessage, "thread_message": $InstructionMessage}
	self.semaphores = []
	self.threads = []
	self._curr_n_cpus = 0
	self._curr_n_sems = 0

func is_name_already_used(elements: Array, _name: String) -> bool:
	var already_used = false
	for element in elements:
		if element.get_id() == _name:
			already_used = true
			break
	return already_used

func _on_CreateProcessor_button_down():
	var n: int = self.MAX_N_CPUS - self._curr_n_cpus
	if n:
		var _n_processors_str: String = self.text_fields["processor_name"].text
		var _n_processors: int = int(_n_processors_str)
		if not _n_processors_str and _n_processors_str != "0":
			self.label_messages["processor_message"].text = self.err_messages["empty_fields"]
		elif not _n_processors:
			self.label_messages["processor_message"].text = self.err_messages["invalid_n_p"]
		else:
			if n > _n_processors:
				n = _n_processors
			for _i in range(n):
				var processor: CPU = CPU.new()
				processor.init(self.CYCLE_TIME)
				processor.texture = self.TEXTURES["cpu"]
				self.emit_signal("processor_created", processor)
			self._curr_n_cpus += n
			self.label_messages["processor_message"].text = self.creations_messages["processor"]
			self.text_fields["processor_name"].text = self.EMPTY_MESSAGE
		$ProcessorTimer.start()
	else:
		$AcceptDialog.dialog_text = self.err_messages["max_cpu"]
		$AcceptDialog.popup_centered()


func _on_CreateSem_button_down():
	var n: int = self.MAX_N_SEMS - self._curr_n_sems
	if n:
		var _name: String = self.text_fields["sem_name"].text
		var _value: String = self.text_fields["sem_value"].text
		var _sem_value: int = int(_value)
		if _name.empty() or _value.empty():
			self.label_messages["sem_message"].text = self.err_messages["empty_fields"]
		elif self.is_name_already_used(self.semaphores, _name):
			self.label_messages["sem_message"].text = self.err_messages["same_name"]
		elif not _sem_value and _value != "0":
			self.label_messages["sem_message"].text = self.err_messages["sem_value"]
		else:
			var sem: SimuSemaphore = SimuSemaphore.new()
			sem.init(_name, _sem_value)
			sem.texture = self.TEXTURES["sem"]
			self.semaphores.append(sem)
			self.emit_signal("sem_created", sem)
			self.label_messages["sem_message"].text = self.creations_messages["sem"]
			self._curr_n_sems += 1
			self.text_fields["sem_name"].text = self.EMPTY_MESSAGE
			self.text_fields["sem_value"].text = self.EMPTY_MESSAGE
		$SemTimer.start()
	else:
		$AcceptDialog.dialog_text = self.err_messages["max_sem"]
		$AcceptDialog.popup_centered()

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
		self.emit_signal("thread_created", thread)
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

func reset() -> void:
	self.semaphores.clear()
	self.threads.clear()
	self._curr_n_cpus = 0
	self._curr_n_sems = 0

func _on_Button_button_down():
	if not self._curr_n_cpus:
		$AcceptDialog.dialog_text = self.err_messages["create_p"]
		$AcceptDialog.popup_centered()
	elif not self._curr_n_sems:
		$AcceptDialog.dialog_text = self.err_messages["create_s"]
		$AcceptDialog.popup_centered()
	elif self.threads.empty():
		$AcceptDialog.dialog_text = self.err_messages["create_t"]
		$AcceptDialog.popup_centered()
	else:
		self.hide()
		self.emit_signal("creation_finished")
		self.reset()
