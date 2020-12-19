extends Node
signal element_organized(element)
class_name Organizer

const CELL_DIMENSIONS: Vector2 = Vector2(64, 64)
const SEM_SCALE_DIMENSIONS: Vector2 = Vector2(1, 1)
const CPU_SCALE_DIMENSIONS: Vector2 = Vector2(2, 2)
const START_SEM_POS: Vector2 = Vector2(96, 160)
const START_CPU_POS: Vector2 = Vector2(96, 288)
const WHITE_SPACE: Vector2 = Vector2(64, 64)
const MAX_ROW_NUMBER: int = 4 
var curr_sem_pos: Vector2
var curr_cpu_pos: Vector2
var curr_row_number: int

func _ready():
	self.curr_sem_pos = self.START_SEM_POS
	self.curr_cpu_pos = self.START_CPU_POS
	self.curr_row_number = 1

func scale_semaphore(sem: SimuSemaphore) -> void:
	var texture_size: Vector2 = sem.texture.get_size()
	var sem_scale: Vector2 = sem.scale
	sem_scale.x = self.CELL_DIMENSIONS.x/texture_size.x
	sem_scale.x *= self.SEM_SCALE_DIMENSIONS.x
	sem_scale.y = self.CELL_DIMENSIONS.y/texture_size.y
	sem_scale.y *= self.SEM_SCALE_DIMENSIONS.y
	sem.scale = sem_scale

func scale_cpu(cpu: CPU) -> void:
	var texture_size: Vector2 = cpu.texture.get_size()
	var cpu_scale: Vector2 = cpu.scale
	cpu_scale.x = self.CELL_DIMENSIONS.x/texture_size.x
	cpu_scale.x *= self.CPU_SCALE_DIMENSIONS.x
	cpu_scale.y = self.CELL_DIMENSIONS.y/texture_size.y
	cpu_scale.y *= self.CPU_SCALE_DIMENSIONS.y
	cpu.scale = cpu_scale

func positionate_sem(sem: SimuSemaphore) -> void:
	sem.global_position = self.curr_sem_pos
	self.curr_sem_pos.x += 1.5*self.WHITE_SPACE.x

func positionate_cpu(cpu: CPU) -> void:
	cpu.global_position = self.curr_cpu_pos
	if self.curr_row_number < self.MAX_ROW_NUMBER:
		self.curr_cpu_pos.x += 2.5*self.WHITE_SPACE.x
		self.curr_row_number += 1
	else:
		self.curr_cpu_pos.x = self.START_CPU_POS.x
		self.curr_cpu_pos.y = 3*self.WHITE_SPACE.y + self.START_CPU_POS.y
		self.curr_row_number = 0

func _on_CreationLayer_processor_created(processor: CPU) -> void:
	self.scale_cpu(processor)
	self.positionate_cpu(processor)
	self.emit_signal("element_organized", processor)

func _on_CreationLayer_sem_created(sem: SimuSemaphore) -> void:
	self.scale_semaphore(sem)
	self.positionate_sem(sem)
	self.emit_signal("element_organized", sem)

func reset() -> void:
	self.curr_sem_pos = self.START_SEM_POS
	self.curr_cpu_pos = self.START_CPU_POS
	self.curr_row_number = 1
