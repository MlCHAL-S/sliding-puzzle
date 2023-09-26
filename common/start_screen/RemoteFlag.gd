extends Sprite

var sc=Vector2(1,1)
# Called when the node enters the scene tree for the first time.
func _ready():

	return
	
	# TEST EXAMPLE CODE
	var anim = $AnimationPlayer.get_animation("Pulse")
	for j in range(anim.get_track_count()):
		print("Info "+str(j))
		var t=anim.track_get_key_count(j)
		print(str(t))
		for k in range(t):
			print("key "+str(k))
			print(str(anim.track_get_key_time(j,k)))
			print(str(anim.track_get_key_transition(j,k)))
			print(str(typeof(anim.track_get_key_value(j,k))))
			print(str(anim.track_get_key_value(j,k)))
		

func set_scale(s=Vector2(1,1)):
	sc=s
	var anim = $AnimationPlayer.get_animation("Pulse")
	anim.track_set_key_value(0,0,Vector2(1,1)*sc)
	anim.track_set_key_value(0,1,Vector2(1.2,1.2)*sc)	
	anim.track_set_key_value(0,2,Vector2(1,1)*sc)	
	.set_scale(s)
