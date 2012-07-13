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
	self:SetPoint("TOPLEFT",oUF_mokamTargetFrame.Health,"TOPRIGHT",10,0)
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
	
	local tagr = func.createFontString(self.Health , cfg.fontnumber , 33, "OUTLINE")
	tagr:SetPoint("BOTTOMRIGHT", self.Health, "BOTTOMRIGHT", 0, -2)
    tagr:SetJustifyH("RIGHT")
	self:Tag(tagr, self.cfg.health.tagr)

	local tagl = func.createFontString(self.Health , cfg.fontnumber , 20, "THINOUTLINE")
	tagl:SetPoint("LEFT", self.Health, "LEFT", 5, -1)
    tagl:SetJustifyH("LEFT")
	self:Tag(tagl, self.cfg.health.tagl)
		
end

local createInfoBar = function(self)
	
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

end

local createInfoStrings = function(self)
	
	local tagr = func.createFontString(self.Info , cfg.fonttext , 11, "THINOUTLINE")
	tagr:SetPoint("RIGHT", self.Info, "RIGHT", -2, 0)
    tagr:SetJustifyH("RIGHT")
	self:Tag(tagr, self.cfg.info.tagr)

	local tagl = func.createFontString(self.Info , cfg.fonttext , 11, "THINOUTLINE")
	tagl:SetPoint("LEFT", self.Info, "LEFT", 2, 0)
    tagl:SetJustifyH("LEFT")
	self:Tag(tagl, self.cfg.info.tagl)
	
end

local createPowerBar = function(self)

	local s = CreateFrame("StatusBar", nil, self)
	s:SetStatusBarTexture(self.cfg.texture)
	s:SetWidth(self.cfg.width)
	s:SetHeight(self.cfg.height*0.6)
	s:SetPoint("TOPRIGHT", self.Info, "BOTTOMRIGHT", 0, -5)
	s.colorClass = true
	s.colorReaction = true
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
	
	local tagr = func.createFontString(self.Power , cfg.fonttext , 11, "THINOUTLINE")
	tagr:SetPoint("RIGHT", self.Power, "RIGHT", -2, 0)
    tagr:SetJustifyH("RIGHT")
	self:Tag(tagr, self.cfg.power.tagr)

	local tagl = func.createFontString(self.Power , cfg.fonttext , 11, "THINOUTLINE")
	tagl:SetPoint("LEFT", self.Power, "LEFT", 2, 0)
    tagl:SetJustifyH("LEFT")
	self:Tag(tagl, self.cfg.power.tagl)
	
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
	b.initialAnchor = "TOPRIGHT"
	b["growth-x"] = "LEFT"
	b["growth-y"] = "DOWN"
	b.PostCreateIcon = func.createAuraIcon

	self.Buffs = b

end

local createDebuffs = function(self)

	local b = CreateFrame("Frame", nil, self)
	b.size = self.cfg.height
	b.num = 14
	b.spacing = 10
	b.onlyShowPlayer = false
	b:SetHeight((b.size+b.spacing)*2)
	b:SetWidth(self.cfg.width)
	b:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 10)
	b.initialAnchor = "BOTTOMRIGHT"
	b["growth-x"] = "LEFT"
	b["growth-y"] = "UP"
	b.PostCreateIcon = func.createAuraIcon

	self.Debuffs = b

end

---------------------------------------
-- PLAYER STYLE FUNC

local function createStyle(self)

	self.cfg = cfg.units.targettarget
	self.cfg.style = "targettarget"
	
	initparam(self)
	
	--bars
	createHealthBar(self)
	createInfoBar(self)
	createPowerBar(self)
	
	--aura
	createBuffs(self)
	createDebuffs(self)
	
	--portrait
	func.createPortrait(self)
	
	--strings
	createHealthStrings(self)
	createInfoStrings(self)
	createPowerStrings(self)
	
	--HealPredictionBar
	func.HealPrediction(self)
	
	unit.targettarget = self
	
end

---------------------------------------
-- SPAWN PLAYER UNIT

if cfg.units.targettarget.show then
	oUF:RegisterStyle("mokam:targettarget" , createStyle)
	oUF:SetActiveStyle("mokam:targettarget")
	oUF:Spawn("targettarget" , "oUF_mokamTargetTargetFrame")
end

