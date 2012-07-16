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

---------------------------------------
-- UNIT SPECIFIC FUNCTIONS

local initparam = function(self)
	self:SetSize(self.cfg.width, self.cfg.height)
	self:SetScale(self.cfg.scale)
	self:SetFrameLevel(1)
	self:SetPoint("TOPRIGHT",UIParent,"BOTTOM",-111,300)
	self.menu = func.menu
	self:RegisterForClicks("AnyDown")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
end


local createHealthBar = function(self)

	local s = CreateFrame("StatusBar", nil, self)
	s:SetStatusBarTexture(self.cfg.texture)
	s:SetHeight(self.cfg.height)
	s:SetWidth(self.cfg.width)
	s:SetPoint("CENTER",0,0)
	s:SetStatusBarColor(0.4,0.4,0.4)
    s.Smooth = true
		
	local h = CreateFrame("Frame", nil, s)
	h:SetFrameLevel(0)
	h:SetPoint("TOPLEFT",-5,5)
	h:SetPoint("BOTTOMRIGHT",5,-5)
	func.createBackdrop(h)

	local b = s:CreateTexture(nil, "BACKGROUND")
	b:SetTexture(0.5,0,0)
	b:SetAllPoints(s)
	b.multiplier = 0.3
	
	self.Health = s
	self.Health.bg = b
end

local createHealthStrings = function(self)
	
	local tagr = func.createFontString(self.Health , cfg.fontnumber , 35, "THINOUTLINE")
	tagr:SetPoint("RIGHT", self.Health, "RIGHT", 0, 0)
    tagr:SetJustifyH("RIGHT")
	self:Tag(tagr, self.cfg.health.tagr)

	local tagl = func.createFontString(self.Health , cfg.fontnumber , 20, "THINOUTLINE")
	tagl:SetPoint("LEFT", self.Health, "LEFT", 5, -1)
    tagl:SetJustifyH("LEFT")
	self:Tag(tagl, self.cfg.health.tagl)
		
end


local createShadowOrbs = function(self)

	local s = CreateFrame("Frame", nil, self)
  	s:SetFrameStrata("BACKGROUND")
  	s:SetHeight(self.cfg.height*0.6)
  	s:SetWidth(self.Health:GetWidth())
	s:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, -5)
	
	local h = CreateFrame("Frame", nil, s)
	h:SetFrameLevel(0)
	h:SetPoint("TOPLEFT",-5,5)
	h:SetPoint("BOTTOMRIGHT",5,-5)
	func.createBackdrop_thin(h)
	
	self.Info = s
	
	local ShadowOrbs = {}
	for index = 1, PRIEST_BAR_NUM_ORBS do
		local Orb = CreateFrame("Frame", nil, self)
	  	Orb:SetFrameStrata("LOW")
		
		local h = CreateFrame("Frame", nil, Orb)
		h:SetFrameLevel(0)
		h:SetPoint("TOPLEFT",-5,5)
		h:SetPoint("BOTTOMRIGHT",5,-5)
		func.createBackdrop_Orbs(h)
		
		
		if index == 1 then
		Orb:SetSize(self.cfg.height*2+10, self.cfg.height*0.6)
		Orb:SetPoint('TOPLEFT', self.Health, 'BOTTOMLEFT', 0, -5)
   		elseif index == 2 then
   		Orb:SetSize(self.cfg.height*2+10, self.cfg.height*0.6)
		Orb:SetPoint('TOPLEFT', self.Health, 'BOTTOMLEFT', (index-1) * (self.cfg.height*2+10+10), -5)
   		elseif index == 3 then
   		Orb:SetSize(self.cfg.height*3+20, self.cfg.height*0.6)
		Orb:SetPoint('TOPLEFT', self.Health, 'BOTTOMLEFT', (index-1) * (self.cfg.height*2+10+10), -5)
   		else
   		
   		end
		ShadowOrbs[index] = Orb
   	end
   
   -- Register with oUF
   self.ShadowOrbs = ShadowOrbs


end


local createPowerBar = function(self)

	local s = CreateFrame("StatusBar", nil, self)
	s:SetStatusBarTexture(self.cfg.texture)
	s:SetWidth(self.cfg.width)
	s:SetHeight(self.cfg.height*0.6)
	s:SetPoint("TOPRIGHT", self.Info, "BOTTOMRIGHT", 0, -5)
	s.colorClass = true
    s.Smooth = true
	
	local h = CreateFrame("Frame", nil, s)
	h:SetFrameLevel(0)
	h:SetPoint("TOPLEFT",-5,5)
	h:SetPoint("BOTTOMRIGHT",5,-5)
	func.createBackdrop(h)

	local b = s:CreateTexture(nil, "BACKGROUND")
	b:SetTexture(cfg.texture)
	b:SetAllPoints(s)
	b.multiplier = 0.3
	
	self.Power = s
	self.Power.bg = b
end

local createPowerStrings = function(self)
	
	local tagr = func.createFontString(self.Power , cfg.fonttext , 11, "OUTLINE")
	tagr:SetPoint("RIGHT", self.Power, "RIGHT", -2, 0)
    tagr:SetJustifyH("RIGHT")
	self:Tag(tagr, self.cfg.power.tagr)

	local tagl = func.createFontString(self.Power , cfg.fonttext , 11, "OUTLINE")
	tagl:SetPoint("LEFT", self.Power, "LEFT", 2, 0)
    tagl:SetJustifyH("LEFT")
	self:Tag(tagl, self.cfg.power.tagl)
	
end

---------------------------------------
-- CASTBAR

func.createCastbar = function(self)

	local width = 111*2-10

	local s = CreateFrame("StatusBar", "oUF_mokamPlayerCastbar" , self)
	s:SetSize(width , self.cfg.height*1.2+5)
	s:SetPoint("TOPLEFT",self.Info,"TOPRIGHT",5,0)
	s:SetStatusBarTexture(cfg.statusbar_texture)
	s:SetStatusBarColor(0.4,0.4,0.4)--(1,0.8,0,1)
	
	local h = CreateFrame("Frame", nil, s)
	h:SetFrameLevel(0)
	h:SetPoint("TOPLEFT",-5,5)
	h:SetPoint("BOTTOMRIGHT",5,-5)
	func.createBackdrop_thin(h)
	
	local b = s:CreateTexture(nil, "BACKGROUND")
	b:SetTexture(cfg.statusbar_texture)
	b:SetAllPoints(s)
	b:SetVertexColor(0.4*0.3,0.4*0.3,0.4*0.3,0.3)  
	
	local txt = func.createFontString(s, cfg.fonttext, 11, "THINOUTLINE")
	txt:SetPoint("LEFT", 2, 0)
	txt:SetJustifyH("LEFT")

	local sp = s:CreateTexture(nil, "OVERLAY")
	sp:SetBlendMode("ADD")
	sp:SetAlpha(0.5)
	sp:SetHeight(s:GetHeight()*2.5)

	local t = func.createFontString(s, cfg.font, 13, "THINOUTLINE")
	t:SetPoint("RIGHT", -2, 0)
	
	s.PostCastStart = func.PostCastStart
	s.PostChannelStart = func.PostCastStart
	
	self.Castbar = s
	--self.Castbar.Text = txt
	--self.Castbar.Time = t
		
end

local createBuffs = function(self)

	local b = CreateFrame("Frame", nil, self)
	b.size = self.cfg.height
	b.num = 28
	b.spacing = 10
	b.onlyShowPlayer = false
	b:SetHeight((b.size+b.spacing)*4)
	b:SetWidth(self.cfg.width)
	b:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 0, -10)
	b.initialAnchor = "TOPLEFT"
	b["growth-x"] = "RIGHT"
	b["growth-y"] = "DOWN"
	b.PostCreateIcon = func.createAuraIcon

	self.Buffs = b

end

local createDebuffs = function(self)

	local b = CreateFrame("Frame", nil, self)
	b.size = self.cfg.height*2+10
	b.num = 21
	b.spacing = 10
	b.onlyShowPlayer = false
	b:SetHeight((b.size+b.spacing)*3)
	b:SetWidth(self.cfg.width)
	b:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 10)
	b.initialAnchor = "BOTTOMLEFT"
	b["growth-x"] = "RIGHT"
	b["growth-y"] = "UP"
	b.PostCreateIcon = func.createAuraIcon

	self.Debuffs = b

end

---------------------------------------
-- PLAYER STYLE FUNC

local function createStyle(self)

	self.cfg = cfg.units.player
	self.cfg.style = "player"
	initparam(self)
	
	--bars
	createHealthBar(self)
	createShadowOrbs(self)
	createPowerBar(self)
	
	--aura
	createBuffs(self)
	createDebuffs(self)
	
	--castbar
	func.createCastbar(self)
	
	--portrait
	func.createPortrait(self)
	
	--strings
	createHealthStrings(self)
	createPowerStrings(self)
	
	--HealPredictionBar
	func.HealPrediction(self)
	
	unit.player = self

end

---------------------------------------
-- HANDOVER

-- object container to addons ns
--ns.unit = unit


---------------------------------------
-- SPAWN PLAYER UNIT

if cfg.units.player.show then
	oUF:RegisterStyle("mokam:player" , createStyle)
	oUF:SetActiveStyle("mokam:player")
	oUF:Spawn("player" , "oUF_mokamPlayerFrame")
end

