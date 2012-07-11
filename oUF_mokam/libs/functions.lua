--get the addon namespace
local addon, ns = ...

--get oUF namespace (just in case needed)
local oUF = ns.oUF or oUF

--get the config
local cfg = ns.cfg

--object container
local func = CreateFrame("Frame")

---------------------------------------
-- FUNCTIONS

--menu function from phanx
local dropdown = CreateFrame("Frame", "oUF_mokamUnitMenu", UIParent, "UIDropDownMenuTemplate")

UIDropDownMenu_Initialize(dropdown, function(self)
	local unit = self:GetParent().unit
	if not unit then return end
	local menu, name, id
	if UnitIsUnit(unit, "player") then
		menu = "SELF"
	elseif UnitIsUnit(unit, "vehicle") then
		menu = "VEHICLE"
	elseif UnitIsUnit(unit, "pet") then
		menu = "PET"
	elseif UnitIsPlayer(unit) then
		id = UnitInRaid(unit)
		if id then
			menu = "RAID_PLAYER"
			name = GetRaidRosterInfo(id)
		elseif UnitInParty(unit) then
			menu = "PARTY"
		else
			menu = "PLAYER"
		end
	else
		menu = "TARGET"
		name = RAID_TARGET_ICON
	end
	if menu then
		UnitPopup_ShowMenu(self, menu, unit, name, id)
	end
end, "MENU")

func.menu = function(self)
	dropdown:SetParent(self)
	ToggleDropDownMenu(1, nil, dropdown, "cursor", 0, 0)
end

---------------------------------------

func.createFontString = function(self, name, size, outline)
	local fs = self:CreateFontString(nil, layer or "OVERLAY")
	fs:SetFont(name, size, outline)
	fs:SetShadowColor(0,0,0,0.3)
	return fs
end

func.createPortrait = function(self)
	local p = CreateFrame("PlayerModel", nil, self)
	p:SetAllPoints(self.Health)
	p:SetAlpha(0.4)
	self.Portrait = p
end

func.createAuraIcon = function(icons , button)

	button.cd:SetReverse()
	button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	button.icon:SetDrawLayer("BACKGROUND")
	--count
	button.count:ClearAllPoints()
	button.count:SetJustifyH("RIGHT")
	button.count:SetPoint("TOPRIGHT", 2, 2)
	button.count:SetTextColor(0.7,0.7,0.7)
			
	--helper
	local h = CreateFrame("Frame", nil, button)
	h:SetFrameLevel(0)
	h:SetPoint("TOPLEFT",-5,5)
	h:SetPoint("BOTTOMRIGHT",5,-5)
	func.createBackdrop(h)

end

func.HealPrediction = function(self)
	local w = self.Health:GetWidth(w)
	local mhpb = CreateFrame('StatusBar', nil, self)
	mhpb:SetPoint('TOPLEFT', self.Health:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
	mhpb:SetPoint('BOTTOMLEFT', self.Health:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
	mhpb:SetWidth(w)
	mhpb:SetStatusBarTexture(cfg.statusbar_texture)
	mhpb:SetStatusBarColor(0, 1, 0.5, 0.7)

	local ohpb = CreateFrame('StatusBar', nil, self)
	ohpb:SetPoint('TOPLEFT', mhpb:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
	ohpb:SetPoint('BOTTOMLEFT', mhpb:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
	ohpb:SetWidth(w)
	ohpb:SetStatusBarTexture(cfg.statusbar_texture)
	ohpb:SetStatusBarColor(0, 1, 0, 0.7)
	
	-- Register it with oUF
	self.HealPrediction = {
	-- status bar to show my incoming heals
	myBar = mhpb,
	
	-- status bar to show other peoples incoming heals
	otherBar = ohpb,
	
	-- amount of overflow past the end of the health bar
	maxOverflow = 1.05,
	}
end

---------------------------------------
-- CASTBAR

func.PostCastStart = function(self, unit, name, rank, text)
	if UnitIsPlayer(unit) then
		r , g , b = unpack(oUF.colors.class[select(2, UnitClass(unit))])
	elseif self.interrupt then
		print("KICKBAR")
		r, g, b = 255 , 255 , 0
	else
		r , g , b = unpack(oUF.colors.reaction[UnitReaction(unit, "player")])
	end
	
	self:SetStatusBarColor(r, g, b)

end

---------------------------------------
-- BACKDROP

local backdrop_tab = { 
	bgFile = cfg.backdrop_texture, 
	edgeFile = cfg.backdrop_edge_texture,
	tile = false,
	tileSize = 0, 
	edgeSize = 5, 
	insets = { 
  		left = 5, 
  		right = 5, 
  		top = 5, 
  		bottom = 5,
	},
}

func.createBackdrop = function(self)
	self:SetBackdrop(backdrop_tab);
	self:SetBackdropColor(0,0,0,0.8)
	self:SetBackdropBorderColor(0,0,0,1)
end

func.createBackdrop_thin = function(self)
	self:SetBackdrop(backdrop_tab);
	self:SetBackdropColor(0,0,0,0.5)
	self:SetBackdropBorderColor(0,0,0,0.7)
end

func.createBackdrop_bar = function(self)
	self:SetBackdrop(backdrop_tab);
	self:SetBackdropColor(0,0,0,0)
	self:SetBackdropBorderColor(0,0,0,0.9)
end

---------------------------------------
-- HANDOVER

-- object container to addons ns
ns.func = func
