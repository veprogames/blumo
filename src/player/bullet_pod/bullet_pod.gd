class_name BulletPod
extends Node2D

const BulletScene: PackedScene = preload("res://src/bullet/bullet.tscn")
const StreamShoot: AudioStreamWAV = preload("res://assets/bullet/shoot.wav")

var cooldown: float = 0.5
var t: float = 0.0


func _ready() -> void:
	cooldown = get_cooldown()
	if Global.save.upgrade_bullets_enable.level == 0:
		queue_free()


func _physics_process(delta: float) -> void:
	t += delta
	if t >= cooldown:
		t -= cooldown
		shoot()


func get_cooldown() -> float:
	return 1.0 / Global.save.upgrade_bullets_firerate.get_current_effect()


func shoot() -> void:
	var count: int = int(Global.save.upgrade_bullets_count.get_current_effect())
	for i: int in range(count):
		var gap: float = TAU / 16.0
		var start_angle: float = -gap * 0.5 * (count - 1)
		var angle: float = start_angle + gap * i
		var bullet: Bullet = spawn_bullet()
		bullet.rotation += angle
	AudioManager.play_stream(StreamShoot)


func spawn_bullet() -> Bullet:
	var container: Node2D = get_container()
	if !container:
		return
	
	var bullet: Bullet = BulletScene.instantiate()
	container.add_child(bullet)
	bullet.rotation = global_rotation
	bullet.position = global_position
	return bullet


func get_container() -> Node2D:
	return get_tree().get_first_node_in_group(&"spawnables")
