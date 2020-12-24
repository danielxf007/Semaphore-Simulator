extends Node2D

const SEM_UP_LABEL_OFFSET: Vector2 = Vector2(-32, -96)
const SEM_DOWN_LABEL_OFFSET: Vector2 = Vector2(-32, 32)
const SEM_LABEL_DIMENSION: Vector2 = Vector2(64, 64)
const CPU_UP_LABEL_OFFSET: Vector2 = Vector2(-64, -128)
const CPU_DOWN_LABEL_OFFSET: Vector2 = Vector2(-64, 64)
const CPU_MIDDLE_LABEL_OFFSET: Vector2 = Vector2(-27, -27)
const CPU_UP_DOWN_L_DIM: Vector2 = Vector2(128, 64)
const CPU_MIDDLE_L_DIM: Vector2 = Vector2(54, 54)
var _labels: Array
var _cpus: Array
var _sems: Array
var _threads: Array

func _ready():
	self._labels = []
	self._cpus = []
	self._sems = []
	self._threads = []
# warning-ignore:return_value_discarded
	$Play.connect("button_down", Scheduler, "play")
# warning-ignore:return_value_discarded
	$Pause.connect("button_down", Scheduler, "pause")
# warning-ignore:return_value_discarded
	$Reset.connect("button_down", Scheduler, "reset")

func _on_Organizer_cpu_organized(cpu: CPU)->void:
	self.add_child(cpu)
# warning-ignore:return_value_discarded
	Scheduler.connect("timer_finished", cpu, "interrupt")
# warning-ignore:return_value_discarded
	cpu.connect("interrupted", Scheduler, "increment_curr_n_processors_available")
# warning-ignore:return_value_discarded
	$Pause.connect("button_down", cpu, "pause")
# warning-ignore:return_value_discarded
	$Reset.connect("button_down", cpu, "reset")
	var down_l_position: Vector2 = cpu.global_position + self.CPU_DOWN_LABEL_OFFSET
	var middle_l_position: Vector2 = cpu.global_position + self.CPU_MIDDLE_LABEL_OFFSET
	var down_args: Dictionary = {"text": "",
	"align": HALIGN_CENTER, "valign": VALIGN_TOP,
	"size": self.CPU_UP_DOWN_L_DIM, "position": down_l_position}
	var middle_args: Dictionary = {"text": "", "align": HALIGN_CENTER,
	"valign": VALIGN_CENTER, "size": self.CPU_MIDDLE_L_DIM,
	"position": middle_l_position}
	var down_label: Label = self.create_label(down_args)
	var middle_label: Label = self.create_label(middle_args)
	self.add_child(down_label)
	self.add_child(middle_label)
	cpu.set_labels(down_label, middle_label)
	self._labels.append(down_label)
	self._labels.append(middle_label)

func _on_Organizer_sem_organized(sem: SimuSemaphore)->void:
	self.add_child(sem)
	var up_l_position: Vector2 = sem.global_position + self.SEM_UP_LABEL_OFFSET
	var down_l_position: Vector2 = sem.global_position + self.SEM_DOWN_LABEL_OFFSET
	var up_args: Dictionary = {"text": sem.get_id(), "align": HALIGN_CENTER,
	"valign": VALIGN_BOTTOM, "size": self.SEM_LABEL_DIMENSION,
	"position": up_l_position}
	var down_args: Dictionary = {"text": "Value: " + str(sem.get_value()),
	"align": HALIGN_CENTER, "valign": VALIGN_TOP,
	"size": self.SEM_LABEL_DIMENSION, "position": down_l_position}
	var up_label: Label = self.create_label(up_args)
	var down_label: Label = self.create_label(down_args)
	self.add_child(up_label)
	self.add_child(down_label)
	sem.set_labels(up_label, down_label)
	self._labels.append(up_label)
	self._labels.append(down_label)

func create_label(args: Dictionary) -> Label:
	var _label: Label = Label.new()
	_label.text = args["text"]
	_label.align = args["align"]
	_label.valign = args["valign"]
	_label.set_size(args["size"])
	_label.set_position(args["position"])
	return _label

func clear_labels() -> void:
	while(not self._labels.empty()):
		self._labels.pop_back().queue_free()

func clear_cpus() -> void:
	while(not self._cpus):
		self._cpus.pop_back().queue_free()

func clear_sems() -> void:
	while(not self._sems):
		self._sems.pop_back().queue_free()

func clear_threads() -> void:
	while(not self._threads):
		self._threads.pop_back().queue_free().destroy()

func reset() -> void:
	self.clear_labels()
	self.clear_cpus()
	self.clear_sems()
	self.clear_threads()


func _on_CreationLayer_thread_created(thread: SimuThread) -> void:
# warning-ignore:return_value_discarded
	$Reset.connect("button_down", thread, "reset")
	self._threads.append(thread)


func _on_CreationLayer_creation_finished():
	self.show()
