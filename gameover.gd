extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$score.text = str(Globals.score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_LineEdit_text_entered(new_text):
	Globals.scores.append(Globals.score)
	Globals.names.append(new_text)
	Globals.save_scores()
	var url = "http://dreamlo.com/lb/"+Globals.private_code+"/add/"
	url += new_text.percent_encode()+"/"+str(Globals.score)
	$HTTPRequest.request(url)
	


func _on_HTTPRequest_request_completed(result, response_code, headers, 
	body):
	get_tree().change_scene("res://score_table.tscn")
