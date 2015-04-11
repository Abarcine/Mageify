Mageify.Spell = {}
Mageify.Spell.__index = Mageify.Spell

function Mageify.Spell:New(name)
  local cooldownStart, cooldown, enabled = GetSpellCooldown(name);
  return setmetatable({
    name          = name,
    cooldownStart = cooldownStart,
    cooldown      = cooldown,
    enabled       = enabled,
  }, self)
end
