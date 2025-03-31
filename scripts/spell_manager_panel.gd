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
	print(closePositionX)
	print(openPositionX)

		
func _on_open_close_button_pressed() -> void:
	print("panel open : ")
	print(isOpen)
	isOpen = !isOpen
	print("panel open now: ")
	print(isOpen)

	var targetPositionX = openPositionX if isOpen else closePositionX
	
	print("targeted pos")
	print(targetPositionX)
	
	spellPanel.global_position.x = targetPositionX
	
	print("actual pos")
	print(spellPanel.position)
	
	print("actual global pos")
	print(spellPanel.global_position)
	
	tween = get_tree().create_tween()
	tween.tween_property(spellPanel, "position:x", targetPositionX, slideSpeed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.kill()
	
	if !isOpen:
		openCloseButton.release_focus()
	
