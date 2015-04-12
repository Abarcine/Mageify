Mageify.frames = {}

--UI layout, suggested spell casts represented as icons here
---------

Mageify.frames.main = CreateFrame("Frame", nil, UIParent)
Mageify.frames.main:SetFrameStrata("BACKGROUND")
Mageify.frames.main:SetWidth(80)
Mageify.frames.main:SetHeight(80)
Mageify.frames.main:SetMovable(true)
Mageify.frames.main:EnableMouse(true)

local titleRegion = Mageify.frames.main:CreateTitleRegion()
titleRegion:SetAllPoints(Mageify.frames.main)

local t = Mageify.frames.main:CreateTexture(nil, "BACKGROUND")
t:SetAllPoints(Mageify.frames.main)
Mageify.frames.main.texture = t

Mageify.frames.main:SetPoint("CENTER", 0, 0)
Mageify.frames.main:Hide()
