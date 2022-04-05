class_name ActorSprite
extends Sprite

# NOTE: maybe this is good node now?
# TODO: clean the script

export var is_playing := true setget set_is_playing
export var frame_time := 0.2
export var current_animation := "idle" setget set_current_animation
export(String, FILE, "*.txt") var path := ""

var index := 0
var timer := 0.0
var animations := {} # String: [int]

func _ready() -> void:
	if path:
		load_animations()
	set_current_animation(current_animation)
	if current_animation in animations:
		set_frame(animations[current_animation][index])

func _process(delta: float) -> void:
	if is_playing:
		timer += delta
		if timer >= frame_time:
			timer = 0.0
			next_frame()

func next_index() -> void:
	index += 1
	if index >= len(animations[current_animation]):
		index = 0

func next_frame() -> void:
	next_index()
	set_frame(animations[current_animation][index])

func get_frame_count() -> int:
	return vframes * hframes

func set_frame(value: int) -> void:
	if value > -1 and value < get_frame_count():
		frame = value

func set_is_playing(value: bool) -> void:
	is_playing = value
	index = 0

func set_current_animation(value: String) -> void:
	current_animation = value
	index = 0
	set_process(current_animation in animations)

func load_animations() -> void:
	var file := File.new()
	var err := file.open(path, File.READ)
	if err:
		Game.print_error(self, "file.open", err)
	else:
		var key := ""
		var line := ""
		while not file.eof_reached():
			line = file.get_line()
			if line.empty():
				continue
			key = ""
			for value in line.split(',', false):
				if key.empty():
					key = value
					animations[key] = [] # PoolIntArray not working?
				else:
					animations[key].append(int(value))
		set_current_animation(current_animation)
		file.close()
