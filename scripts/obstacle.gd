extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerController:
		var playerBubble = body as PlayerController
		playerBubble.set_bubble_scale(playerBubble.get_bubble_scale() / 2.0)
	pass # Replace with function body.
