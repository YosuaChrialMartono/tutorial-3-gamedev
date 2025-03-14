extends Node2D

func _on_coin_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		$win.play()		
		var flag = $WinFlag/flagsprite
		flag.visible = true # Replace with function body.if body.get_name() == "Player":
		$Coin/coinsprite.visible = false
