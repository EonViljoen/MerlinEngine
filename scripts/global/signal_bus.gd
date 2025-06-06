extends Node

signal statUpdate(statName: String, newStatValue: float)
signal updateModifiers(updatedModifiersList: Array[ProjectileModifier])
signal displayHUDMessage(message: String)
signal requestCharacterStat()
signal respondCharacterStat(stats: CharacterStatResource)
signal requestProjectileModifiers()
signal respondProjectileModifiers(mods: Array[ProjectileModifier])
signal currentSpellInUse(spell: SpellDataResource)
signal enemyDamage(damage: float)
signal playerDeath(player: RigidBody2D)
signal enemyDeath(enemy: RigidBody2D)
