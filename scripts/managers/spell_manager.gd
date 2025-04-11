extends Node

@export var spellSlots: Array[SpellDataResource] = [
	
]
@onready var modifierStackCount: Dictionary[String, int] = {
	
}
@onready var spellResourceDict: Dictionary[String, String] ={
	"Basic Bolt": "res://resources/spells/basic_bolt.tres",
	"Fireball": "res://resources/spells/fireball.tres"
}
@onready var spellUnlockConditionsDict: Dictionary = {
	"Fireball": [
		{"HeatUp": 10}
		],
}
var currentSpell: SpellDataResource

signal currentSpellInUse

func _ready() -> void:
	spellSlots.append(load(spellResourceDict["Basic Bolt"]))
	
func loadSpells() -> void:
	currentSpellInUse.emit(spellSlots.front())

func check_unlock_conditions(modName: String) -> void:
	for spell in spellUnlockConditionsDict.keys():
		var condition_met = true
		
		for condition in spellUnlockConditionsDict[spell]:
			var requiredModCount = condition[modName]
			var currentModCount = modifierStackCount[modName]
			
			if currentModCount < requiredModCount:
				condition_met = false
				continue
		
		
		if condition_met and !spellSlots.filter(func(unlockedSpell): 
			if spell == unlockedSpell.spellName:
				return true
			):
			unlock_spell(spell)
	
func unlock_spell(spellName: String):
	var spellPath = spellResourceDict[spellName]
	var newUnlockedSpell = load(spellPath)
	spellSlots.append(newUnlockedSpell)
	currentSpell = spellSlots.back()
	SignalBus.currentSpellInUse.emit(currentSpell)

func add_modifier(modName: String) -> void:
	modifierStackCount.get_or_add(modName, 0)
	modifierStackCount[modName] += 1
	check_unlock_conditions(modName)
