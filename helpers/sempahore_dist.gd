extends Node

var _semaphores: Array

func _ready():
	self._semaphores = []

func add_semaphore(semaphore: SimuSemaphore) -> void:
	self._semaphores.append(semaphore)

func wait_executed(thread: SimuThread, sem_id: String) -> void:
	for semaphore in self._semaphores:
		if semaphore.get_id() == sem_id:
			semaphore.wait(thread)
			break

func post_executed(sem_id: String) -> void:
	for semaphore in self._semaphores:
		if semaphore.get_id() == sem_id:
			semaphore.post()
			break

func reset() -> void:
	if self._semaphores:
		self._semaphores.clear()
