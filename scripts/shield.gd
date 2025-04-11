extends Node2D

#signal shieldHit

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Projectiles") && body.get_parent().target == "Player":
		body.queue_free()  # Delete the projectile
