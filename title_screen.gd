extends Control

func _on_QuitButton_pressed():
	get_tree().quit()


func _on_PlayButton_pressed():
	get_tree().change_scene("res://game.tscn")


func _on_HighScoresButton_pressed():
	get_tree().change_scene("res://score_table.tscn")
