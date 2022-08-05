extends Node2D

onready var sounds={}
onready var letters = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N',
'O','P','Q','R','S','T','U','V','W','X','Y','Z']
onready var n_letter
onready var n_label
onready var life=6
onready var score = 0
onready var cont=1
onready var total=0
onready var relive=0

#NODOS CON ONREADY
onready var countdown=$countdown
onready var letters_animation=$letters_anim
onready var character_animation=$character
onready var score_label=$score/Label
onready var audio=$AudioStreamPlayer
onready var hp_bar=$HP_BAR
onready var timer=$Timer

func _ready():
	$CanvasModulate.color="ffffff"
	$letters.position.y=400
	letters_animation.play("tutorial")
	countdown.visible=false

func _process(_delta):
	countdown.text=str(int($Timer.time_left))
	score_label.text=str(score)
	if life==0 and cont==1:
		character_animation.stop()
		letters_animation.play("restart")
		$CanvasLayer/restart/Label.text=str(score)
		cont+=1

func letras_faltantes():
	if total<20:
		total+=1
	elif total==20:
		letters_animation.play("restart")

func instanciar_letra():
	n_letter = Global.random(0,len(letters)-1)
	n_label = Global.random(1,3)
	var label = get_node("letters/Button"+str(n_label))
	label.text=letters[n_letter]
	audio.stream=Global.sound_letter(letters[n_letter])
	audio.play()
	letras_faltantes()
	var restantes=1
	var n=0
	while restantes<=3:
		var other_letter=[0,1]
		if restantes != n_label:
			label = get_node("letters/Button"+str(restantes))
			other_letter[n] = Global.random(0,len(letters)-1)
			if n==0:
				while other_letter[n]==n_letter:
					other_letter[n] = Global.random(0,len(letters)-1)
				label.text=letters[other_letter[n]]
			elif n==1:
				while other_letter[n]==n_letter or other_letter[n]==other_letter[n-1]:
					other_letter[n] = Global.random(0,len(letters)-1)
				label.text=letters[other_letter[n]]
			n+=1
		restantes+=1

func check(opcion):
	var button = get_node("letters/Button"+str(opcion))
	if button.text!=letters[n_letter]:
		character_animation.play("wrong")
		audio.stream=load("res://assets/sounds/Wrong.mp3")
		audio.play()
		life-=1
		relive=0
		life_bar()
	else:
		
		character_animation.play("point")
		audio.stream=load("res://assets/sounds/Scoring a Point.mp3")
		audio.play()
		update_score()
	letters_animation.play("go_out")


func update_score():
	score+=5
	relive+=1
	if relive>=3 and life<6:
		life+=1
		life_bar()

func life_bar():
	var n_life=load("res://assets/Basic bars & buttons/HP bars/energy "+str(life)+" of 6.png")
	hp_bar.texture=n_life

func _on_Button1_pressed():
	check(1)


func _on_Button2_pressed():
	check(2)


func _on_Button3_pressed():
	check(3)


func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name=="go_out":
		$letters/Button1.disabled=true
		$letters/Button2.disabled=true
		$letters/Button3.disabled=true
	if anim_name=="go_in":
		instanciar_letra()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name=="go_in":
		$letters/Button1.disabled=false
		$letters/Button2.disabled=false
		$letters/Button3.disabled=false
	if anim_name=="go_out":
		letters_animation.play("go_in")
	if anim_name=="restart_press":
		life=6
		cont=1
		score=0
		life_bar()
		countdown.visible=true
		$letters.position.y=400
		timer.start(4)
		audio.stream=load("res://assets/sounds/Count Down.mp3")
		audio.play()
	if anim_name=="tutorial":
		timer.start(4)
		countdown.visible=true
		audio.stream=load("res://assets/sounds/Count Down.mp3")
		audio.play()


func _on_Timer_timeout():
	character_animation.play("idle")
	letters_animation.play("go_in")
	timer.stop()
	countdown.visible=false


func _on_character_animation_finished(anim_name):
	if anim_name!="idle":
		character_animation.play("idle")


func _on_Button_pressed():
	letters_animation.play("restart_press")


func _on_AudioStreamPlayer_finished():
	audio.stop()
