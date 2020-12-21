extends Node

export(Texture) var texture: Texture
func _ready():
	$Label.set_size(Vector2(64, 64))
	$Label.align = HALIGN_CENTER
	$Label.valign = VALIGN_BOTTOM
#	var wait_time: float = 2.0
#	var cpu: CPU = CPU.new()
#	cpu.init(wait_time)
#	self.add_child(cpu)
#	cpu.play() 
