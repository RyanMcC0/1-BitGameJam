extends Sprite2D

var origin_Y
var origin_diff
var cur_Y
var movementOffset = 0
var changeVal = 1
var frameCount = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	origin_Y = self.position.y
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	frameCount +=1
	if frameCount%8==0:
		cur_Y = self.position.y
		origin_diff = (cur_Y - origin_Y)
		if(origin_diff < -movementOffset): 
			changeVal = (changeVal*changeVal)
		elif (origin_diff > movementOffset):
			changeVal = -(changeVal*changeVal)
		self.position.y += changeVal 
		frameCount = 0
