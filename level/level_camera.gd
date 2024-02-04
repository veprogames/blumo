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

func do_shake_impulse() -> void:
	var tween: Tween = create_tween()
	shake_modifier = 1.0
	tween.tween_property(self, ^"shake_modifier", 0.0, 0.3).set_ease(Tween.EASE_IN_OUT)


func _on_edible_spawner_edible_eaten() -> void:
	do_shake_impulse()
