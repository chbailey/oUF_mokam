local SVal = function(val)
	if val then
		if (val >= 1e6) then
	        return ("%.1fm"):format(val / 1e6)
		elseif (val >= 1e3) then
			return ("%.1fk"):format(val / 1e3)
		else
			return ("%d"):format(val)
		end
	end
end

---------------------------------------------

-- calculating the ammount of latters
local function utf8sub(string, i, dots)
	if string then
		local bytes = string:len()
		if bytes <= i then
			return string
		else
			local len, pos = 0, 1
			while pos <= bytes do
				len = len + 1
				local c = string:byte(pos)
				if c > 0 and c <= 127 then
					pos = pos + 1
				elseif c >= 192 and c <= 223 then
					pos = pos + 2
				elseif c >= 224 and c <= 239 then
					pos = pos + 3
				elseif c >= 240 and c <= 247 then
					pos = pos + 4
				end
				if len == i then
					break
				end
			end
			if len == i and pos <= bytes then
				return string:sub(1, pos - 1)--..(dots and '..' or '')
			else
				return string
			end
		end
	end
end


oUF.Tags.Methods['makom:classcolor'] = function(unit)
	local reaction = UnitReaction(unit, "player")
	if UnitIsPlayer(unit) then
		local s = oUF.Tags.Methods["raidcolor"](unit)
		return s
	elseif reaction then
		local r , g , b = unpack(oUF.colors.reaction[reaction])
		return string.format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
	else
		local r, g, b = 0.84,0.75,0.65
		return string.format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
	end
end
oUF.Tags.Events['makom:classcolor'] = 'UNIT_POWER'

---------------------------------------------

-- unit status tag
oUF.Tags.Methods['mono:DDG'] = function(u)
	if not UnitIsConnected(u) then
		return "|cffCFCFCF D/C|r"
	elseif UnitIsGhost(u) then
		return "|cffCFCFCF Ghost|r"
	elseif UnitIsDead(u) then
		return "|cffCFCFCF Dead|r"
	end
end
oUF.Tags.Events['mono:DDG'] = 'UNIT_NAME_UPDATE UNIT_HEALTH UNIT_CONNECTION'

---------------------------------------------

oUF.Tags.Methods['makom:hp']  = function(u)
  if UnitIsDead(u) or UnitIsGhost(u) or not UnitIsConnected(u) then
    return oUF.Tags.Methods['mono:DDG'](u)
  else
	local curhp = UnitHealth(u)
    if (u == "target" or u == "player") then
	  return SVal(curhp)
	else
	  return SVal(curhp)
	end
  end
end
oUF.Tags.Events['makom:hp'] = 'UNIT_HEALTH UNIT_CONNECTION'

---------------------------------------------

oUF.Tags.Methods['makom:perhp']  = function(u)
	if UnitIsDead(u) or UnitIsGhost(u) or not UnitIsConnected(u) then
		return --oUF.Tags.Methods['mono:DDG'](u)
	else
		local per = oUF.Tags.Methods['perhp'](u)
		if ((u == "target" or u == "player") and per~=100) then
			local mult = 10^(1)
			local perhp = 100*UnitHealth(u)/UnitHealthMax(u)
			return math.floor(perhp * mult + 0.5) / mult
		else
			return
		end
	end
end
oUF.Tags.Events['makom:perhp'] = 'UNIT_HEALTH UNIT_CONNECTION'

---------------------------------------------

oUF.Tags.Methods['makom:perpp']  = function(u)
	local per = oUF.Tags.Methods['perpp'](u)
	if ((u == "target" or u == "player") and (per~=100 and per~=0)) then
		return per
	else
		return
	end
end
oUF.Tags.Events['makom:perpp'] = 'UNIT_POWER UNIT_CONNECTION'

---------------------------------------------

oUF.Tags.Methods['makom:curpp']  = function(u)
	local curpp = UnitPower(u)
	if curpp ~= 0 then
		return SVal(curpp)
	end
	return
end
oUF.Tags.Events['makom:curpp'] = 'UNIT_POWER UNIT_CONNECTION'

---------------------------------------------

oUF.Tags.Methods['makom:maxpp']  = function(u)
	local maxpp = oUF.Tags.Methods['maxpp'](u)
	local perpp = oUF.Tags.Methods['perpp'](u)
	if ((u == "target" or u == "player") and (perpp~=100 and perpp~=0)) then
		return "/" .. SVal(maxpp)
	end
end
oUF.Tags.Events['makom:maxpp'] = 'UNIT_POWER UNIT_CONNECTION'

---------------------------------------------

oUF.Tags.Methods['mono:longname'] = function(u, r)
	local name = UnitName(r or u)
	return utf8sub(name,22, true)--16
end
oUF.Tags.Events['mono:longname'] = 'UNIT_NAME_UPDATE UNIT_CONNECTION'

---------------------------------------------

oUF.Tags.Methods['mono:longnametot'] = function(u, r)
local name = UnitName(r or u)
return utf8sub(name,15, true)--16
end
oUF.Tags.Events['mono:longnametot'] = 'UNIT_NAME_UPDATE UNIT_CONNECTION'

---------------------------------------------

