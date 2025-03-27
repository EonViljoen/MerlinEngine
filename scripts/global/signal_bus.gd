extends Node

signal statUpdate(stat_resource: CharacterStatResource, statName: String, newStatValue: float)
signal updateModifiers(updatedModifiersList: Array[ProjectileModifier])
