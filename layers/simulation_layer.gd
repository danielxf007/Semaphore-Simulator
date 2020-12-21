extends Node2D

const SEM_UP_LABEL_OFFSET: Vector2 = Vector2(-32, -96)
const SEM_DOWN_LABEL_OFFSET: Vector2 = Vector2(-32, 32)
var _labels: Array

func _ready():
	self._labels = []

func _on_Organizer_cpu_organized(cpu: CPU, dimensions: Vector2)->void:
	self.add_child(cpu)

func _on_Organizer_sem_organized(sem: SimuSemaphore, dimensions: Vector2)->void:
	self.add_child(sem)
	var up_l_position: Vector2 = sem.global_position + self.SEM_UP_LABEL_OFFSET
	var down_l_position: Vector2 = sem.global_position + self.SEM_DOWN_LABEL_OFFSET
	var up_args: Dictionary = {"text": sem.get_id(), "align": HALIGN_CENTER,
	"valign": VALIGN_BOTTOM, "size": dimensions, "position": up_l_position}
	var down_args: Dictionary = {"text": "Value: " + str(sem.get_value()),
	"align": HALIGN_CENTER, "valign": VALIGN_TOP, "size": dimensions,
	"position": down_l_position}
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

func reset() -> void:
	while(not self._labels.empty()):
		self._labels.pop_back().queue_free()
