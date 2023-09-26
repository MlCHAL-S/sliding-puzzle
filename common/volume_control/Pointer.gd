extends Sprite

var dest

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false)

func _physics_process(delta):
	if(abs(dest.x - position.x) > 5):
		translate((dest-position).normalized()*delta*200)
	else:
		position = dest
		set_physics_process(false)
		
			
func Move(d):
	dest = d
	set_physics_process(true)
		
