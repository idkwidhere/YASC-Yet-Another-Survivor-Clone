extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_play_button_button_down() -> void:
	$CharacterSelection.show()
	$MainScreen.hide()
	
