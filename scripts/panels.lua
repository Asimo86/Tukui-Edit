-- ACTION BAR PANEL
TukuiDB.buttonsize = TukuiDB.Scale(27)
TukuiDB.buttonspacing = TukuiDB.Scale(4)
TukuiDB.petbuttonsize = TukuiDB.Scale(29)
TukuiDB.petbuttonspacing = TukuiDB.Scale(4)

-- set left and right info panel width
TukuiCF["panels"] = {["tinfowidth"] = 370}

local barbg = CreateFrame("Frame", "TukuiActionBarBackground", UIParent)
TukuiDB.CreatePanel(barbg, 1, 1, "BOTTOM", UIParent, "BOTTOM", 0, TukuiDB.Scale(14))
if TukuiDB.lowversion == true then
	barbg:SetWidth((TukuiDB.buttonsize * 12) + (TukuiDB.buttonspacing * 13))
	if TukuiCF["actionbar"].bottomrows == 2 then
		barbg:SetHeight((TukuiDB.buttonsize * 2) + (TukuiDB.buttonspacing * 3))
	else
		barbg:SetHeight(TukuiDB.buttonsize + (TukuiDB.buttonspacing * 2))
	end
else
	barbg:SetWidth((TukuiDB.buttonsize * 22) + (TukuiDB.buttonspacing * 23))
	if TukuiCF["actionbar"].bottomrows == 2 then
		barbg:SetHeight((TukuiDB.buttonsize * 2) + (TukuiDB.buttonspacing * 3))
	else
		barbg:SetHeight(TukuiDB.buttonsize + (TukuiDB.buttonspacing * 2))
	end
end
barbg:SetFrameStrata("BACKGROUND")
barbg:SetFrameLevel(1)

-- LEFT VERTICAL LINE
local ileftlv = CreateFrame("Frame", "TukuiInfoLeftLineVertical", barbg)
TukuiDB.CreatePanel(ileftlv, 2, 130, "BOTTOMLEFT", UIParent, "BOTTOMLEFT", TukuiDB.Scale(22), TukuiDB.Scale(30))

-- RIGHT VERTICAL LINE
local irightlv = CreateFrame("Frame", "TukuiInfoRightLineVertical", barbg)
TukuiDB.CreatePanel(irightlv, 2, 130, "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", TukuiDB.Scale(-22), TukuiDB.Scale(30))

-- CUBE AT LEFT, WILL ACT AS A BUTTON
local cubeleft = CreateFrame("Frame", "TukuiCubeLeft", barbg)
TukuiDB.CreatePanel(cubeleft, 10, 10, "BOTTOM", ileftlv, "TOP", 0, 0)

-- CUBE AT RIGHT, WILL ACT AS A BUTTON
local cuberight = CreateFrame("Frame", "TukuiCubeRight", barbg)
TukuiDB.CreatePanel(cuberight, 10, 10, "BOTTOM", irightlv, "TOP", 0, 0)

-- HORIZONTAL LINE LEFT
local ltoabl = CreateFrame("Frame", "TukuiLineToABLeft", barbg)
TukuiDB.CreatePanel(ltoabl, 5, 2, "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
ltoabl:ClearAllPoints()
ltoabl:SetPoint("BOTTOMLEFT", ileftlv, "BOTTOMLEFT", 0, 0)
ltoabl:SetPoint("RIGHT", barbg, "BOTTOMLEFT", TukuiDB.Scale(-1), TukuiDB.Scale(17))

-- HORIZONTAL LINE RIGHT
local ltoabr = CreateFrame("Frame", "TukuiLineToABRight", barbg)
TukuiDB.CreatePanel(ltoabr, 5, 2, "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
ltoabr:ClearAllPoints()
ltoabr:SetPoint("LEFT", barbg, "BOTTOMRIGHT", TukuiDB.Scale(1), TukuiDB.Scale(17))
ltoabr:SetPoint("BOTTOMRIGHT", irightlv, "BOTTOMRIGHT", 0, 0)

-- INFO LEFT (FOR STATS)
local ileft = CreateFrame("Frame", "TukuiInfoLeft", barbg)
TukuiDB.CreatePanel(ileft, TukuiCF["panels"].tinfowidth, 23, "LEFT", ltoabl, "LEFT", TukuiDB.Scale(14), 0)
ileft:SetFrameLevel(2)
ileft:SetFrameStrata("BACKGROUND")

-- INFO RIGHT (FOR STATS)
local iright = CreateFrame("Frame", "TukuiInfoRight", barbg)
TukuiDB.CreatePanel(iright, TukuiCF["panels"].tinfowidth, 23, "RIGHT", ltoabr, "RIGHT", TukuiDB.Scale(-14), 0)
iright:SetFrameLevel(2)
iright:SetFrameStrata("BACKGROUND")

if TukuiMinimap then
	local minimapstatsleft = CreateFrame("Frame", "TukuiMinimapStatsLeft", TukuiMinimap)
	TukuiDB.CreatePanel(minimapstatsleft, ((TukuiMinimap:GetWidth() + 4) / 2) - 1, 19, "TOPLEFT", TukuiMinimap, "BOTTOMLEFT", 0, TukuiDB.Scale(-2))

	local minimapstatsright = CreateFrame("Frame", "TukuiMinimapStatsRight", TukuiMinimap)
	TukuiDB.CreatePanel(minimapstatsright, ((TukuiMinimap:GetWidth() + 4) / 2) -1, 19, "TOPRIGHT", TukuiMinimap, "BOTTOMRIGHT", 0, TukuiDB.Scale(-2))
end

--RIGHT BAR BACKGROUND
if TukuiCF["actionbar"].enable == true or not (IsAddOnLoaded("Dominos") or IsAddOnLoaded("Bartender4") or IsAddOnLoaded("Macaroon")) then
	local barbgr = CreateFrame("Frame", "TukuiActionBarBackgroundRight", MultiBarRight)
	TukuiDB.CreatePanel(barbgr, 1, (TukuiDB.buttonsize * 12) + (TukuiDB.buttonspacing * 13), "RIGHT", UIParent, "RIGHT", TukuiDB.Scale(-23), TukuiDB.Scale(-13.5))
	if TukuiCF["actionbar"].rightbars == 1 then
		barbgr:SetWidth(TukuiDB.buttonsize + (TukuiDB.buttonspacing * 2))
	elseif TukuiCF["actionbar"].rightbars == 2 then
		barbgr:SetWidth((TukuiDB.buttonsize * 2) + (TukuiDB.buttonspacing * 3))
	elseif TukuiCF["actionbar"].rightbars == 3 then
		barbgr:SetWidth((TukuiDB.buttonsize * 3) + (TukuiDB.buttonspacing * 4))
	else
		barbgr:Hide()
	end
	if TukuiCF["actionbar"].rightbars > 0 then
		local rbl = CreateFrame("Frame", "TukuiRightBarLine", barbgr)
		local crblu = CreateFrame("Frame", "TukuiCubeRightBarUP", barbgr)
		local crbld = CreateFrame("Frame", "TukuiCubeRightBarDown", barbgr)
		TukuiDB.CreatePanel(rbl, 2, (TukuiDB.buttonsize / 2 * 27) + (TukuiDB.buttonspacing * 6), "RIGHT", barbgr, "RIGHT", TukuiDB.Scale(1), 0)
		rbl:SetWidth(TukuiDB.Scale(2))
		TukuiDB.CreatePanel(crblu, 10, 10, "BOTTOM", rbl, "TOP", 0, 0)
		TukuiDB.CreatePanel(crbld, 10, 10, "TOP", rbl, "BOTTOM", 0, 0)
	end

	local petbg = CreateFrame("Frame", "TukuiPetActionBarBackground", PetActionButton1)
	if TukuiCF["actionbar"].rightbars > 0 then
		TukuiDB.CreatePanel(petbg, TukuiDB.petbuttonsize + (TukuiDB.petbuttonspacing * 2), (TukuiDB.petbuttonsize * 10) + (TukuiDB.petbuttonspacing * 11), "RIGHT", barbgr, "LEFT", TukuiDB.Scale(-6), 0)
	else
		TukuiDB.CreatePanel(petbg, TukuiDB.petbuttonsize + (TukuiDB.petbuttonspacing * 2), (TukuiDB.petbuttonsize * 10) + (TukuiDB.petbuttonspacing * 11), "RIGHT", UIParent, "RIGHT", TukuiDB.Scale(-6), TukuiDB.Scale(-13.5))
	end

	local ltpetbg1 = CreateFrame("Frame", "TukuiLineToPetActionBarBackground", petbg)
	TukuiDB.CreatePanel(ltpetbg1, 30, 265, "TOPLEFT", petbg, "TOPRIGHT", 0, TukuiDB.Scale(-33))
	ltpetbg1:SetFrameLevel(0)
	ltpetbg1:SetAlpha(.8)
end

--BATTLEGROUND STATS FRAME
if TukuiCF["datatext"].battleground == true then
	local bgframe = CreateFrame("Frame", "TukuiInfoLeftBattleGround", UIParent)
	TukuiDB.CreatePanel(bgframe, 1, 1, "TOPLEFT", UIParent, "BOTTOMLEFT", 0, 0)
	bgframe:SetAllPoints(ileft)
	bgframe:SetFrameStrata("LOW")
	bgframe:SetFrameLevel(3)
	bgframe:EnableMouse(true)
	local function OnEvent(self, event)
		if event == "PLAYER_ENTERING_WORLD" then
			inInstance, instanceType = IsInInstance()
			if inInstance and (instanceType == "pvp") then
				bgframe:Show()
			else
				bgframe:Hide()
			end
		end
	end
	bgframe:SetScript("OnEnter", function(self)
	local numScores = GetNumBattlefieldScores()
		for i=1, numScores do
			name, killingBlows, honorKills, deaths, honorGained, faction, rank, race, class, classToken, damageDone, healingDone  = GetBattlefieldScore(i);
			if ( name ) then
				if ( name == UnitName("player") ) then
					GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, TukuiDB.Scale(4));
					GameTooltip:ClearLines()
					GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, TukuiDB.Scale(1))
					GameTooltip:ClearLines()
					GameTooltip:AddLine(tukuilocal.datatext_ttstatsfor.."[|cffCC0033"..name.."|r]")
					GameTooltip:AddLine' '
					GameTooltip:AddDoubleLine(tukuilocal.datatext_ttkillingblows, killingBlows,1,1,1)
					GameTooltip:AddDoubleLine(tukuilocal.datatext_tthonorkills, honorKills,1,1,1)
					GameTooltip:AddDoubleLine(tukuilocal.datatext_ttdeaths, deaths,1,1,1)
					GameTooltip:AddDoubleLine(tukuilocal.datatext_tthonorgain, honorGained,1,1,1)
					GameTooltip:AddDoubleLine(tukuilocal.datatext_ttdmgdone, damageDone,1,1,1)
					GameTooltip:AddDoubleLine(tukuilocal.datatext_tthealdone, healingDone,1,1,1)
					--Add extra statistics to watch based on what BG you are in.
					if GetRealZoneText() == "Arathi Basin" then --
						GameTooltip:AddDoubleLine(tukuilocal.datatext_basesassaulted,GetBattlefieldStatData(i, 1),1,1,1)
						GameTooltip:AddDoubleLine(tukuilocal.datatext_basesdefended,GetBattlefieldStatData(i, 2),1,1,1)
					elseif GetRealZoneText() == "Warsong Gulch" then --
						GameTooltip:AddDoubleLine(tukuilocal.datatext_flagscaptured,GetBattlefieldStatData(i, 1),1,1,1)
						GameTooltip:AddDoubleLine(tukuilocal.datatext_flagsreturned,GetBattlefieldStatData(i, 2),1,1,1)
					elseif GetRealZoneText() == "Eye of the Storm" then --
						GameTooltip:AddDoubleLine(tukuilocal.datatext_flagscaptured,GetBattlefieldStatData(i, 1),1,1,1)
					elseif GetRealZoneText() == "Alterac Valley" then
						GameTooltip:AddDoubleLine(tukuilocal.datatext_graveyardsassaulted,GetBattlefieldStatData(i, 1),1,1,1)
						GameTooltip:AddDoubleLine(tukuilocal.datatext_graveyardsdefended,GetBattlefieldStatData(i, 2),1,1,1)
						GameTooltip:AddDoubleLine(tukuilocal.datatext_towersassaulted,GetBattlefieldStatData(i, 3),1,1,1)
						GameTooltip:AddDoubleLine(tukuilocal.datatext_towersdefended,GetBattlefieldStatData(i, 4),1,1,1)
					elseif GetRealZoneText() == "Strand of the Ancients" then
						GameTooltip:AddDoubleLine(tukuilocal.datatext_demolishersdestroyed,GetBattlefieldStatData(i, 1),1,1,1)
						GameTooltip:AddDoubleLine(tukuilocal.datatext_gatesdestroyed,GetBattlefieldStatData(i, 2),1,1,1)
					elseif GetRealZoneText() == "Isle of Conquest" then
						GameTooltip:AddDoubleLine(tukuilocal.datatext_basesassaulted,GetBattlefieldStatData(i, 1),1,1,1)
						GameTooltip:AddDoubleLine(tukuilocal.datatext_basesdefended,GetBattlefieldStatData(i, 2),1,1,1)
					end					
					GameTooltip:Show()
				end
			end
		end
	end) 
	bgframe:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	bgframe:RegisterEvent("PLAYER_ENTERING_WORLD")
	bgframe:SetScript("OnEvent", OnEvent)
	
	-- this part is to enable left cube as a button for battleground stat panel.
	local function CubeLeftClick(self, event)
		if event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_ENTERING_WORLD" then
			cubeleft:SetBackdropBorderColor(unpack(TukuiCF["media"].bordercolor))
			inInstance, instanceType = IsInInstance()
			if TukuiCF["datatext"].battleground == true and (inInstance and (instanceType == "pvp")) then
				cubeleft:EnableMouse(true)
			else
				cubeleft:EnableMouse(false)
			end
		end   
	end
	cubeleft:SetScript("OnMouseDown", function()
		if bgframe:IsShown() then
			bgframe:Hide()
			cubeleft:SetBackdropBorderColor(0.78,0.03,0.08)
		else
			cubeleft:SetBackdropBorderColor(unpack(TukuiCF["media"].bordercolor))
			bgframe:Show()
		end
	end)
	cubeleft:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	cubeleft:RegisterEvent("PLAYER_ENTERING_WORLD")
	cubeleft:SetScript("OnEvent", CubeLeftClick)
end

 ------------------------------------------------------------
 --SKADA DAMAGE METER
 ------------------------------------------------------------
 
--skada

	-- local dmmeter = CreateFrame("Frame", "dmpanel", SkadaBarWindowSkada)
	-- TukuiDB.CreatePanel(dmmeter, TukuiDB.Scale(189), TukuiDB.Scale(148), "TOP", SkadaBarWindowSkada, "TOP", 0, 1)
	-- dmmeter:SetFrameStrata("MEDIUM")
	-- dmmeter:SetFrameLevel(1)

-- -- Need to Know_Group 1
-- local NTK1 = CreateFrame("Frame", "NTK1", PallyPowerFrame)
-- TukuiDB.CreatePanel(NTK1, TukuiDB.Scale(125), TukuiDB.Scale(20), "LEFT", PallyPowerFrame, "CENTER", 0,0)
-- NTK1:SetFrameLevel(2)
-- NTK1:SetBackdropColor(.075,.075,.075,.7)
-- NTK1:SetBackdropBorderColor(unpack(TukuiCF["media"].bordercolor))

-- NTK1Border = CreateFrame("Frame", nil, UIParent)
-- NTK1Border:SetPoint("TOPLEFT", NTK1, "TOPLEFT", -1, 1)
-- NTK1Border:SetFrameStrata("BACKGROUND")
-- NTK1Border:SetBackdrop {
-- edgeFile = TukuiCF["media"].blank, edgeSize = 3,
-- insets = {left = 0, right = 0, top = 0, bottom = 0}
-- }
-- NTK1Border:SetBackdropColor(unpack(TukuiCF["media"].backdropcolor))
-- NTK1Border:SetBackdropBorderColor(unpack(TukuiCF["media"].backdropcolor))
-- NTK1Border:SetPoint("BOTTOMRIGHT", NTK1, "BOTTOMRIGHT", 1, -1)

-- CHAT LEFT
local chatleft = CreateFrame("Frame", "ChatLeft", TukuiInfoLeft)
TukuiDB.CreatePanel(chatleft, TukuiCF["panels"].tinfowidth, TukuiDB.Scale(125), "BOTTOM", TukuiInfoLeft, "TOP", 0, TukuiDB.Scale(3))
chatleft:SetFrameLevel(2)
chatleft:SetBackdropColor(.075,.075,.075,.7)
chatleft:SetBackdropBorderColor(unpack(TukuiCF["media"].bordercolor))
 
leftborder = CreateFrame("Frame", nil, UIParent)
leftborder:SetPoint("TOPLEFT", ChatLeft, "TOPLEFT", -1, 1)
leftborder:SetFrameStrata("BACKGROUND")
leftborder:SetBackdrop {
edgeFile = TukuiCF["media"].blank, edgeSize = 3,
insets = {left = 0, right = 0, top = 0, bottom = 0}
}
leftborder:SetBackdropColor(unpack(TukuiCF["media"].backdropcolor))
leftborder:SetBackdropBorderColor(unpack(TukuiCF["media"].backdropcolor))
leftborder:SetPoint("BOTTOMRIGHT", ChatLeft, "BOTTOMRIGHT", 1, -1)
 
-- CHAT RIGHT
local chatright = CreateFrame("Frame", "ChatRight", TukuiInfoRight)
TukuiDB.CreatePanel(chatright, TukuiCF["panels"].tinfowidth, TukuiDB.Scale(125), "BOTTOM", TukuiInfoRight, "TOP", 0, TukuiDB.Scale(3))
chatright:SetFrameLevel(2)
chatright:SetBackdropColor(.075,.075,.075,.7)
chatright:SetBackdropBorderColor(unpack(TukuiCF["media"].bordercolor))
 
rightborder = CreateFrame("Frame", nil, UIParent)
rightborder:SetPoint("TOPLEFT", ChatRight, "TOPLEFT", -1, 1)
rightborder:SetFrameStrata("BACKGROUND")
rightborder:SetBackdrop {
edgeFile = TukuiCF["media"].blank, edgeSize = 3,
insets = {left = 0, right = 0, top = 0, bottom = 0}
}
rightborder:SetBackdropColor(unpack(TukuiCF["media"].backdropcolor))
rightborder:SetBackdropBorderColor(unpack(TukuiCF["media"].backdropcolor))
rightborder:SetPoint("BOTTOMRIGHT", ChatRight, "BOTTOMRIGHT", 1, -1)


-- --------------------------------------------------------------
-- --LEFT CHAT WINDOW
-- --------------------------------------------------------------

-- --LEFT CHAT
-- local leftchat = CreateFrame("Frame", "LeftChat", barbg)
-- TukuiDB.CreatePanel(leftchat, TukuiCF["panels"].tinfowidth, TukuiDB.Scale(122), "LEFT", ileft, "LEFT", 0, 78)
-- leftchat:SetFrameLevel(2)

-- --------------------------------------------------------------
-- --RIGHT LOOT WINDOW
-- --------------------------------------------------------------

-- --RIGHT LOOT
-- local rightloot = CreateFrame("Frame", "RightLoot", barbg)
-- TukuiDB.CreatePanel(rightloot, TukuiCF["panels"].tinfowidth, TukuiDB.Scale(122), "RIGHT", iright, "RIGHT", 0, 78)
-- rightloot:SetFrameLevel(2)
