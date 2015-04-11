Mageify = {}

-- Global State
-- ------------

Mageify.state = {
  lastSpell     = nil,
  isInBurnPhase = false,
  isInCombat    = false,
}

-- Event Handlers
-- --------------

Mageify.events = {}

-- Player is entering combat here
function Mageify.events:PLAYER_REGEN_DISABLED()
  self.state.isInCombat = true
end

function Mageify.events:PLAYER_REGEN_ENABLED()
  self.state.isInCombat = false
end

-- AddOn Initialization

function Mageify:Start()
  -- Wire up all event handlers declared on `event`.
  local addonFrame = CreateFrame("Frame");
  addonFrame:SetScript("OnEvent", function(_frame, event, ...)
    Mageify.events[event](Mageify, ...)
  end)
  for event, func in pairs(Mageify.events) do
    addonFrame:RegisterEvent(event)
  end

  local ticker = C_Timer.NewTicker(1/60, function()
    Mageify:SuggestSpell()
  end)
end

-- Helpers
-- -------

local function SpellCooldown(name)
  local _start, duration, _enabled = GetSpellCooldown(name)
  return duration or 0
end

local function PlayerMana()
  -- 0 indicates mana
  return UnitPower("player", 0) / UnitPowerMax("player", 0)
end

local function ConservePhase()
  if PlayerMana() > .93 then
    return "Arcane Blast"
  elseif BuffCount("Arcane Missiles!") > 0 then
    return "Arcane Missiles"
  elseif DebuffCount("Arcane Charge") > 0 then
    return "Arcane Barrage"
  end
end

local function DebuffCount(name)
  local _name, _rank, _icon, count = UnitDebuff("player", name)
  return count or 0
end

local function BuffCount(name)
  local _name, _rank, _icon, count = UnitBuff("player", name)
  return count or 0
end

-- Rotation Logic
-- --------------

-- The main entry point; this is called frequently (each frame), and evaluates
-- the next spell that the player should cast.
function Mageify:SuggestSpell()
  if not self.state.isInCombat then
    return
  end

  -- Burn/Conserve phase transitions:
  if not self.state.isInBurnPhase and DebuffCount("Arcane Charge") == 4 and SpellCooldown("Evocate") <= 15 and SpellCooldown("Arcane Power") == 0 and SpellCooldown("Prismatic Crystal") == 0 then
    self.state.isInBurnPhase = true
    print("Burn Phase")
  end
  if self.state.isInBurnPhase and BuffCount("Evocate") > 0 then
    self.state.isInBurnPhase = false
    print("Conserve Phase")
  end

  local spell
  if self.state.isInBurnPhase then
    spell = BurnPhase()
  else
    spell = ConservePhase()
  end
  if not spell then
    return
  end

  if spell ~= self.state.lastSpell then
    print(spell)
    self.state.lastSpell = spell
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

-- Entry Point
-- -----------
Mageify:Start()
