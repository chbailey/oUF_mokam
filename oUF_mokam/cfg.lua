---------------------------------------
-- oUF_mokam

--get the addon namespace
local addons, ns = ...

--object container
local cfg = CreateFrame("Frame")



---------------------------------------
-- CONFIG

---------------------------------------
-- units

cfg.units = {
	-- player
	player = {
		show = true,
		width = 20*7+10*6,
		height = 20,
		scale = 1,
		texture = "Interface\\AddOns\\oUF_mokam\\media\\statusbar512x64",
		health = {
			tagl = "[makom:classcolor][makom:perhp]",
			tagr = "[makom:classcolor][makom:hp]"
		},
		power = {
			tagl = "[makom:classcolor][makom:perpp]",
			tagr = "[makom:classcolor][makom:curpp][makom:maxpp]"
		}	
	},
	target = {
		show = true,
		width = 20*7+10*6,
		height = 20,
		scale = 1,
		texture = "Interface\\AddOns\\oUF_mokam\\media\\statusbar512x64",
		health = {
			tagl = "[makom:classcolor][makom:perhp]",
			tagr = "[makom:classcolor][makom:hp]"
		},
		info = {
			tagl = "[makom:classcolor][mono:longname]",
			tagr = "[makom:classcolor][smartlevel]"
		},
		power = {
			tagl = "[makom:classcolor][makom:perpp]",
			tagr = "[makom:classcolor][makom:curpp][makom:maxpp]"
		}
	},
	targettarget = {
		show = true,
		width = 4*20+3*10,
		height = 20,
		scale = 1,
		texture = "Interface\\AddOns\\oUF_mokam\\media\\statusbar512x64",
		health = {
			tagl = "",
			tagr = ""
		},
		info = {
			tagl = "[makom:classcolor][mono:longnametot]",
			tagr = ""
		},
		power = {
			tagl = "",
			tagr = ""
		}
	},
	focus = {
		show = true,
		width = 20*7+10*6,
		height = 20,
		scale = 1,
		texture = "Interface\\AddOns\\oUF_mokam\\media\\statusbar512x64",
		health = {
			tagl = "[makom:classcolor][mono:longname]",
			tagr = ""
		},
		power = {
			tagl = "",
			tagr = ""
		}
	},
	boss = {
		show = true,
		scale = 1,
		texture = "Interface\\AddOns\\oUF_mokam\\media\\statusbar512x64",
		health = {
			tagl = "[makom:classcolor][mono:longname]",
			tagr = ""
		},
		power = {
			tagl = "",
			tagr = ""
		}
	},
	frame = {
		show = true
	}
}

cfg.statusbar_texture = "Interface\\AddOns\\oUF_mokam\\media\\statusbar512x64"
cfg.backdrop_texture = "Interface\\AddOns\\oUF_mokam\\media\\backdrop"
cfg.backdrop_edge_texture = "Interface\\AddOns\\oUF_mokam\\media\\backdrop_edge"
cfg.fontnumber = "Interface\\AddOns\\oUF_mokam\\media\\Antipasto_edit.ttf"
cfg.font = "Interface\\AddOns\\oUF_mokam\\media\\Antipasto_edit.ttf"
cfg.fonttext  = "Interface\\Addons\\oUF_mokam\\media\\Myriad-web.ttf"

BuffFrame:Hide()


---------------------------------------
-- HANDOVER
 
-- object container to addons ns
ns.cfg = cfg