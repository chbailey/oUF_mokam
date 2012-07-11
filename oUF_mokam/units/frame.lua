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

--help container
local frame = CreateFrame("Frame")

local createBarFrame = function()

	local width = floor(unit.target.Health:GetLeft()+0.5)-floor(unit.player.Health:GetRight()+0.5)-10

	for index = 0 , 7 do
		local s = CreateFrame("Frame", "ouf_mokamBarFrame", UIParent)
		s:SetFrameStrata("HIGH")
		s:SetSize((width-35)/8 , 20)
		s:SetPoint("BOTTOMLEFT", unit.player.Health , "BOTTOMRIGHT" , index*((width-35)/8+5)+5 , 0)
		
		local h = CreateFrame("Frame", nil, s)
		h:SetFrameLevel(0)
		h:SetPoint("TOPLEFT",-5,5)
		h:SetPoint("BOTTOMRIGHT",5,-5)
		func.createBackdrop_bar(h)
		
		s:Show()
	end

--[[local s = CreateFrame("Frame", "ouf_mokamBarFrame", UIParent)
	s:SetFrameStrata("BACKGROUND")
	s:SetPoint("BOTTOMLEFT", unit.player.Health , "BOTTOMRIGHT" , 5 , 0)
	s:SetSize(width , 20)
	
	local h = CreateFrame("Frame", nil, s)
	h:SetFrameLevel(0)
	h:SetPoint("TOPLEFT",-5,5)
	h:SetPoint("BOTTOMRIGHT",5,-5)
	func.createBackdrop_thin(h)
	
	s:Show()]]
	
	frame.Bar = s	
		
end

local createBLFrame = function()
	
	local s = CreateFrame("Frame", "ouf_mokamChatFrame", UIParent)
  	s:SetFrameStrata("BACKGROUND")
	s:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 10,10)
	s:SetPoint("TOPRIGHT", UIParent, "BOTTOMLEFT",unit.player.Health:GetWidth()*2.75,unit.player.Buffs:GetTop()-10-20)
	
	local h = CreateFrame("Frame", nil, s)
	h:SetFrameLevel(0)
	h:SetPoint("TOPLEFT",-5,5)
	h:SetPoint("BOTTOMRIGHT",5,-5)
	func.createBackdrop_thin(h)
	
	s:Show()
	frame.Chat = s

end

local createBRFrame = function()
	
	--balken für raidbuffs
	local s = CreateFrame("Frame", nil, UIParent)
  	s:SetFrameStrata("BACKGROUND")
	s:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -10,10)
	s:SetSize(frame.Chat:GetHeight()-20-10,20)
	
	local h = CreateFrame("Frame", nil, s)
	h:SetFrameLevel(0)
	h:SetPoint("TOPLEFT",-5,5)
	h:SetPoint("BOTTOMRIGHT",5,-5)
	func.createBackdrop_thin(h)
	
	s:Show()
	frame.RaidBuff = s
	
	--minimap
	local s = CreateFrame("Frame", "ouf_mokamMinimapFrame", UIParent)
  	s:SetFrameStrata("BACKGROUND")
	s:SetPoint("BOTTOMRIGHT", frame.RaidBuff, "TOPRIGHT", 0, 10)
	s:SetHeight(frame.Chat:GetHeight()-frame.RaidBuff:GetTop())
	s:SetWidth(s:GetHeight())
	
	local h = CreateFrame("Frame", nil, s)
	h:SetFrameLevel(0)
	h:SetPoint("TOPLEFT",-5,5)
	h:SetPoint("BOTTOMRIGHT",5,-5)
	func.createBackdrop_thin(h)
	
	s:Show()
	frame.Minimap = s
		
	--skada
	local s = CreateFrame("Frame", nil, UIParent)
  	s:SetFrameStrata("BACKGROUND")
	s:SetPoint("BOTTOMRIGHT", frame.RaidBuff, "BOTTOMLEFT", -10, 0)
	s:SetPoint("TOPRIGHT", frame.Minimap, "TOPLEFT", -10, 0)
	s:SetWidth(220)--frame.Chat:GetWidth()-frame.Minimap:GetWidth()-10
	
	local h = CreateFrame("Frame", nil, s)
	h:SetFrameLevel(0)
	h:SetPoint("TOPLEFT",-5,5)
	h:SetPoint("BOTTOMRIGHT",5,-5)
	func.createBackdrop_thin(h)
	
	s:Show()
	frame.skada = s

end


	
		
--frames

--createBarFrame()
createBLFrame()
createBRFrame()


ns.unit = unit