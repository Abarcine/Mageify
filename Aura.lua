Mageify.Aura = {}
Mageify.Aura.__index = Mageify.Aura

function Mageify.Aura:New(name, isBuff)
  local filter = isBuff and 'HELPFUL' or 'HARMFUL'
  local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitAura("player", name, nil, filter)
  return setmetatable({
    name              = name,
    rank              = rank,
    icon              = icon,
    count             = count,
    debuffType        = debuffType,
    duration          = duration,
    expirationTime    = expirationTime,
    unitCaster        = unitCaster,
    isStealable       = isStealable,
    shouldConsolidate = shouldConsolidate,
    spellId           = spellId,
  }, self)
end
