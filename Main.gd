extends Node

export(Texture) var texture: Texture
func _ready():
	var sem: SimuSemaphore = SimuSemaphore.new()
	sem.init("this", 1)
	sem.global_position = Vector2(100, 100)
	sem.texture = self.texture
	self.add_child(sem)
#	var wait_time: float = 2.0
#	var cpu: CPU = CPU.new()
#	cpu.init(wait_time)
#	self.add_child(cpu)
#	cpu.play() 
