Minimap:ClearAllPoints()
Minimap:SetPoint("TOPRIGHT", ouf_mokamMinimapFrame, "TOPRIGHT", -2, -2)
Minimap:SetSize(ouf_mokamMinimapFrame:GetWidth()-4, ouf_mokamMinimapFrame:GetWidth()-4)

local dummy = function() end
local _G = getfenv(0)


-- Hide Border
MinimapBorder:Hide()
MinimapBorderTop:Hide()

-- Hide Zoom Buttons
MinimapZoomIn:Hide()
MinimapZoomOut:Hide()

-- Hide Voice Chat Frame
MiniMapVoiceChatFrame:Hide()

-- Hide North texture at top
MinimapNorthTag:SetTexture(nil)

-- Hide Zone Frame
MinimapZoneTextButton:Hide()

-- Hide Tracking Button
MiniMapTracking:Hide()

-- Hide Calendar Button
GameTimeFrame:Hide()
MinimapCluster:EnableMouse(false)

--Tracking
MiniMapTrackingBackground:SetAlpha(0)
MiniMapTrackingButton:SetAlpha(0)
MiniMapTracking:ClearAllPoints()
MiniMapTracking:SetPoint("BOTTOMRIGHT", Minimap, 0, 0)
MiniMapTracking:SetScale(.9)



-- Hide world map button
MiniMapWorldMapButton:Hide()

local shadows = {
	edgeFile = "Interface\\Addons\\ouf_mokam\\addons\\qMinimap\\media\\glowTex", 
	edgeSize = 4,
	insets = { left = 3, right = 3, top = 3, bottom = 3 }
}
function CreateShadow(f)
	if f.shadow then return end
	local shadow = CreateFrame("Frame", nil, f)
	shadow:SetFrameLevel(1)
	shadow:SetFrameStrata(f:GetFrameStrata())
	shadow:SetPoint("TOPLEFT", -4, 4)
	shadow:SetPoint("BOTTOMRIGHT", 4, -4)
	shadow:SetBackdrop(shadows)
	shadow:SetBackdropColor(0, 0, 0, 0)
	shadow:SetBackdropBorderColor(0, 0, 0, 1)
	f.shadow = shadow
	return shadow
end
function CreateInnerBorder(f)
	if f.iborder then return end
	f.iborder = CreateFrame("Frame", nil, f)
	f.iborder:SetPoint("TOPLEFT", 1, -1)
	f.iborder:SetPoint("BOTTOMRIGHT", -1, 1)
	f.iborder:SetFrameLevel(f:GetFrameLevel())
	f.iborder:SetBackdrop({
	  edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1,
	  insets = { left = -1, right = -1, top = -1, bottom = -1}
	})
	f.iborder:SetBackdropBorderColor(0, 0, 0)
	return f.iborder
end
function frame1px(f)
	f:SetBackdrop({
		bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
        edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1, 
		insets = {left = -1, right = -1, top = -1, bottom = -1} 
	})
	f:SetBackdropColor(.06,.06,.06,1)
	f:SetBackdropBorderColor(.15,.15,.15,1)
CreateInnerBorder(f)	
end


-- Reposition lfg icon at bottom-left
local function UpdateLFG()
	MiniMapLFGFrame:ClearAllPoints()
	MiniMapLFGFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 2, 1)
	MiniMapLFGFrameBorder:Hide()
end

MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint("TOPRIGHT", Minimap, 0, 0)
MiniMapMailFrame:SetFrameStrata("LOW")
MiniMapMailIcon:SetTexture("Interface\\Addons\\ouf_mokam\\addons\\qMinimap\\media\\mail")
MiniMapMailBorder:Hide()

---Hide Instance Difficulty flag
MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:Hide()

-- Enable mouse scrolling
Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel", function(self, d)
	if d > 0 then
		_G.MinimapZoomIn:Click()
	elseif d < 0 then
		_G.MinimapZoomOut:Click()
	end
end)

----------------------------------------------------------------------------------------
-- Right click menu
----------------------------------------------------------------------------------------
local menuFrame = CreateFrame("Frame", "MinimapRightClickMenu", UIParent, "UIDropDownMenuTemplate")
local menuList = {
    {text = CHARACTER_BUTTON,
    func = function() ToggleCharacter("PaperDollFrame") end},
    {text = SPELLBOOK_ABILITIES_BUTTON,
    func = function() ToggleFrame(SpellBookFrame) end},
    {text = TALENTS_BUTTON,
    func = function() ToggleTalentFrame() end},
    {text = ACHIEVEMENT_BUTTON,
    func = function() ToggleAchievementFrame() end},
    {text = QUESTLOG_BUTTON,
    func = function() ToggleFrame(QuestLogFrame) end},
    {text = SOCIAL_BUTTON,
    func = function() ToggleFriendsFrame(1) end},
    {text = PLAYER_V_PLAYER,
    func = function() ToggleFrame(PVPFrame) end},
    {text = LFG_TITLE,
    func = function() ToggleFrame(LFDParentFrame) end},
    {text = L_LFRAID,
    func = function() ToggleFrame(LFRParentFrame) end},
    {text = HELP_BUTTON,
    func = function() ToggleHelpFrame() end},
    {text = SLASH_CALENDAR1:gsub("/(.*)","%1"), 
    func = function()
    if(not CalendarFrame) then LoadAddOn("Blizzard_Calendar") end
        Calendar_Toggle()
    end},
}

Minimap:SetScript("OnMouseUp", function(self, btn)
	if btn == "RightButton" then
		EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
	
	else
		Minimap_OnClick(self)
	end
end)

-- Set Square Map Mask
Minimap:SetMaskTexture('Interface\\ChatFrame\\ChatFrameBackground')

frame1px(Minimap)
CreateShadow(Minimap)

--[[ Clock ]]
if not IsAddOnLoaded("Blizzard_TimeManager") then
	LoadAddOn("Blizzard_TimeManager")
end

local clockFrame, clockTime = TimeManagerClockButton:GetRegions()
clockFrame:Hide()
clockTime:SetFont("Fonts\\FRIZQT__.ttf", 10, "OUTLINE")
clockTime:SetTextColor(1,1,1)
TimeManagerClockButton:SetPoint("BOTTOM", Minimap, "BOTTOM", 0, -1)
clockTime:Show()