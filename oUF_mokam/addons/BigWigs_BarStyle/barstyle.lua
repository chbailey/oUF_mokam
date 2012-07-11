--get the addon namespace
local addon, ns = ...

--get oUF namespace (just in case needed)
local oUF = ns.oUF or oUF

--get the config
local cfg = ns.cfg

--get the functions
local func = ns.func

--get the unit container
local unit = ns.unit


local freeBackgrounds = {}

local function createBackground()
	local bg = CreateFrame("Frame")
	func.createBackdrop(bg)
	return bg
end

local function freeStyle(bar)
	local bg = bar:Get("bigwigs:ouf_mokam:bg")
	if not bg then return end
	bg:SetParent(UIParent)
	bg:Hide()
	freeBackgrounds[#freeBackgrounds + 1] = bg
end

local function styleBar(bar)
	local bg = nil
	if #freeBackgrounds > 0 then
		bg = table.remove(freeBackgrounds)
	else
		bg = createBackground()
	end
	bg:SetParent(bar)
	bg:ClearAllPoints()
	bg:SetPoint("TOPLEFT", bar, "TOPLEFT", -5, 5)
	bg:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 5, -5)
	bg:SetFrameStrata("BACKGROUND")
	bg:Show()
	bar:Set("bigwigs:ouf_mokam:bg", bg)
end


local f = CreateFrame("Frame")
local function registerMyStyle()
if not BigWigs then return end
local bars = BigWigs:GetPlugin("Bars", true)
if not bars then return end
f:UnregisterEvent("ADDON_LOADED")
f:UnregisterEvent("PLAYER_LOGIN")
bars:RegisterBarStyle("identifier", {
	apiVersion = 1,
	version = 1,
	GetSpacing = function(bar)
		return 7
	end,
	ApplyStyle = styleBar,
	BarStopped = freeStyle,
	GetStyleName = function()
		return "oUF_mokam"
	end,
	})
end
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_LOGIN")

local reason = nil
f:SetScript("OnEvent", function(self, event, msg)
	if event == "ADDON_LOADED" then
		if not reason then reason = (select(6, GetAddOnInfo("BigWigs_Plugins"))) end
		if (reason == "MISSING" and msg == "BigWigs") or msg == "BigWigs_Plugins" then
			registerMyStyle()
		end
	elseif event == "PLAYER_LOGIN" then
		registerMyStyle()
	end
end)