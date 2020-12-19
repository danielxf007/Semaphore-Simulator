extends Node

class_name SemaphoreDistributor

var _semaphores: Array

func set_semaphores(semaphores: Array) -> void:
	self._semaphores = semaphores

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
