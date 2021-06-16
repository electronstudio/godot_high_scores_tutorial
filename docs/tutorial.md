# Godot High Score Tables and Online Leaderboards

This tutorial shows you

* how to add a locally saved high score table to your game.
* how to add an online leaderboard to your game.

If you already have a game you should be able to apply the tutorial to it.  Alternatively, I have provided very simple
game which you can download, import into Godot and use.

## The simple game

Before we start adding anything we will look at what the simple game already has and how it works.  This section is for
information, you don't have to do anything until the next section.

Our game only has 2 scenes:

* title_screen
* game

The player presses a button on the title screen to switch to the game screen.  The code for this is very simple:

```gdscript
func _on_QuitButton_pressed():
	get_tree().quit()

func _on_PlayButton_pressed():
	get_tree().change_scene("res://game.tscn")
```

These functions are connected to the buttons via signals.  Note there is no function for the high score button yet.

The game scene has only 4 nodes:

* A label to display the time
* A label to display the score
* A timer
* An icon (sprite)

The code simple counts down the timer every second, and increases the score every time a key is pressed:

```gdscript
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

```

## Gameover screen

We need somewhere for the player to enter their name, so let's mke a Gameover screen.

1. Create a new scene. 
   
2. Select `User Interface` for  the root node (or `2D Scene`, it doesn't make much difference for this.)

3. Rename the root node to `gameover`.

4. Save the scene as `gameover.tscn`.

5. Add a `Label` child node to the root node.
    * In the Inspector, enter the text `GAMEOVER Your score is`.
    * In the Inspector, click `Custom Fonts` and then drag the `font.tres` file from the FileSystem (bottom left of screen) into the `[empty]`
    font field.
      
6. Add a second `Label` child node to the root node.
    * Rename it to `score`.
    * In the Inspector, click `Custom Fonts` and then drag the `font.tres` file from the FileSystem (bottom left of screen) into the `[empty]`
      font field.
      
7. Add a `LineEdit` child node to the root node.

8. Drag things around until it looks something like this:

Now edit the script file `game.gd` and change `"res://title_screen.tscn"` to `"res://gameover.tscn"` so that the game goes to the gameover
screen at the end.

## Global variables

We have a problem: we want to display the score on the gameover screen, but the score is only stored in the game scene.

In Python we have global variables that can be used from any function in the script.  In Godot we can go a bit further
than this and create variables that can be used by any script in any scene by creating a 'singleton object'.

Create a new script (`File` menu, `New Script`) and name it `globals.gd`.

Add a score variable to the bottom of the script:

```gdscript
var score=0
```

To make this accessible from anywhere:

 * click `Project` menu, then `Project Settings`, then `AutoLoad`.
 * Click the small folder icon and select the `globals.gd` script.  Press `open`.
 * Press `Add`.

Now go back the `game.gd` script and delete line 4 containing the score variable.  Then change all the other references that say `score` to `Globals.score`.

The end result will look like this:

```gdscript
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
```

You don't need to type all that, you only need to make 4 edits.  That's the complete file you should have after your changes.

Let's see if we can access the score from the gameover screen now.  Go to the `gameover.tscn` scene.  Right click on the root node and
`attach script`.  Edit the script so the ready function looks like this:

```gdscript
func _ready():
	$score.text = str(Globals.score)
```

Now run the game and test your score is displayed.

Q. Why did we have to use the `str()` function here?  What happens if you do  `$score.text = Globals.score` instead?

## Storing the names

Before we can display the table we need somewhere to store the scores and the names, so lets add two lists to `globals.gd` script:

```gdscript
var scores = []
var names = []
```

Go back to `gameover.tscn` scene and click on the `LineEdit` node.  This is where the name is entered.

Click on `Node` to the right of the `Inspector` to view the `Signals`.  Double click on `text_entered`.  Press `connect`.

A function will be created for you that is called when the player enters his name and presses return.  Edit the function to look like this:

```gdscript
func _on_LineEdit_text_entered(new_text):
   Globals.scores.append(Globals.score)
   Globals.names.append(new_text)
   get_tree().change_scene("res://score_table.tscn")
```

## Displaying the high score table

1. Create a new scene.

2. Select `User Interface` for  the root node (or `2D Scene`, it doesn't make much difference for this.)

3. Rename the root node to `ScoreTable`.

4. Save the scene as `score_table.tscn`.

5. Add a `Label` child node to the root node.
   * Rename it to `Names`
   * In the Inspector, click `Custom Fonts` and then drag the `font.tres` file from the FileSystem (bottom left of screen) into the `[empty]`
     font field.

5. Add a `Label` child node to the root node.
    * Rename it to `Scores`
    * In the Inspector, click `Custom Fonts` and then drag the `font.tres` file from the FileSystem (bottom left of screen) into the `[empty]`
      font field.
      
Position the two labels side by side like this:

Right click on the root node and `Attach script`.  Press `create`.  Edit the ready function so it looks like this:

```gdscript
func _ready():
	for name in Globals.names:
		$Names.text += name + "\n"
	for score in Globals.scores:
		$Scores.text += str(score)+"\n"
```

Now if you run the game you should be able enter your score and see the score table.  However, you will then be stuck because there is no menu
navigation.

## Menu navigation

In the `score_table.tcns` scene...

Add a `Button` child node to the root node.
* Rename it to `BackButton`
  In the Inspector set the `Text` to `Back`.
* In the Inspector, click `Custom Fonts` and then drag the `font.tres` file from the FileSystem (bottom left of screen) into the `[empty]`
  font field. 

Click on `Node` to the right of the `Inspector` to view the `Signals`.  Double click on `pressed`.  Press `connect`.

Edit the function so it looks like this:

```gdscript
func _on_BackButton_pressed():
   get_tree().change_scene("res://title_screen.tscn")
```

Now go to the `title_screen.tscn` scene...

Click on the `HighScoresButton` node.  Click on `Node` to the right of the `Inspector` to view the `Signals`.
Double click on `pressed`.  Press `connect`.

Edit the function so it looks like this:

```gdscript
func _on_HighScoresButton_pressed():
	get_tree().change_scene("res://score_table.tscn")
```

Well done!  You now have a (sort of) working high score table!

## Saving files

There a couple of big problems with this score table.  The first one is that it loses the scores every time you quit game.

To fix this, we can store the scores in a file on the computer's disk.  We will create separate functions for loading and saving
the scores.  Edit `globals.gd` and add this code to the bottom:

```gdscript
   func _init():
   load_scores()

func save_scores():
	var file = File.new()
	file.open("user://game.dat", File.WRITE)
	file.store_var(names)
	file.store_var(scores)
	file.close()
	
func load_scores():
	var file = File.new()
	var err = file.open("user://game.dat", File.READ)
	if err != OK:
		print("error loading scores")
	else:
		names = file.get_var()
		scores = file.get_var()
	file.close()
```

The first time we run the game there will be no score file, so we will we print an error, but this is OK, because
it will be created when we save the scores.  To do this, edit `gameover.gd` and insert a line so your function looks like
this:

```gdscript
func _on_LineEdit_text_entered(new_text):
	Globals.scores.append(Globals.score)
	Globals.names.append(new_text)
	Globals.save_scores()
	get_tree().change_scene("res://score_table.tscn")
```

Run the game and check your scores load and save.

## Challenge:  Improve the organisation of the code.

Change function to be:

```gdscript
func _on_LineEdit_text_entered(name):
	Globals.add_score(name)
	get_tree().change_scene("res://score_table.tscn")
```

Then write the `add_score` function in `globals.gd` to make this work.

## Sorting the scores

Currently the scores are not displayed in the correct order.  We need to sort them.

Godot has a built in sort function, so we could call `scores.sort()`, but this would only sort the scores and not the names.
The way a professional would deal with this would probably be to store the name and score in an object and write a comparitor function.
However, it's more educational (and simpler) for us to just write our own sort function.

This is a famous algorithm called Bubble Sort.  You can read about it here: https://en.wikipedia.org/wiki/Bubble_sort

Add this to the bottom of `globals.gd`:

```gdscript
func bubble_sort():
	for passnum in range(len(scores)-1,0,-1):
		for i in range(passnum):
			if scores[i]<scores[i+1]:
				var temp = scores[i]
				scores[i] = scores[i+1]
				scores[i+1] = temp
				temp = names[i]
				names[i] = names[i+1]
				names[i+1] = temp
```

Call it from an appropriate place, e.g. you could edit save_scores so it sorts every time it saves:

```gdscript
func save_scores():
	bubble_sort()
	var file = File.new()
	file.open("user://game.dat", File.WRITE)
	file.store_var(names)
	file.store_var(scores)
	file.close()
```


## Challenges, Sorting

This bubble sort is not optimized.  Make it `return` as soon as it completes a pass with no swaps.

Implement some better sorting algorithms, such as [Merge Sort](https://en.wikipedia.org/wiki/Merge_sort)
and [Insertion Sort](https://en.wikipedia.org/wiki/Insertion_sort)

## Other stuff

Add an 'OK' button on the gameover screen.

Display ranking number 1, 2, 3, etc next to the names.

What do you do when there are too many scores to fit on the screen?  Delete the lowest ones?  Or provide buttons to scroll up and down?