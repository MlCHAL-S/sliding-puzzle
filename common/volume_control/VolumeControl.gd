extends Sprite

var curr_vol = 5

var vol_values = [-64,-45,-30,-20,-15,-10,-6,-3,-1, 0]

var visibilityTimer = 0

func _ready():
#	if(OS.get_name() == "X11"):
#		OS.execute("/usr/sbin/irstm", ["unmute"], false, [])
	modulate.a = 0
	set_physics_process(false)
	
func _physics_process(delta):
	if(visibilityTimer > 0):
		if(modulate.a < 1):
			modulate.a += 0.05
		visibilityTimer -= delta
	elif(visibilityTimer <= 0):
		if(modulate.a > 0):
			modulate.a -= 0.025
		else:
			modulate.a=0
			set_physics_process(false)
	
func Init():
	if(OS.get_name() == "X11"):
		var output = []
#		OS.execute("/usr/sbin/irstm", ["unmute"], false, [])
		OS.execute("amixer", ['get','Master'], true,output)
		curr_vol = GetClosestValue(-int(ParseOutput(output)))
	get_node("Pointer").position = lerp($StartPoint.position, $EndPoint.position, curr_vol/float(vol_values.size()-1))
	visibilityTimer = 2
	set_physics_process(true)
	
func ParseOutput(var output):
	if(output.size() > 0):
		var index = output[0].find("dB")
		if(index != -1):
			var outStr = ""
			for i in range(5,3,-1):
				if(output[0][index-i].is_valid_integer()):
					outStr += output[0][index-i]
			return outStr
	return "0"
	
func GetClosestValue(val):
	var diff = 100
	var outVal = 0
	for i in range(vol_values.size()):
		if(abs(vol_values[i] - val) < diff):
			diff = abs(vol_values[i] - val)
			outVal = i
	return outVal
	
func volume_up():
	set_volume(1)

func volume_down():
	set_volume(-1)
		
func set_volume(v):
	if(visibilityTimer <= 0):
		Init()
	if(curr_vol != null):
		visibilityTimer=2
		curr_vol = clamp(curr_vol+v, 0, vol_values.size()-1)
		if(OS.get_name() == "X11"):
			var out = []
			OS.execute("amixer", ["--","set","Master", str(vol_values[curr_vol])+"db"], false, out)
#			print("vol changed to: ", ParseOutput(out), "%")
		$Pointer.Move(lerp($StartPoint.position, $EndPoint.position, curr_vol/float(vol_values.size()-1)))
		$AudioStreamPlayer.play()
