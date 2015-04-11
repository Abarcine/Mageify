local TRACKED_PLAYER_BUFFS = {
  "Arcane Brilliance",
  "Arcane Missiles!",
  "Dalaran Brilliance",
  "Evocation",
  "Incanter's Flow",
}
local TRACKED_PLAYER_DEBUFFS = {
  "Arcane Charge",
}
local TRACKED_PLAYER_SPELLS = {
  "Arcane Power",
  "Evocate",
  "Prismatic Crystal",
  "Supernova",
}

Mageify.Player = {}
Mageify.Player.__index = Mageify.Player

function Mageify.Player:New()
  local newPlayer = {
    mana    = UnitPower("player", 0),
    maxMana = UnitPowerMax("player", 0),
    buffs   = {},
    debuffs = {},
    spells  = {},
  }

  for i, name in ipairs(TRACKED_PLAYER_BUFFS) do
    newPlayer.buffs[name] = Mageify.Aura:New(name, true)
  end
  for i, name in ipairs(TRACKED_PLAYER_DEBUFFS) do
    newPlayer.debuffs[name] = Mageify.Aura:New(name, false)
  end
  for i, name in ipairs(TRACKED_PLAYER_SPELLS) do
    newPlayer.spells[name] = Mageify.Spell:New(name)
  end

  return setmetatable(newPlayer, self)
end

-- Stat Helpers

function Mageify.Player:Mana()
  return self.mana / self.maxMana
end

-- Buff/Debuff/Spell Helpers

function Mageify.Player:HasBuff(name)
  return self.buffs[name].count
end

function Mageify.Player:BuffCount(name)
  return self.buffs[name].count or 0
end

function Mageify.Player:HasDebuff(name)
  return self.debuffs[name].count
end

function Mageify.Player:DebuffCount(name)
  return self.debuffs[name].count or 0
end

function Mageify.Player:Cooldown(name)
  return self.spells[name].cooldown or 0
end
