Mageify.frames = {}

--UI layout, suggested spell casts represented as icons here
---------

Mageify.frames.main = CreateFrame("Frame", nil , UIParent)
Mageify.frames.main:SetFrameStrata("BACKGROUND")
Mageify.frames.main:SetWidth(80)
Mageify.frames.main:SetHeight(80)

local t = Mageify.frames.main:CreateTexture(nil, "BACKGROUND")
t:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Factions.blp")
t:SetAllPoints(Mageify.frames.main)
Mageify.frames.main.texture = t

Mageify.frames.main:SetPoint("CENTER",0,0)
Mageify.frames.main:Hide()
