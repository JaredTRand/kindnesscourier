extends StaticBody3D

@export_range(1, 100) var happiness_needed:int
@export var dead:MeshInstance3D
@export var alive:MeshInstance3D

func _ready() -> void:
	Globals.happiness_increased.connect(func():
		if Globals.town_happiness >= happiness_needed:
			dead.hide()
			alive.show()
	)
