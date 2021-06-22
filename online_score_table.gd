extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$HTTPRequest.request("http://dreamlo.com/lb/"+Globals.public_code+"/json")



func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		return
	var json  = JSON.parse(body.get_string_from_utf8())
	if json.error != OK:
		return
	var scores = json.result["dreamlo"]["leaderboard"]["entry"]
	print(typeof(scores))
	if scores is Dictionary:
		$Names.text += scores["name"] + '\n'
		$Scores.text += scores["score"] + '\n'
	if not scores is Array:
		return
	for i in scores:
		$Names.text += i["name"] + '\n'
		$Scores.text += i["score"] + '\n'


func _on_BackButton_pressed():
	get_tree().change_scene("res://title_screen.tscn")
