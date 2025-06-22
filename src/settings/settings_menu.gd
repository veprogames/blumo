class_name SettingsMenu
extends PanelContainer

@onready var popup_menu_component: PopupMenuComponent = $PopupMenuComponent

@onready var check_box_eat_particles: CheckBox = %CheckBoxEatParticles


func _ready() -> void:
	check_box_eat_particles.button_pressed = Global.settings.eat_particles


func _on_check_box_eat_particles_toggled(toggled_on: bool) -> void:
	Global.settings.eat_particles = toggled_on


func open() -> void:
	popup_menu_component.show_menu()
