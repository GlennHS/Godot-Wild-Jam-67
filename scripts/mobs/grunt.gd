extends Mob

@export var boss_music: AudioStream
@export var drop: PackedScene

@onready var audio_manager: AudioManagerClass = get_node("/root/AudioManager")
var fun_begun = false

func execute_turn() -> void:
	super.execute_turn()
	if check_if_visible():
		begin_the_fun()

func begin_the_fun() -> void:
	if not fun_begun:
		fun_begun = true
		audio_manager.change_music(boss_music)
		$ScreamAudio.play()
		
func death() -> void:
	var item_dropped = drop.instantiate()
	item_dropped.global_position = global_position
	get_node("/root/Level").add_child(item_dropped)
	super.death()
	
