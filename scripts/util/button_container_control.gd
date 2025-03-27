extends Container

@onready var spellSidePanel : Panel = self.get_parent()
@onready var spellManagerPanel: Control = spellSidePanel.get_parent()
@onready var projectileModifierManager : ProjectileModifierManager = spellManagerPanel.get_node("ProjectileModifierManager")

var modifiers

signal pressedModifier

func _ready() -> void:
	fitContainer()
	populateSpellPanel()

func fitContainer() -> void:
	self.global_position = spellSidePanel.global_position

func populateSpellPanel() -> void:
	if projectileModifierManager:
		modifiers = projectileModifierManager.get_modifiers_list()
	
	for mod in modifiers:
		var modButton = Button.new()
		modButton.text = mod.modDisplayName
		modButton.pressed.connect(on_mod_button_pressed.bind(mod.modName))
		self.add_child(modButton)

func on_mod_button_pressed(modifierName: String):
	pressedModifier.emit(modifierName)
