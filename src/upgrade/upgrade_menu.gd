class_name UpgradeMenu
extends PanelContainer

@onready var upgrade_button_trail: UpgradeButton = %UpgradeButtonTrail
@onready var upgrade_button_value: UpgradeButton = %UpgradeButtonValue
@onready var upgrade_button_triangle_chance: UpgradeButton = %UpgradeButtonTriangleChance
@onready var upgrade_button_hexagon_chance: UpgradeButton = %UpgradeButtonHexagonChance
@onready var upgrade_button_star_chance: UpgradeButton = %UpgradeButtonStarChance
@onready var upgrade_button_bullets_enable: UpgradeButton = %UpgradeButtonBulletsEnable
@onready var upgrade_button_bullets_firerate: UpgradeButton = %UpgradeButtonBulletsFirerate

@onready var currency_counter: CurrencyCounter = %CurrencyCounter


func _ready() -> void:
	upgrade_button_trail.upgrade = Global.save.upgrade_trail_length
	upgrade_button_value.upgrade = Global.save.upgrade_edible_value
	upgrade_button_triangle_chance.upgrade = Global.save.upgrade_triangle_chance
	upgrade_button_hexagon_chance.upgrade = Global.save.upgrade_hexagon_chance
	upgrade_button_star_chance.upgrade = Global.save.upgrade_star_chance
	upgrade_button_bullets_enable.upgrade = Global.save.upgrade_bullets_enable
	upgrade_button_bullets_firerate.upgrade = Global.save.upgrade_bullets_firerate
	
	currency_counter.set_value_instant(Global.save.score)
	Global.save.score_changed.connect(_on_global_score_changed)
	
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	scale = Vector2.ZERO
	show()


func _unhandled_input(event: InputEvent) -> void:
	var mouse_event: InputEventMouseButton = event as InputEventMouseButton
	if mouse_event:
		hide_menu()


func show_menu() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	var tween: Tween = create_tween()
	tween.tween_property(self, ^"scale", Vector2.ONE, 0.5) \
		.set_trans(Tween.TRANS_ELASTIC) \
		.set_ease(Tween.EASE_OUT)

func hide_menu() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var tween: Tween = create_tween()
	tween.tween_property(self, ^"scale", Vector2.ZERO, 0.3) \
		.set_trans(Tween.TRANS_EXPO) \
		.set_ease(Tween.EASE_OUT)


func _on_global_score_changed(score: float) -> void:
	currency_counter.value = Global.save.score
