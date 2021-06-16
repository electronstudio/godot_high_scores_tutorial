extends Node2D


var time = 10
var score = 0

func _on_Timer_timeout():
	time -= 1
	$TimeLabel.text = "TIME: "+str(time)
	if time <=0:
		get_tree().change_scene("res://title_screen.tscn")

func _unhandled_input(event):
	if event is InputEventKey and not event.echo:
		score += 1
		$ScoreLabel.text = "SCORE: "+str(score)
		$icon.position.y = score * 5
