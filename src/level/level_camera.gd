class_name LevelCamera
extends Camera2D

@export var shake_strength: float = 0.0

var shake_modifier: float = 0.0

var t: float = 0.0

var noise_x: FastNoiseLite = FastNoiseLite.new()
var noise_y: FastNoiseLite = FastNoiseLite.new()

func _ready() -> void:
	for noise: FastNoiseLite in [noise_x, noise_y]:
		noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
		noise.frequency = 10.0
		noise.seed = randi()

func _process(delta: float) -> void:
	t += delta
	
	offset = Vector2(noise_x.get_noise_1d(t), noise_y.get_noise_1d(t)) * shake_strength * shake_modifier
	shake_modifier = lerpf(shake_modifier, 0.0, delta * 10)

func do_shake_impulse() -> void:
	shake_modifier = minf(shake_modifier + 1, 2.0)

func _on_edible_spawner_edible_eaten() -> void:
	do_shake_impulse()
