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

	local tagl = func.createFontString(self.Health , cfg.fontnumber , 19, "OUTLINE")
	tagl:SetPoint("LEFT", self.Health, "LEFT", 5, 0)
    tagl:SetJustifyH("LEFT")
	self:Tag(tagl, self.cfg.health.tagl)
		
end

local createPowerBar = function(self)

	local s = CreateFrame("StatusBar", nil, self)
	s:SetStatusBarTexture(self.cfg.texture)
	s:SetWidth(self.cfg.width)
	s:SetHeight(self.cfg.height*0.3)
	s:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", 0, -5)
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
	
	local tagr = func.createFontString(self.Power , cfg.fontnumber , 15, "OUTLINE")
	tagr:SetPoint("RIGHT", self.Power, "RIGHT", -2, 0)
    tagr:SetJustifyH("RIGHT")
	self:Tag(tagr, self.cfg.power.tagr)

	local tagl = func.createFontString(self.Power , cfg.fontnumber , 15, "OUTLINE")
	tagl:SetPoint("LEFT", self.Power, "LEFT", 2, 0)
    tagl:SetJustifyH("LEFT")
	self:Tag(tagl, self.cfg.power.tagl)
	
end

---------------------------------------
-- CASTBAR

func.createCastbar = function(self)

	local s = CreateFrame("StatusBar", "oUF_mokamFocusCastbar" , self.Health)
	s:SetSize(self.Health:GetWidth(), self.cfg.height)
	s:SetPoint("TOPLEFT",self.Health,"TOPLEFT",0,0)
	s:SetStatusBarTexture(cfg.statusbar_texture)
	--s:SetStatusBarColor(1,0,0)
	
	local h = CreateFrame("Frame", nil, s)
	h:SetFrameLevel(0)
	h:SetPoint("TOPLEFT",-5,5)
	h:SetPoint("BOTTOMRIGHT",5,-5)
	func.createBackdrop_thin(h)
	
	local b = s:CreateTexture(nil, "BACKGROUND")
	b:SetTexture(cfg.statusbar_texture)
	b:SetAllPoints(s)
	b:SetVertexColor(0.4*0.3,0.4*0.3,0.4*0.3,0.3)  
	
	local txt = func.createFontString(s, cfg.font, 15, "THINOUTLINE")
	txt:SetPoint("LEFT", s, "LEFT", 5, 0)
	txt:SetJustifyH("LEFT")

	local sp = s:CreateTexture(nil, "OVERLAY")
	sp:SetBlendMode("ADD")
	sp:SetAlpha(0.5)
	sp:SetHeight(s:GetHeight()*2.5)

	local t = func.createFontString(s, cfg.font, 13, "THINOUTLINE")
	t:SetPoint("RIGHT", -2, 0)

	local i = s:CreateTexture(nil, "ARTWORK")
	i:SetWidth(self.cfg.height)
	i:SetHeight(self.cfg.height)
	i:SetPoint("TOPRIGHT", s, "TOPLEFT", -10, 0)
	i:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	
	local h2 = CreateFrame("Frame", nil, s)
	h2:SetFrameLevel(0)
	h2:SetPoint("TOPLEFT",i,"TOPLEFT",-5,5)
	h2:SetPoint("BOTTOMRIGHT",i,"BOTTOMRIGHT",5,-5)
	func.createBackdrop_thin(h2)
		
	s.PostCastStart = func.PostCastStart
	s.PostChannelStart = func.PostCastStart
	
	self.Castbar = s
	self.Castbar.Text = txt
	self.Castbar.Icon = i
	--self.Castbar.Time = t
		
end

local createBuffs = function(self)

	local b = CreateFrame("Frame", nil, self)
	b.size = self.cfg.height
	b.num = 2
	b.spacing = 10
	b.onlyShowPlayer = false
	b:SetHeight((b.size+b.spacing))
	b:SetWidth(self.cfg.width)
	b:SetPoint("BOTTOMRIGHT", self.Health, "TOPRIGHT", 0, 10)
	b.initialAnchor = "BOTTOMRIGHT"
	b["growth-x"] = "LEFT"
	b["growth-y"] = "UP"
	b.onlyShowPlayer = true 
	b.PostCreateIcon = func.createAuraIcon

	self.Buffs = b

end

local createDebuffs = function(self)

	local b = CreateFrame("Frame", nil, self)
	b.size = self.cfg.height
	b.num = 3
	b.spacing = 10
	b.onlyShowPlayer = false
	b:SetHeight((b.size+b.spacing))
	b:SetWidth(self.cfg.width)
	b:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 10)
	b.initialAnchor = "BOTTOMLEFT"
	b["growth-x"] = "RIGHT"
	b["growth-y"] = "UP"
	b.onlyShowPlayer = false 
	b.PostCreateIcon = func.createAuraIcon

	self.Debuffs = b

end

---------------------------------------
-- BOSS STYLE FUNC

local bossid = 1
unit.boss = {}

local function createStyle(self)

	self.cfg = cfg.units.boss
	self.cfg.style = "boss"
	
	self.cfg.width = unit.frame.Minimap:GetWidth()
	self.cfg.height = 20
	
	initparam(self)
	
	--bars
	createHealthBar(self)
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
		
	unit.boss[bossid] = self
	
	bossid = bossid + 1
		
end

---------------------------------------
-- SPAWN BOSS UNITS

if cfg.units.boss.show then
	oUF:RegisterStyle("mokam:boss", createStyle)
    oUF:SetActiveStyle("mokam:boss")
    local boss = {}
    for i = 1, MAX_BOSS_FRAMES do
      local name = "oUF_mokamBossFrame"..i
      local unit = oUF:Spawn("boss"..i, name)
      if i==1 then
        unit:SetPoint("BOTTOMRIGHT",ns.unit.frame.Minimap,"TOPRIGHT",0,130)
      else
        unit:SetPoint("BOTTOM", boss[i-1], "TOP", 0, 20+40)
      end
      boss[i] = unit
    end
end

