Mageify = {}
MageifyState = {}

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
  self.frames.main:Show()
end

function Mageify.events:PLAYER_REGEN_ENABLED()
  self.state.isInCombat = false
  self.frames.main:Hide()
end

function Mageify.events:PLAYER_LOGOUT()
  local point, relativeTo, relativePoint, xOffset, yOffset = Mageify.frames.main:GetPoint(1)
  MageifyState.mainFramePoint = {
    point         = point,
    relativePoint = relativePoint,
    xOffset       = xOffset,
    yOffset       = yOffset,
  }
end

function Mageify.events:ADDON_LOADED()
  local framePoint = MageifyState.mainFramePoint
  if not framePoint then
    return
  end
  Mageify.frames.main:SetPoint(framePoint.point, nil, framePoint.relativePoint, framePoint.xOffset, framePoint.yOffset)
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

-- Rotation Logic
-- --------------

-- The main entry point; this is called frequently (each frame), and evaluates
-- the next spell that the player should cast.
function Mageify:SuggestSpell()
  local player = Mageify.Player:New()

  if not self.state.isInCombat then
    return
  end

  -- Burn/Conserve phase transitions:
  if not self.state.isInBurnPhase and player:DebuffCount("Arcane Charge") == 4 and player:Cooldown("Evocate") <= 15 and player:Cooldown("Arcane Power") == 0 and player:Cooldown("Prismatic Crystal") == 0 then
    self.state.isInBurnPhase = true
    print("Burn Phase")
  end
  if self.state.isInBurnPhase and player:HasBuff("Evocation") then
    self.state.isInBurnPhase = false
    print("Conserve Phase")
  end

  local spell
  if self.state.isInBurnPhase then
    spell = self:BurnPhase(player)
  else
    spell = self:ConservePhase(player)
  end
  if not spell then
    return
  end

  if spell ~= self.state.lastSpell then
    local _name, _rank, icon = GetSpellInfo(spell)
    if not icon then
      print("Error Icon not returned for spell", spell)
    end
    Mageify.frames.main.texture:SetTexture(icon)
    self.state.lastSpell = spell
  end
end

function Mageify:BurnPhase(player)
  if player:Mana() > .7  and player:HasBuff("Arcane Missiles!") then
    return "Arcane Missiles"
  elseif player:Mana() > .5 then
    return "Arcane Blast"
  elseif player:Mana() < .5 then
    return "Evocation"
  end
end

function Mageify:ConservePhase(player)
  if player:Mana() > .93 then
    return "Arcane Blast"
  elseif player:HasBuff("Arcane Missiles!") then
    return "Arcane Missiles"
  elseif player:HasDebuff("Arcane Charge") then
    return "Arcane Barrage"
  end
end

-- Entry Point
-- -----------
Mageify:Start()
