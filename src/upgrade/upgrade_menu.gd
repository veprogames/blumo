class_name UpgradeMenu
extends PanelContainer

const TAB_BULLETS: int = 2
const TAB_ABILITIES: int = 3

@onready var upgrade_button_trail: UpgradeButton = %UpgradeButtonTrail
@onready var upgrade_button_value: UpgradeButton = %UpgradeButtonValue
@onready var upgrade_button_triangle_chance: UpgradeButton = %UpgradeButtonTriangleChance
@onready var upgrade_button_hexagon_chance: UpgradeButton = %UpgradeButtonHexagonChance
@onready var upgrade_button_star_chance: UpgradeButton = %UpgradeButtonStarChance
@onready var upgrade_button_bullets_enable: UpgradeButton = %UpgradeButtonBulletsEnable
@onready var upgrade_button_bullets_firerate: UpgradeButton = %UpgradeButtonBulletsFirerate
@onready var upgrade_button_bullets_count: UpgradeButton = %UpgradeButtonBulletsCount

@onready var currency_counter: CurrencyCounter = %CurrencyCounter
@onready var tab_bar: TabBar = $VBoxContainer/TabBar
@onready var tabs: Control = $VBoxContainer/MarginContainer/VBoxContainer/Tabs


func _ready() -> void:
	upgrade_button_trail.upgrade = Global.save.upgrade_trail_length
	upgrade_button_value.upgrade = Global.save.upgrade_edible_value
	upgrade_button_triangle_chance.upgrade = Global.save.upgrade_triangle_chance
	upgrade_button_hexagon_chance.upgrade = Global.save.upgrade_hexagon_chance
	upgrade_button_star_chance.upgrade = Global.save.upgrade_star_chance
	upgrade_button_bullets_enable.upgrade = Global.save.upgrade_bullets_enable
	upgrade_button_bullets_firerate.upgrade = Global.save.upgrade_bullets_firerate
	upgrade_button_bullets_count.upgrade = Global.save.upgrade_bullets_count
	
	currency_counter.set_value_instant(Global.save.score)
	Global.save.score_changed.connect(_on_global_score_changed)
	Global.save.stage_changed.connect(_on_global_stage_changed)
	GameEvents.upgrade_bought.connect(_on_game_events_upgrade_bought)
	
	update_tabs()
	
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


func update_tabs() -> void:
	tab_bar.set_tab_hidden(TAB_ABILITIES, Global.save.stage < 100)
	tab_bar.set_tab_hidden(TAB_BULLETS, Global.save.upgrade_bullets_enable.level == 0)


func _on_global_score_changed(score: float) -> void:
	currency_counter.value = Global.save.score


func _on_global_stage_changed(_stage: int) -> void:
	update_tabs()


func _on_tab_bar_tab_changed(tab: int) -> void:
	for child: Control in tabs.get_children():
		child.hide()
	
	var child: Control = tabs.get_child(tab)
	if child:
		child.show()


func _on_game_events_upgrade_bought(_upgrade: Upgrade) -> void:
	update_tabs()
