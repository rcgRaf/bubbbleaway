extends Area2D

@export var damage:= 5
var is_enabled = true

func set_active():
	is_enabled = true

func _on_body_entered(body: Node2D) -> void:
	if is_enabled and body is PlayerController:
		is_enabled = false
		var playerBubble = body as PlayerController
		playerBubble.take_damage(damage)
		$Timer.start(3)
