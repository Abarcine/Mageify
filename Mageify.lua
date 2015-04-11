local events = {}
local lastSpell
local isInBurnPhase = false
local isInCombat = false
-- Player is entering combat here
function events:PLAYER_REGEN_DISABLED()
  isInCombat = true
end
function events:PLAYER_REGEN_ENABLED()
  isInCombat = false
end

function SuggestSpell()
  if  not isInCombat  then
   return
  end

  if not isInBurnPhase and DebuffCount("Arcane Charge") == 4 and SpellCooldown("Evocate") <= 15 and SpellCooldown("Arcane Power") == 0 and SpellCooldown("Prismatic Crystal") == 0 then
    isInBurnPhase = true
    print("Burn Phase")
  end
  if isInBurnPhase and BuffCount("Evocate") > 0 then
    isInBurnPhase = false
    print("Conserve Phase")
  end

  local spell
  if isInBurnPhase then
    spell = BurnPhase()
  else
    spell = ConservePhase()
  end
  if not spell then
    return
  end

  if spell ~= lastSpell then
    print(spell)
    lastSpell = spell
  end
end

function BurnPhase()
  if  PlayerMana() > .7  and BuffCount("Arcane Missiles!") then
    return "Arcane Missiles"
  elseif PlayerMana() > .5 then
    return "Arcane Blast"
  elseif PlayerMana() < .5 then
    return "Evocate Now!"
  end
end

function SpellCooldown(name)
  local _start, duration, _enabled = GetSpellCooldown(name)
  return duration or 0
end

function PlayerMana()
  local mana = UnitPower("player", 0) -- 0 indicates mana
  local maxpower = UnitPowerMax("player", 0)
  return mana / maxpower
end

function ConservePhase()
  if PlayerMana() > .93 then
    return "Arcane Blast"
  elseif BuffCount("Arcane Missiles!") > 0 then
    return "Arcane Missiles"
  elseif DebuffCount("Arcane Charge") > 0 then
    return "Arcane Barrage"
  end
end
function DebuffCount(name)
  local _name, _rank, _icon, count = UnitDebuff("player", name)
  return count or 0
end
function BuffCount(name)
  local _name, _rank, _icon, count = UnitBuff("player", name)
  return count or 0
end
local ticker = C_Timer.NewTicker(1/60, SuggestSpell)

local addonFrame = CreateFrame("Frame");
addonFrame:SetScript("OnEvent", function(self, event, ...)
  events[event](...)
end)
for event, func in pairs(events) do
  addonFrame:RegisterEvent(event)
end
