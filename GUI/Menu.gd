extends Control

onready var button_play= $CanvasLayer/Node2D/Button
onready var sonido=$AudioStreamPlayer
onready var animacion=$anim

func _ready():
	button_play.visible=false
	sonido.play()
	animacion.play("go_in")

func _on_Button_pressed():
	button_play.disabled=true
	return get_tree().change_scene("res://Game/Game.tscn")


func _on_AudioStreamPlayer_finished():
	button_play.visible=true
