extends Container

@onready var spellSidePanel : Panel = self.get_parent()
@onready var spellManagerPanel: Control = spellSidePanel.get_parent()
@onready var projectileModifierManager : ProjectileModifierManager = spellManagerPanel.get_node("ProjectileModifierManager")

var modifiers

signal addedModifier
signal subtractedModifier

func _ready() -> void:
	fitContainer()
	populateSpellPanel()
	#connect("gui_input", on_mod_button_pressed)

#func _process(delta):
	#if Input.is_action_pressed("SubtractModifier") && :
		
	
func fitContainer() -> void:
	self.global_position = spellSidePanel.global_position

func populateSpellPanel() -> void:
	if projectileModifierManager:
		modifiers = projectileModifierManager.get_modifiers_list()
	
	for mod in modifiers:
		var modButton: Button = Button.new()
		modButton.text = mod.modDisplayName
		modButton.button_mask = MOUSE_BUTTON_MASK_LEFT | MOUSE_BUTTON_MASK_RIGHT


		modButton.gui_input.connect( func(event: InputEvent) :
			if event.is_pressed():
				if Input.is_action_pressed("SubtractModifier"):
					subtractModifier(mod.modName)
				else:
					addModifier(mod.modName))
				
		self.add_child(modButton)

func subtractModifier(modifierName: String):
	subtractedModifier.emit(modifierName)

func addModifier(modifierName: String):
	addedModifier.emit(modifierName)

	
