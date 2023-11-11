extends Sprite2D

var origin_Y
var origin_diff
var cur_Y
var movementOffset = 0
var changeVal = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	origin_Y = self.position.y
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	cur_Y = self.position.y
	origin_diff = (cur_Y - origin_Y)
	print(cur_Y)
	print(origin_diff)
	if(origin_diff < -movementOffset): 
		changeVal = (changeVal*changeVal)
		print("up")
	elif (origin_diff > movementOffset):
		changeVal = -(changeVal*changeVal)
		print("down")
	self.position.y += changeVal 
