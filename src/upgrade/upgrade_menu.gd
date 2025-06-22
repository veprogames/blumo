class_name UpgradeMenu
extends PanelContainer

const TAB_BULLETS: int = 2
const TAB_MAGNET: int = 3
const TAB_ABILITIES: int = 4

@onready var popup_menu_component: PopupMenuComponent = $PopupMenuComponent

@onready var upgrade_button_trail: UpgradeButton = %UpgradeButtonTrail
@onready var upgrade_button_value: UpgradeButton = %UpgradeButtonValue
@onready var upgrade_button_triangle_chance: UpgradeButton = %UpgradeButtonTriangleChance
@onready var upgrade_button_hexagon_chance: UpgradeButton = %UpgradeButtonHexagonChance
@onready var upgrade_button_star_chance: UpgradeButton = %UpgradeButtonStarChance
@onready var upgrade_button_bullets_enable: UpgradeButton = %UpgradeButtonBulletsEnable
@onready var upgrade_button_bullets_firerate: UpgradeButton = %UpgradeButtonBulletsFirerate
@onready var upgrade_button_bullets_count: UpgradeButton = %UpgradeButtonBulletsCount
@onready var upgrade_button_magnet_enable: UpgradeButton = %UpgradeButtonMagnetEnable
@onready var upgrade_button_magnet_size: UpgradeButton = %UpgradeButtonMagnetSize
@onready var upgrade_button_magnet_strength: UpgradeButton = %UpgradeButtonMagnetStrength

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
	upgrade_button_magnet_enable.upgrade = Global.save.upgrade_magnet_enable
	upgrade_button_magnet_size.upgrade = Global.save.upgrade_magnet_size
	upgrade_button_magnet_strength.upgrade = Global.save.upgrade_magnet_strength
	
	currency_counter.set_value_instant(Global.save.score)
	Global.save.score_changed.connect(_on_global_score_changed)
	Global.save.stage_changed.connect(_on_global_stage_changed)
	GameEvents.upgrade_bought.connect(_on_game_events_upgrade_bought)
	
	update_tabs()


func update_tabs() -> void:
	tab_bar.set_tab_hidden(TAB_ABILITIES, Global.save.stage < 100)
	tab_bar.set_tab_hidden(TAB_BULLETS, Global.save.upgrade_bullets_enable.level == 0)
	tab_bar.set_tab_hidden(TAB_MAGNET, Global.save.upgrade_magnet_enable.level == 0)


func open() -> void:
	popup_menu_component.show_menu()


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
