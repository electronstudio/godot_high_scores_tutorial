extends Node2D

var time = 10

func _on_Timer_timeout():
	time -= 1
	$TimeLabel.text = "TIME: "+str(time)
	if time <=0:
		get_tree().change_scene("res://gameover.tscn")

func _unhandled_input(event):
	if event is InputEventKey and not event.echo:
		Globals.score += 1
		$ScoreLabel.text = "SCORE: "+str(Globals.score)
		$icon.position.y = Globals.score * 5
