extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(_delta):
	pass



	


func _on_attack_hitbox_body_entered(body):
	if body.has_method("damage"):
		body.damage()
		body.knockback()
