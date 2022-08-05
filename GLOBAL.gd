extends Node

var rng :RandomNumberGenerator = RandomNumberGenerator.new()
var languaje

func random(min_value, max_value):
	rng.randomize()
	var n_random = rng.randi_range(min_value, max_value)
	return n_random

func sound_letter(letra):
	var sound = load("res://assets/letter_sound/english/"+letra+".mp3")
	return sound
