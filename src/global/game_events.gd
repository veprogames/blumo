extends Node

signal upgrade_bought(upgrade: Upgrade)


func emit_upgrade_bought(upgrade: Upgrade) -> void:
	upgrade_bought.emit(upgrade)
