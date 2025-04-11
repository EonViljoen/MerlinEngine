extends Node

signal statUpdate(stat_resource: CharacterStatResource, statName: String, newStatValue: float)
signal updateModifiers(updatedModifiersList: Array[ProjectileModifier])
signal displayHUDMessage(message: String)
signal requestCharacterStat()
signal respondCharacterStat(stats: CharacterStatResource)
signal requestProjectileModifiers()
signal respondProjectileModifiers(mods: Array[ProjectileModifier])
signal currentSpellInUse(spell: SpellDataResource)
