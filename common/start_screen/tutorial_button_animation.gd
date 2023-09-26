extends Sprite

var frames_count = 36
var frame_time = 0.04
var all_frames = 0.0
var timer = 0.0
var ended = false
var running = false
var done = false

func _ready():
	set_physics_process(true)
	all_frames = frames_count * frame_time
	run()

func _physics_process(delta):
	if(!ended and running):
		timer += delta
		if timer < all_frames:
			self.set_frame(int(timer/frame_time)%frames_count)
		else:
			self.set_frame(frames_count - 1)
			ended = true
			running = false

func run():
	running = true

func is_running():
	return running

func ended():
	return ended

func reset():
	self.set_frame(0)
	ended = false
	timer = 0.0
	run()

func done():
	return timer > all_frames * 0.6

func set_frame_time(t):
	frame_time = t
	all_frames = frames_count * frame_time
