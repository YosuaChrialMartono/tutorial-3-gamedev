extends Area2D

@onready var win = $win

func _on_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		win.play()		
		get_tree().change_scene_to_file(str("res://scenes/WinScreen.tscn"))
