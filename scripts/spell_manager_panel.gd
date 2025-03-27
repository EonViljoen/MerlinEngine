extends Control

@export var slideSpeed: float = 300.0

@onready var spellPanel : Panel = $SideSpellPanel
@onready var openCloseButton : Button = $SideSpellPanel/OpenCloseButton
@onready var buttonContainer: Container = $SideSpellPanel/ButtonContainer
@onready var projectileModifierManager : ProjectileModifierManager = $ProjectileModifierManager

var isOpen : bool = false
var closePositionX : float
var openPositionX: float
var tween : Tween

func _ready() -> void:
	closePositionX = spellPanel.get_global_rect().position.x
	openPositionX =  closePositionX - (spellPanel.get_global_rect().end.x - closePositionX)

		
func _on_open_close_button_pressed() -> void:
	isOpen = !isOpen

	var targetPositionX = openPositionX if isOpen else closePositionX
	spellPanel.set_position(Vector2(targetPositionX, spellPanel.position.y))
	tween = get_tree().create_tween()
	tween.tween_property(spellPanel, "position:x", targetPositionX, 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.kill()
	
	if !isOpen:
		openCloseButton.release_focus()
	
