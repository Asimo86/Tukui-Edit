if not TukuiCF["unitframes"].enable == true then return end

------------------------------------------------------------------------
--	local variables
------------------------------------------------------------------------

local db = TukuiCF["unitframes"]
local font1 = TukuiCF["media"].uffont
local font2 = TukuiCF["media"].font
local normTex = TukuiCF["media"].normTex
local glowTex = TukuiCF["media"].glowTex
local bubbleTex = TukuiCF["media"].bubbleTex

local backdrop = {
	bgFile = TukuiCF["media"].blank,
	insets = {top = -TukuiDB.mult, left = -TukuiDB.mult, bottom = -TukuiDB.mult, right = -TukuiDB.mult},
}

------------------------------------------------------------------------
--	Layout
------------------------------------------------------------------------

local function Shared(self, unit)
	-- set our own colors
	self.colors = TukuiDB.oUF_colors
	
	-- register click
	self:RegisterForClicks('AnyUp')
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	
	-- menu? lol
	self.menu = TukuiDB.SpawnMenu
	self:SetAttribute('type2', 'menu')

	-- backdrop for every units
	-- self:SetBackdrop(backdrop)
	-- self:SetBackdropColor(0, 0, 0)

	-- this is the glow border
	self.FrameBackdrop = CreateFrame("Frame", nil, self)
	-- self.FrameBackdrop:SetPoint("TOPLEFT", self, "TOPLEFT", TukuiDB.Scale(-3), TukuiDB.Scale(3))
	-- self.FrameBackdrop:SetFrameStrata("BACKGROUND")
	-- self.FrameBackdrop:SetBackdrop {
	  -- edgeFile = glowTex, edgeSize = 3,
	  -- insets = {left = 0, right = 0, top = 0, bottom = 0}
	-- }
	-- self.FrameBackdrop:SetBackdropColor(0, 0, 0, 0)
	-- self.FrameBackdrop:SetBackdropBorderColor(0, 0, 0)
	-- self.FrameBackdrop:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", TukuiDB.Scale(3), TukuiDB.Scale(-3))

	------------------------------------------------------------------------
	--	Player and Target units layout (mostly mirror'd)
	------------------------------------------------------------------------
	
	if (unit == "player" or unit == "target") then
		-- create a panel
		local panel = CreateFrame("Frame", nil, self)
		if TukuiDB.lowversion then
			TukuiDB.CreatePanel(panel, 186, 21, "BOTTOM", self, "BOTTOM", 0, 0)
		else
			if (unit == "player") then
				TukuiDB.CreatePanel(panel, Minimap:GetWidth()+45, 20, "BOTTOM", Minimap, "BOTTOM", -174, -23)
			else
				--TukuiDB.CreatePanel(panel, 254, 21, "BOTTOM", self, "BOTTOM", 5, -25)
			end
		end
		panel:SetFrameLevel(2)
		panel:SetFrameStrata("MEDIUM")
		panel:SetBackdropBorderColor(unpack(TukuiCF["media"].bordercolor))
		self.panel = panel
	
		-- health bar
		local health = CreateFrame('StatusBar', nil, self)
		if TukuiDB.lowversion then
			health:SetHeight(TukuiDB.Scale(20))
		else
			health:SetHeight(TukuiDB.Scale(26))
		end
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)
		
		local healthborder = CreateFrame("Frame", healthborder, health)
		TukuiDB.CreatePanel(healthborder, 254, TukuiDB.Scale(30), "CENTER", health, "CENTER", 0, 0)
		healthborder:SetFrameStrata("MEDIUM")
		healthborder:SetFrameLevel(2)
		

				
		-- health bar background
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(.1, .1, .1)
	
		health.value = TukuiDB.SetFontString(health, font1, 16, "OUTLINE")
		health.value:SetPoint("RIGHT", health, "RIGHT", TukuiDB.Scale(-4), TukuiDB.Scale(1))
		health.PostUpdate = TukuiDB.PostUpdateHealth
				
		self.Health = health
		self.Health.bg = healthBG

		health.frequentUpdates = true
		if db.showsmooth == true then
			health.Smooth = true
		end
		
		if db.unicolor == true then
			health.colorTapping = false
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(.2, .2, .2, 1)
			healthBG:SetVertexColor(.1, .1, .1, 1)		
		else
			health.colorDisconnected = true
			health.colorTapping = true	
			health.colorClass = true
			health.colorReaction = true			
		end
		

		-- power
		local power = CreateFrame('StatusBar', nil, self)
		power:SetHeight(TukuiDB.Scale(26))
		if (unit == "target") then
		power:SetPoint("TOPLEFT", health, "BOTTOMLEFT", 5, TukuiDB.Scale(20))
		power:SetPoint("TOPRIGHT", health, "BOTTOMRIGHT", 5, TukuiDB.Scale(20))
		else
		power:SetPoint("TOPLEFT", health, "BOTTOMLEFT", -5, TukuiDB.Scale(20))
		power:SetPoint("TOPRIGHT", health, "BOTTOMRIGHT", -5, TukuiDB.Scale(20))
		end
		power:SetStatusBarTexture(normTex)
		
		power:SetFrameStrata("LOW")
		power:SetFrameLevel(1)
		
		local powerborder = CreateFrame("Frame", powerborder, power)
		TukuiDB.CreatePanel(powerborder, 254, TukuiDB.Scale(30), "CENTER", power, "CENTER", 0, 0)
		powerborder:SetFrameStrata("LOW")
		powerborder:SetFrameLevel(1)
		
		local powerBG = power:CreateTexture(nil, 'BORDER')
		powerBG:SetAllPoints(power)
		powerBG:SetTexture(normTex)
		powerBG.multiplier = 0.3
		
		power.value = TukuiDB.SetFontString(panel, font1, 12)
		--power.value:SetPoint("LEFT", panel, "LEFT", TukuiDB.Scale(4), TukuiDB.Scale(1))
		power.PreUpdate = TukuiDB.PreUpdatePower
		power.PostUpdate = TukuiDB.PostUpdatePower
				
		self.Power = power
		self.Power.bg = powerBG
		
		power.frequentUpdates = true
		power.colorDisconnected = true

		if db.showsmooth == true then
			power.Smooth = true
		end
		
		if db.unicolor == true then
			power.colorTapping = true
			power.colorClass = true
			powerBG.multiplier = 0.1				
		else
			power.colorPower = true
		end

		-- portraits
		if (db.charportrait == true) then
			local portrait = CreateFrame("PlayerModel", nil, self)
			portrait:SetFrameLevel(8)
			if TukuiDB.lowversion then
				portrait:SetHeight(51)
			else
				portrait:SetHeight(57)
			end
			portrait:SetWidth(33)
			portrait:SetAlpha(1)
			if unit == "player" then
				health:SetPoint("TOPLEFT", 34,0)
				health:SetPoint("TOPRIGHT")
				power:SetPoint("TOPLEFT", health, "BOTTOMLEFT", 0, -TukuiDB.mult)
				power:SetPoint("TOPRIGHT", health, "BOTTOMRIGHT", 0, -TukuiDB.mult)
				panel:SetPoint("TOPLEFT", power, "BOTTOMLEFT", 0, -TukuiDB.mult)
				panel:SetPoint("TOPRIGHT", power, "BOTTOMRIGHT", 0, -TukuiDB.mult)
				portrait:SetPoint("TOPLEFT", health, "TOPLEFT", -34,0)
			elseif unit == "target" then
				health:SetPoint("TOPRIGHT", -34,0)
				health:SetPoint("TOPLEFT")
				power:SetPoint("TOPRIGHT", health, "BOTTOMRIGHT", 0, -TukuiDB.mult)
				power:SetPoint("TOPLEFT", health, "BOTTOMLEFT", 0, -TukuiDB.mult)
				panel:SetPoint("TOPRIGHT", power, "BOTTOMRIGHT", 0, -TukuiDB.mult)
				panel:SetPoint("TOPLEFT", power, "BOTTOMLEFT", 0, -TukuiDB.mult)
				portrait:SetPoint("TOPRIGHT", health, "TOPRIGHT", 34,0)
			end
			table.insert(self.__elements, TukuiDB.HidePortrait)
			self.Portrait = portrait
		end

		if (unit == "player") then
			-- combat icon
			local Combat = health:CreateTexture(nil, "OVERLAY")
			Combat:SetHeight(TukuiDB.Scale(19))
			Combat:SetWidth(TukuiDB.Scale(19))
			Combat:SetPoint("LEFT",0,1)
			Combat:SetVertexColor(0.69, 0.31, 0.31)
			self.Combat = Combat

			-- custom info (low mana warning)
			FlashInfo = CreateFrame("Frame", "FlashInfo", self)
			FlashInfo:SetScript("OnUpdate", TukuiDB.UpdateManaLevel)
			FlashInfo.parent = self
			FlashInfo:SetToplevel(true)
			FlashInfo:SetAllPoints(panel)
			FlashInfo.ManaLevel = TukuiDB.SetFontString(FlashInfo, font1, 12)
			FlashInfo.ManaLevel:SetPoint("CENTER", panel, "CENTER", 0, 1)
			self.FlashInfo = FlashInfo
			
			-- pvp status text
			local status = TukuiDB.SetFontString(panel, font1, 12)
			status:SetPoint("CENTER", panel, "CENTER", 0, TukuiDB.Scale(1))
			status:SetTextColor(0.69, 0.31, 0.31, 0)
			self.Status = status
			self:Tag(status, "[pvp]")
			
			-- script for pvp status and low mana
			self:SetScript("OnEnter", function(self) FlashInfo.ManaLevel:Hide() status:SetAlpha(1) UnitFrame_OnEnter(self) end)
			self:SetScript("OnLeave", function(self) FlashInfo.ManaLevel:Show() status:SetAlpha(0) UnitFrame_OnLeave(self) end)
			
			-- leader icon
			local Leader = health:CreateTexture(nil, "OVERLAY")
			Leader:SetHeight(TukuiDB.Scale(14))
			Leader:SetWidth(TukuiDB.Scale(14))
			Leader:SetPoint("TOPLEFT", TukuiDB.Scale(2), TukuiDB.Scale(8))
			self.Leader = Leader
			
			-- master looter
			local MasterLooter = health:CreateTexture(nil, "OVERLAY")
			MasterLooter:SetHeight(TukuiDB.Scale(14))
			MasterLooter:SetWidth(TukuiDB.Scale(14))
			self.MasterLooter = MasterLooter
			self:RegisterEvent("PARTY_LEADER_CHANGED", TukuiDB.MLAnchorUpdate)
			self:RegisterEvent("PARTY_MEMBERS_CHANGED", TukuiDB.MLAnchorUpdate)
						
			-- the threat bar on info left panel ? :P
			if (db.showthreat == true) then
				if (unit == "target") then
					local ThreatBar = CreateFrame("StatusBar", self:GetName()..'_ThreatBar', panel)
					ThreatBar:SetPoint("TOPLEFT", panel, TukuiDB.Scale(2), TukuiDB.Scale(-2))
					ThreatBar:SetPoint("BOTTOMRIGHT", panel, TukuiDB.Scale(-2), TukuiDB.Scale(2))
				  
					ThreatBar:SetStatusBarTexture(normTex)
					ThreatBar:GetStatusBarTexture():SetHorizTile(false)
					ThreatBar:SetBackdrop(backdrop)
					ThreatBar:SetBackdropColor(0, 0, 0, 0)
			   
					ThreatBar.Text = TukuiDB.SetFontString(ThreatBar, font2, 12)
					ThreatBar.Text:SetPoint("RIGHT", ThreatBar, "RIGHT", TukuiDB.Scale(-30), 0 )
			
					ThreatBar.Title = TukuiDB.SetFontString(ThreatBar, font2, 12)
					ThreatBar.Title:SetText(tukuilocal.unitframes_ouf_threattext)
					ThreatBar.Title:SetPoint("LEFT", ThreatBar, "LEFT", TukuiDB.Scale(30), 0 )
						  
					ThreatBar.bg = ThreatBar:CreateTexture(nil, 'BORDER')
					ThreatBar.bg:SetAllPoints(ThreatBar)
					ThreatBar.bg:SetTexture(0.1,0.1,0.1)
			   
					ThreatBar.useRawThreat = false
					self.ThreatBar = ThreatBar
				end
			end
			
			-- experience bar on player via mouseover for player currently levelling a character
			if TukuiDB.level ~= MAX_PLAYER_LEVEL then
				local Experience = CreateFrame("StatusBar", self:GetName().."_Experience", self)
				Experience:SetStatusBarTexture(normTex)
				Experience:SetStatusBarColor(0, 0.4, 1, .8)
				Experience:SetBackdrop(backdrop)
				Experience:SetBackdropColor(unpack(TukuiCF["media"].backdropcolor))
				Experience:SetWidth(panel:GetWidth() - TukuiDB.Scale(4))
				Experience:SetHeight(panel:GetHeight() - TukuiDB.Scale(4))
				Experience:SetPoint("TOPLEFT", panel, TukuiDB.Scale(2), TukuiDB.Scale(-2))
				Experience:SetPoint("BOTTOMRIGHT", panel, TukuiDB.Scale(-2), TukuiDB.Scale(2))
				Experience:SetFrameLevel(10)
				Experience:SetAlpha(1)				
				--Experience:HookScript("OnEnter", function(self) self:SetAlpha(1) end)
				--Experience:HookScript("OnLeave", function(self) self:SetAlpha(0) end)
				Experience.Tooltip = true						
				Experience.Rested = CreateFrame('StatusBar', nil, self)
				Experience.Rested:SetParent(Experience)
				Experience.Rested:SetAllPoints(Experience)
				-- Resting = Experience:CreateTexture(nil, "OVERLAY")
				-- Resting:SetHeight(28)
				-- Resting:SetWidth(28)
				-- if TukuiDB.myclass == "SHAMAN" or TukuiDB.myclass == "DEATHKNIGHT" then
					-- Resting:SetPoint("LEFT", -18, 76)
				-- else
					-- Resting:SetPoint("LEFT", -18, 68)
				-- end
				-- Resting:SetTexture([=[Interface\CharacterFrame\UI-StateIcon]=])
				-- Resting:SetTexCoord(0, 0.5, 0, 0.421875)
				self.Experience = Experience
			end
			
			-- reputation bar for max level character
			if TukuiDB.level == MAX_PLAYER_LEVEL then
				local Reputation = CreateFrame("StatusBar", self:GetName().."_Reputation", self)
				Reputation:SetStatusBarTexture(normTex)
				Reputation:SetBackdrop(backdrop)
				Reputation:SetBackdropColor(unpack(TukuiCF["media"].backdropcolor))
				Reputation:SetWidth(panel:GetWidth() - TukuiDB.Scale(4))
				Reputation:SetHeight(panel:GetHeight() - TukuiDB.Scale(4))
				Reputation:SetPoint("TOPLEFT", panel, TukuiDB.Scale(2), TukuiDB.Scale(-2))
				Reputation:SetPoint("BOTTOMRIGHT", panel, TukuiDB.Scale(-2), TukuiDB.Scale(2))
				Reputation:SetFrameLevel(10)
				Reputation:SetAlpha(1)

				-- Reputation:HookScript("OnEnter", function(self) self:SetAlpha(1) end)
				-- Reputation:HookScript("OnLeave", function(self) self:SetAlpha(0) end)

				Reputation.PostUpdate = TukuiDB.UpdateReputationColor
				Reputation.Tooltip = true
				self.Reputation = Reputation
			end
			
			-- show druid mana when shapeshifted in bear, cat or whatever
			if TukuiDB.myclass == "DRUID" then
				CreateFrame("Frame"):SetScript("OnUpdate", function() TukuiDB.UpdateDruidMana(self) end)
				local DruidMana = TukuiDB.SetFontString(health, font1, 12)
				DruidMana:SetTextColor(1, 0.49, 0.04)
				self.DruidMana = DruidMana
			end

			-- deathknight runes
			if TukuiDB.myclass == "DEATHKNIGHT" and db.runebar == true then
				local Runes = CreateFrame("Frame", nil, self)
				Runes:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, TukuiDB.Scale(1))
				Runes:SetHeight(TukuiDB.Scale(8))
				if TukuiDB.lowversion then
					Runes:SetWidth(TukuiDB.Scale(186))
				else
					Runes:SetWidth(TukuiDB.Scale(250))
				end
				Runes:SetBackdrop(backdrop)
				Runes:SetBackdropColor(0, 0, 0)

				for i = 1, 6 do
					Runes[i] = CreateFrame("StatusBar", self:GetName().."_Runes"..i, self)
					Runes[i]:SetHeight(TukuiDB.Scale(8))
					if TukuiDB.lowversion then
						Runes[i]:SetWidth(TukuiDB.Scale(181) / 6)
					else
						Runes[i]:SetWidth(TukuiDB.Scale(245) / 6)
					end
					if (i == 1) then
						Runes[i]:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, TukuiDB.Scale(1))
					else
						Runes[i]:SetPoint("TOPLEFT", Runes[i-1], "TOPRIGHT", TukuiDB.Scale(1), 0)
					end
					Runes[i]:SetStatusBarTexture(normTex)
					Runes[i]:GetStatusBarTexture():SetHorizTile(false)
				end

				Runes.FrameBackdrop = CreateFrame("Frame", nil, Runes)
				Runes.FrameBackdrop:SetPoint("TOPLEFT", Runes, "TOPLEFT", TukuiDB.Scale(-2), TukuiDB.Scale(2))
				Runes.FrameBackdrop:SetPoint("BOTTOMRIGHT", Runes, "BOTTOMRIGHT", TukuiDB.Scale(2), TukuiDB.Scale(-2))
				Runes.FrameBackdrop:SetFrameStrata("BACKGROUND")
				Runes.FrameBackdrop:SetBackdrop {edgeFile = glowTex, edgeSize = 4, insets = {left = 3, right = 3, top = 3, bottom = 3}}
				Runes.FrameBackdrop:SetBackdropColor(0, 0, 0, 0)
				Runes.FrameBackdrop:SetBackdropBorderColor(0, 0, 0, .7)
				self.Runes = Runes
			end
			
			-- shaman totem bar
			if TukuiDB.myclass == "SHAMAN" and db.totemtimer == true then
				local TotemBar = {}
				TotemBar.Destroy = true
				for i = 1, 4 do
					TotemBar[i] = CreateFrame("StatusBar", self:GetName().."_TotemBar"..i, self)
					if (i == 1) then
					   TotemBar[i]:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, TukuiDB.Scale(1))
					else
					   TotemBar[i]:SetPoint("TOPLEFT", TotemBar[i-1], "TOPRIGHT", TukuiDB.Scale(1), 0)
					end
					TotemBar[i]:SetStatusBarTexture(normTex)
					TotemBar[i]:SetHeight(TukuiDB.Scale(8))
					if TukuiDB.lowversion then
						TotemBar[i]:SetWidth(TukuiDB.Scale(183) / 4)
					else
						TotemBar[i]:SetWidth(TukuiDB.Scale(247) / 4)
					end
					TotemBar[i]:SetBackdrop(backdrop)
					TotemBar[i]:SetBackdropColor(0, 0, 0)
					TotemBar[i]:SetMinMaxValues(0, 1)

					TotemBar[i].bg = TotemBar[i]:CreateTexture(nil, "BORDER")
					TotemBar[i].bg:SetAllPoints(TotemBar[i])
					TotemBar[i].bg:SetTexture(normTex)
					TotemBar[i].bg.multiplier = 0.3
									
					TotemBar[i].FrameBackdrop = CreateFrame("Frame", nil, TotemBar[i])
					TotemBar[i].FrameBackdrop:SetPoint("TOPLEFT", TotemBar[i], "TOPLEFT", TukuiDB.Scale(-3), TukuiDB.Scale(3))
					TotemBar[i].FrameBackdrop:SetPoint("BOTTOMRIGHT", TotemBar[i], "BOTTOMRIGHT", TukuiDB.Scale(3), TukuiDB.Scale(-3))
					TotemBar[i].FrameBackdrop:SetFrameStrata("BACKGROUND")
					TotemBar[i].FrameBackdrop:SetBackdrop {
						edgeFile = glowTex, edgeSize = 4,
						insets = {left = 3, right = 3, top = 3, bottom = 3}
					}
					TotemBar[i].FrameBackdrop:SetBackdropColor(0, 0, 0, 0)
					TotemBar[i].FrameBackdrop:SetBackdropBorderColor(0, 0, 0, .7)
				end
				self.TotemBar = TotemBar
			end
		end
		
		if (unit == "target") then			
			-- Unit name on target
			

			local Name = health:CreateFontString(nil, "OVERLAY")
			Name:ClearAllPoints()
			Name:SetPoint("CENTER", health, "CENTER", 0, TukuiDB.Scale(1))
			Name:SetFont(font1, 12, "OUTLINE")
			

			self:Tag(Name, '[Tukui:getnamecolor][Tukui:nameshort] [Tukui:diffcolor][level] [shortclassification]')
			self.Name = Name
			
			-- combo points on target
			local CPoints = {}
			CPoints.unit = PlayerFrame.unit
			for i = 1, 5 do
				CPoints[i] = health:CreateTexture(nil, "OVERLAY")
				CPoints[i]:SetHeight(TukuiDB.Scale(12))
				CPoints[i]:SetWidth(TukuiDB.Scale(12))
				CPoints[i]:SetTexture(bubbleTex)
				if i == 1 then
					if TukuiDB.lowversion then
						CPoints[i]:SetPoint("TOPRIGHT", TukuiDB.Scale(15), TukuiDB.Scale(1.5))
					else
						CPoints[i]:SetPoint("TOPLEFT", TukuiDB.Scale(-15), TukuiDB.Scale(1.5))
					end
					CPoints[i]:SetVertexColor(0.69, 0.31, 0.31)
				else
					CPoints[i]:SetPoint("TOP", CPoints[i-1], "BOTTOM", TukuiDB.Scale(1))
				end
			end
			CPoints[2]:SetVertexColor(0.69, 0.31, 0.31)
			CPoints[3]:SetVertexColor(0.65, 0.63, 0.35)
			CPoints[4]:SetVertexColor(0.65, 0.63, 0.35)
			CPoints[5]:SetVertexColor(0.33, 0.59, 0.33)
			self.CPoints = CPoints
			self:RegisterEvent("UNIT_COMBO_POINTS", TukuiDB.UpdateCPoints)
		end

		if (unit == "target" and db.targetauras) or (unit == "player" and db.playerauras) then
			local buffs = CreateFrame("Frame", nil, self)
			local debuffs = CreateFrame("Frame", nil, self)
			
			if TukuiDB.myclass == "SHAMAN" or TukuiDB.myclass == "DEATHKNIGHT" and db.playerauras then
				if TukuiDB.lowversion then
					buffs:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 34)
				else
					buffs:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 38)
				end
			else
				if TukuiDB.lowversion then
					buffs:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 26)
				else
					buffs:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 30)
				end
			end
			
			if TukuiDB.lowversion then
				buffs:SetHeight(21.5)
				buffs:SetWidth(186)
				buffs.size = 21.5
				buffs.num = 8
				
				debuffs:SetHeight(21.5)
				debuffs:SetWidth(186)
				debuffs:SetPoint("BOTTOMLEFT", buffs, "TOPLEFT", 0, 2)
				debuffs.size = 21.5	
				debuffs.num = 24
			else				
				buffs:SetHeight(26)
				buffs:SetWidth(252)
				buffs.size = 26
				buffs.num = 9
				
				debuffs:SetHeight(26)
				debuffs:SetWidth(252)
				debuffs:SetPoint("BOTTOMLEFT", buffs, "TOPLEFT", -2, 2)
				debuffs.size = 26
				debuffs.num = 27
			end
						
			buffs.spacing = 2
			buffs.initialAnchor = 'TOPLEFT'
			buffs.PostCreateIcon = TukuiDB.PostCreateAura
			buffs.PostUpdateIcon = TukuiDB.PostUpdateAura
			self.Buffs = buffs	
						
			debuffs.spacing = 2
			debuffs.initialAnchor = 'TOPRIGHT'
			debuffs["growth-y"] = "UP"
			debuffs["growth-x"] = "LEFT"
			debuffs.onlyShowPlayer = db.playerdebuffsonly
			debuffs.PostCreateIcon = TukuiDB.PostCreateAura
			debuffs.PostUpdateIcon = TukuiDB.PostUpdateAura
			self.Debuffs = debuffs
		end
		
		-- cast bar for player and target
		if (db.unitcastbar == true) then
			-- castbar of player and target
			

			 
			local castbar = CreateFrame("StatusBar", self:GetName().."_Castbar", self)
			castbar:SetStatusBarTexture(normTex)			
			castbar.bg = castbar:CreateTexture(nil, "BORDER")
			castbar.bg:SetAllPoints(castbar)
			castbar.bg:SetTexture(normTex)
			castbar.bg:SetVertexColor(0.15, 0.15, 0.15)
			castbar:SetFrameLevel(1)
			castbar:SetPoint("TOPLEFT", power, 0, 0)
			castbar:SetPoint("BOTTOMRIGHT", power, 0, 0)
			

			
			castbar.CustomTimeText = TukuiDB.CustomCastTimeText
			castbar.CustomDelayText = TukuiDB.CustomCastDelayText
			castbar.PostCastStart = TukuiDB.PostCastStart
			castbar.PostChannelStart = TukuiDB.PostCastStart
			castbar:RegisterEvent('UNIT_SPELLCAST_INTERRUPTABLE', TukuiDB.SpellCastInterruptable)
			castbar:RegisterEvent('UNIT_SPELLCAST_NOT_INTERRUPTABLE', TukuiDB.SpellCastInterruptable)

			castbar.time = TukuiDB.SetFontString(castbar, font1, 12)
			castbar.time:SetPoint("RIGHT", power, "RIGHT", TukuiDB.Scale(-4), TukuiDB.Scale(-25))
			castbar.time:SetTextColor(0.84, 0.75, 0.65)
			castbar.time:SetJustifyH("RIGHT")

			castbar.Text = TukuiDB.SetFontString(castbar, font1, 12)
			castbar.Text:SetPoint("LEFT", power, "LEFT", 4, -25)
			castbar.Text:SetTextColor(0.84, 0.75, 0.65)
			
			if db.cbicons == true then
				castbar.button = CreateFrame("Frame", nil, castbar)
				castbar.button:SetHeight(TukuiDB.Scale(26))
				castbar.button:SetWidth(TukuiDB.Scale(26))
				TukuiDB.SetTemplate(castbar.button)

				castbar.icon = castbar.button:CreateTexture(nil, "ARTWORK")
				castbar.icon:SetPoint("TOPLEFT", castbar.button, TukuiDB.Scale(2), TukuiDB.Scale(-2))
				castbar.icon:SetPoint("BOTTOMRIGHT", castbar.button, TukuiDB.Scale(-2), TukuiDB.Scale(2))
				castbar.icon:SetTexCoord(0.08, 0.92, 0.08, .92)
			
				if unit == "player" then
					if db.charportrait == true then
						castbar.button:SetPoint("LEFT", -82.5, 26.5)
					else
						castbar.button:SetPoint("LEFT", -46.5, 26.5)
					end
				elseif unit == "target" then
					if db.charportrait == true then
						castbar.button:SetPoint("RIGHT", 82.5, 26.5)
					else
						castbar.button:SetPoint("RIGHT", 46.5, 26.5)
					end					
				end	
			end
			
			-- cast bar latency on player
			if unit == "player" and db.cblatency == true then
				castbar.safezone = castbar:CreateTexture(nil, "ARTWORK")
				castbar.safezone:SetTexture(normTex)
				castbar.safezone:SetVertexColor(0.69, 0.31, 0.31, 0.75)
				castbar.SafeZone = castbar.safezone
			end
			
			castbar.IconBackdrop = CreateFrame("Frame", nil, self)
			castbar.IconBackdrop:SetPoint("TOPLEFT", castbar.button, "TOPLEFT", TukuiDB.Scale(-4), TukuiDB.Scale(4))
			castbar.IconBackdrop:SetPoint("BOTTOMRIGHT", castbar.button, "BOTTOMRIGHT", TukuiDB.Scale(4), TukuiDB.Scale(-4))
			castbar.IconBackdrop:SetParent(castbar)
			castbar.IconBackdrop:SetBackdrop({
				edgeFile = glowTex, edgeSize = 4,
				insets = {left = 3, right = 3, top = 3, bottom = 3}
			})
			castbar.IconBackdrop:SetBackdropColor(0, 0, 0, 0)
			castbar.IconBackdrop:SetBackdropBorderColor(0, 0, 0, 0.7)
					
			self.Castbar = castbar
			self.Castbar.Time = castbar.time
			self.Castbar.Icon = castbar.icon
		end
		
		-- add combat feedback support
		if db.combatfeedback == true then
			local CombatFeedbackText 
			if TukuiDB.lowversion then
				CombatFeedbackText = TukuiDB.SetFontString(health, font1, 12, "OUTLINE")
			else
				CombatFeedbackText = TukuiDB.SetFontString(health, font1, 14, "OUTLINE")
			end
			CombatFeedbackText:SetPoint("CENTER", 0, 1)
			CombatFeedbackText.colors = {
				DAMAGE = {0.69, 0.31, 0.31},
				CRUSHING = {0.69, 0.31, 0.31},
				CRITICAL = {0.69, 0.31, 0.31},
				GLANCING = {0.69, 0.31, 0.31},
				STANDARD = {0.84, 0.75, 0.65},
				IMMUNE = {0.84, 0.75, 0.65},
				ABSORB = {0.84, 0.75, 0.65},
				BLOCK = {0.84, 0.75, 0.65},
				RESIST = {0.84, 0.75, 0.65},
				MISS = {0.84, 0.75, 0.65},
				HEAL = {0.33, 0.59, 0.33},
				CRITHEAL = {0.33, 0.59, 0.33},
				ENERGIZE = {0.31, 0.45, 0.63},
				CRITENERGIZE = {0.31, 0.45, 0.63},
			}
			self.CombatFeedbackText = CombatFeedbackText
		end
		
		-- player aggro
		if db.playeraggro == true then
			table.insert(self.__elements, TukuiDB.UpdateThreat)
			self:RegisterEvent('PLAYER_TARGET_CHANGED', TukuiDB.UpdateThreat)
			self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', TukuiDB.UpdateThreat)
			self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', TukuiDB.UpdateThreat)
		end
		
		-- fixing vehicle/player frame when exiting an instance while on a vehicle
		self:RegisterEvent("UNIT_PET", TukuiDB.updateAllElements)
					
		-- set width and height of player and target
		if TukuiDB.lowversion == true then
			self:SetAttribute('initial-width', TukuiDB.Scale(186))
			self:SetAttribute('initial-height', TukuiDB.Scale(51))			
		else
			self:SetAttribute('initial-width', TukuiDB.Scale(250))
			self:SetAttribute('initial-height', TukuiDB.Scale(33))
		end
	end
	
	------------------------------------------------------------------------
	--	Target of Target unit layout
	------------------------------------------------------------------------
	
	if (unit == "targettarget") then
		
		
		-- health bar
		local health = CreateFrame('StatusBar', nil, self)
		health:SetHeight(TukuiDB.Scale(16))
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)

			
		
		-- create panel if higher version
		local panel = CreateFrame("Frame", nil, health)
		if not TukuiDB.lowversion then
			TukuiDB.CreatePanel(panel, 114, health:GetHeight()+4, "CENTER", health, "CENTER", TukuiDB.Scale(0), TukuiDB.Scale(0))
			panel:SetFrameLevel(2)
			panel:SetFrameStrata("MEDIUM")
			panel:SetBackdropBorderColor(unpack(TukuiCF["media"].altbordercolor))
			self.panel = panel
		end
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(.1, .1, .1)
		
		self.Health = health
		self.Health.bg = healthBG
		
		health.frequentUpdates = true
		if db.showsmooth == true then
			health.Smooth = true
		end
		
		if db.unicolor == true then
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(.2, .2, .2, 2)
			healthBG:SetVertexColor(.1, .1, .1, 1)		
		else
			health.colorDisconnected = true
			health.colorClass = true
			health.colorReaction = true			
		end
		
		-- Unit name
		local Name = health:CreateFontString(nil, "OVERLAY")
		if TukuiDB.lowversion then
			Name:SetPoint("CENTER", health, "CENTER", 0, TukuiDB.Scale(1))
			Name:SetFont(font1, 12, "OUTLINE")
		else
			Name:SetPoint("CENTER", health, "CENTER", 0, TukuiDB.Scale(1))
			Name:SetFont(font1, 12, "OUTLINE")
		end
		Name:SetJustifyH("CENTER")

		self:Tag(Name, '[Tukui:getnamecolor][Tukui:namemedium]')
		self.Name = Name
		
		if db.totdebuffs == true and TukuiDB.lowversion ~= true then
			local debuffs = CreateFrame("Frame", nil, health)
			debuffs:SetHeight(20)
			debuffs:SetWidth(127)
			debuffs.size = 20
			debuffs.spacing = 2
			debuffs.num = 6

			debuffs:SetPoint("TOPLEFT", health, "TOPLEFT", -0.5, 24)
			debuffs.initialAnchor = "TOPLEFT"
			debuffs["growth-y"] = "UP"
			debuffs.PostCreateIcon = TukuiDB.PostCreateAura
			debuffs.PostUpdateIcon = TukuiDB.PostUpdateAura
			self.Debuffs = debuffs
		end
		
		-- width and height of target of target
		if TukuiDB.lowversion then
			self:SetAttribute("initial-height", TukuiDB.Scale(18))
			self:SetAttribute("initial-width", TukuiDB.Scale(186))
		else
			self:SetAttribute("initial-height", TukuiDB.Scale(36))
			self:SetAttribute("initial-width", TukuiDB.Scale(110))
		end
	end
	
	------------------------------------------------------------------------
	--	Pet unit layout
	------------------------------------------------------------------------
	
	if (unit == "pet") then
		-- create panel if higher version
		local panel = CreateFrame("Frame", nil, self)
		if not TukuiDB.lowversion then
			TukuiDB.CreatePanel(panel, 129, 17, "BOTTOM", self, "BOTTOM", 0, TukuiDB.Scale(0))
			panel:SetFrameLevel(2)
			panel:SetFrameStrata("MEDIUM")
			panel:SetBackdropBorderColor(unpack(TukuiCF["media"].altbordercolor))
			self.panel = panel
		end
		
		-- health bar
		local health = CreateFrame('StatusBar', nil, self)
		health:SetHeight(TukuiDB.Scale(18))
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)
				
		self.Health = health
		self.Health.bg = healthBG
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(.1, .1, .1)
		
		health.frequentUpdates = true
		if db.showsmooth == true then
			health.Smooth = true
		end
		
		if db.unicolor == true then
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(.3, .3, .3, 1)
			healthBG:SetVertexColor(.1, .1, .1, 1)		
		else
			health.colorDisconnected = true	
			health.colorClass = true
			health.colorReaction = true	
			if TukuiDB.myclass == "HUNTER" then
				health.colorHappiness = true
			end
		end
				
		-- Unit name
		local Name = health:CreateFontString(nil, "OVERLAY")
		if TukuiDB.lowversion then
			Name:SetPoint("CENTER", health, "CENTER", 0, TukuiDB.Scale(1))
			Name:SetFont(font1, 12, "OUTLINE")
		else
			Name:SetPoint("CENTER", panel, "CENTER", 0, TukuiDB.Scale(1))
			Name:SetFont(font1, 12)
		end
		Name:SetJustifyH("CENTER")

		self:Tag(Name, '[Tukui:getnamecolor][Tukui:namemedium] [Tukui:diffcolor][level]')
		self.Name = Name
		
		if (db.unitcastbar == true) then
			-- castbar of player and target
			local castbar = CreateFrame("StatusBar", self:GetName().."_Castbar", self)
			castbar:SetStatusBarTexture(normTex)
			
			if not TukuiDB.lowversion then
				castbar.bg = castbar:CreateTexture(nil, "BORDER")
				castbar.bg:SetAllPoints(castbar)
				castbar.bg:SetTexture(normTex)
				castbar.bg:SetVertexColor(0.15, 0.15, 0.15)
				castbar:SetFrameLevel(6)
				castbar:SetPoint("TOPLEFT", panel, TukuiDB.Scale(2), TukuiDB.Scale(-2))
				castbar:SetPoint("BOTTOMRIGHT", panel, TukuiDB.Scale(-2), TukuiDB.Scale(2))
				
				castbar.CustomTimeText = TukuiDB.CustomCastTimeText
				castbar.CustomDelayText = TukuiDB.CustomCastDelayText
				castbar.PostCastStart = TukuiDB.PostCastStart
				castbar.PostChannelStart = TukuiDB.PostCastStart
				castbar:RegisterEvent('UNIT_SPELLCAST_INTERRUPTABLE', TukuiDB.SpellCastInterruptable)
				castbar:RegisterEvent('UNIT_SPELLCAST_NOT_INTERRUPTABLE', TukuiDB.SpellCastInterruptable)

				castbar.time = TukuiDB.SetFontString(castbar, font1, 12)
				castbar.time:SetPoint("RIGHT", panel, "RIGHT", TukuiDB.Scale(-4), TukuiDB.Scale(1))
				castbar.time:SetTextColor(0.84, 0.75, 0.65)
				castbar.time:SetJustifyH("RIGHT")

				castbar.Text = TukuiDB.SetFontString(castbar, font1, 12)
				castbar.Text:SetPoint("LEFT", panel, "LEFT", 4, 1)
				castbar.Text:SetTextColor(0.84, 0.75, 0.65)
				
				self.Castbar = castbar
				self.Castbar.Time = castbar.time
			end
		end
		
		-- update pet name, this should fix "UNKNOWN" pet names on pet unit.
		self:RegisterEvent("UNIT_PET", TukuiDB.UpdatePetInfo)
		
		-- width and height of pet
		if TukuiDB.lowversion then
			self:SetAttribute("initial-height", TukuiDB.Scale(18))
			self:SetAttribute("initial-width", TukuiDB.Scale(186))
		else
			self:SetAttribute("initial-height", TukuiDB.Scale(36))
			self:SetAttribute("initial-width", TukuiDB.Scale(129))
		end
	end


	------------------------------------------------------------------------
	--	Focus unit layout
	------------------------------------------------------------------------
	
	if (unit == "focus") then
		-- no glow border on focus please
		self.FrameBackdrop:SetAlpha(0)
		
		-- create health bar
		local health = CreateFrame('StatusBar', nil, self)
		health:SetPoint("TOPLEFT")
		health:SetPoint("BOTTOMRIGHT")
		health:SetStatusBarTexture(normTex)
		health:GetStatusBarTexture():SetHorizTile(false)
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(.1, .1, .1)
		
		health.value = TukuiDB.SetFontString(health, font1, 12, "OUTLINE")
		health.value:SetPoint("RIGHT", health, "RIGHT", TukuiDB.Scale(-4), TukuiDB.Scale(1))
		health.PostUpdate = TukuiDB.PostUpdateHealth
		
		self.Health = health
		self.Health.bg = healthBG
		
		health.frequentUpdates = true
		if db.showsmooth == true then
			health.Smooth = true
		end
		
		if db.unicolor == true then
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(.3, .3, .3, 1)
			healthBG:SetVertexColor(.1, .1, .1, 1)		
		else
			health.colorDisconnected = true
			health.colorClass = true
			health.colorReaction = true	
		end
		
		-- Unit name
		local Name = health:CreateFontString(nil, "OVERLAY")
		Name:SetPoint("LEFT", health, "LEFT", TukuiDB.Scale(4), TukuiDB.Scale(1))
		Name:SetJustifyH("LEFT")
		Name:SetFont(font1, 12, "OUTLINE")
		Name:SetShadowColor(0, 0, 0)
		Name:SetShadowOffset(1.25, -1.25)

		self:Tag(Name, '[Tukui:getnamecolor][Tukui:namelong] [Tukui:diffcolor][level] [shortclassification]')
		self.Name = Name
		
		self:SetAttribute("initial-height", TukuiInfoRight:GetHeight() - TukuiDB.Scale(4))
		self:SetAttribute("initial-width", TukuiInfoRight:GetWidth() - TukuiDB.Scale(4))

		-- create focus debuff feature
		if db.focusdebuffs == true then
			local debuffs = CreateFrame("Frame", nil, self)
			debuffs:SetHeight(26)
			debuffs:SetWidth(TukuiCF["panels"].tinfowidth - 10)
			debuffs.size = 26
			debuffs.spacing = 2
			debuffs.num = 40
						
			debuffs:SetPoint("TOPRIGHT", self, "TOPRIGHT", 2, 38)
			debuffs.initialAnchor = "TOPRIGHT"
			debuffs["growth-y"] = "UP"
			debuffs["growth-x"] = "LEFT"
			
			debuffs.PostCreateIcon = TukuiDB.PostCreateAura
			debuffs.PostUpdateIcon = TukuiDB.PostUpdateAura
			self.Debuffs = debuffs
		end
		
		-- focus cast bar in the center of the screen
		if db.unitcastbar == true then
			local castbar = CreateFrame("StatusBar", self:GetName().."_Castbar", self)
			castbar:SetHeight(TukuiDB.Scale(20))
			castbar:SetWidth(TukuiDB.Scale(240))
			castbar:SetStatusBarTexture(normTex)
			castbar:SetFrameLevel(6)
			castbar:SetPoint("CENTER", UIParent, "CENTER", 0, 250)		
			
			castbar.bg = CreateFrame("Frame", nil, castbar)
			TukuiDB.SetTemplate(castbar.bg)
			castbar.bg:SetPoint("TOPLEFT", TukuiDB.Scale(-2), TukuiDB.Scale(2))
			castbar.bg:SetPoint("BOTTOMRIGHT", TukuiDB.Scale(2), TukuiDB.Scale(-2))
			castbar.bg:SetFrameLevel(5)
			
			castbar.time = TukuiDB.SetFontString(castbar, font1, 12)
			castbar.time:SetPoint("RIGHT", castbar, "RIGHT", TukuiDB.Scale(-4), TukuiDB.Scale(1))
			castbar.time:SetTextColor(0.84, 0.75, 0.65)
			castbar.time:SetJustifyH("RIGHT")
			castbar.CustomTimeText = CustomCastTimeText

			castbar.Text = TukuiDB.SetFontString(castbar, font1, 12)
			castbar.Text:SetPoint("LEFT", castbar, "LEFT", 4, 1)
			castbar.Text:SetTextColor(0.84, 0.75, 0.65)
			
			castbar.CustomDelayText = TukuiDB.CustomCastDelayText
			castbar.PostCastStart = TukuiDB.PostCastStart
			castbar.PostChannelStart = TukuiDB.PostChannelStart
			castbar:RegisterEvent('UNIT_SPELLCAST_INTERRUPTABLE', TukuiDB.SpellCastInterruptable)
			castbar:RegisterEvent('UNIT_SPELLCAST_NOT_INTERRUPTABLE', TukuiDB.SpellCastInterruptable)
			
			castbar.CastbarBackdrop = CreateFrame("Frame", nil, castbar)
			castbar.CastbarBackdrop:SetPoint("TOPLEFT", castbar, "TOPLEFT", TukuiDB.Scale(-6), TukuiDB.Scale(6))
			castbar.CastbarBackdrop:SetPoint("BOTTOMRIGHT", castbar, "BOTTOMRIGHT", TukuiDB.Scale(6), TukuiDB.Scale(-6))
			castbar.CastbarBackdrop:SetParent(castbar)
			castbar.CastbarBackdrop:SetFrameStrata("BACKGROUND")
			castbar.CastbarBackdrop:SetFrameLevel(4)
			castbar.CastbarBackdrop:SetBackdrop({
				edgeFile = glowTex, edgeSize = 4,
				insets = {left = 3, right = 3, top = 3, bottom = 3}
			})
			castbar.CastbarBackdrop:SetBackdropColor(0, 0, 0, 0)
			castbar.CastbarBackdrop:SetBackdropBorderColor(0, 0, 0, 0.7)
			
			if db.cbicons == true then
				castbar.button = CreateFrame("Frame", nil, castbar)
				castbar.button:SetHeight(TukuiDB.Scale(40))
				castbar.button:SetWidth(TukuiDB.Scale(40))
				castbar.button:SetPoint("CENTER", 0, TukuiDB.Scale(50))
				TukuiDB.SetTemplate(castbar.button)

				castbar.icon = castbar.button:CreateTexture(nil, "ARTWORK")
				castbar.icon:SetPoint("TOPLEFT", castbar.button, TukuiDB.Scale(2), TukuiDB.Scale(-2))
				castbar.icon:SetPoint("BOTTOMRIGHT", castbar.button, TukuiDB.Scale(-2), TukuiDB.Scale(2))
				castbar.icon:SetTexCoord(0.08, 0.92, 0.08, .92)
				
				castbar.IconBackdrop = CreateFrame("Frame", nil, self)
				castbar.IconBackdrop:SetPoint("TOPLEFT", castbar.button, "TOPLEFT", TukuiDB.Scale(-4), TukuiDB.Scale(4))
				castbar.IconBackdrop:SetPoint("BOTTOMRIGHT", castbar.button, "BOTTOMRIGHT", TukuiDB.Scale(4), TukuiDB.Scale(-4))
				castbar.IconBackdrop:SetParent(castbar)
				castbar.IconBackdrop:SetBackdrop({
					edgeFile = glowTex, edgeSize = 4,
					insets = {left = 3, right = 3, top = 3, bottom = 3}
				})
				castbar.IconBackdrop:SetBackdropColor(0, 0, 0, 0)
				castbar.IconBackdrop:SetBackdropBorderColor(0, 0, 0, 0.7)
			end

			self.Castbar = castbar
			self.Castbar.Time = castbar.time
			self.Castbar.Icon = castbar.icon
		end
	end
	
	------------------------------------------------------------------------
	--	Focus target unit layout
	------------------------------------------------------------------------

	-- not done lol?
	if (unit == "focustarget") then
		-- create panel if higher version
		local panel = CreateFrame("Frame", nil, self)
		TukuiDB.CreatePanel(panel, 129, 17, "BOTTOM", self, "BOTTOM", 0, TukuiDB.Scale(0))
		panel:SetFrameLevel(2)
		panel:SetFrameStrata("MEDIUM")
		panel:SetBackdropBorderColor(unpack(TukuiCF["media"].altbordercolor))
		self.panel = panel
		
		-- health bar
		local health = CreateFrame('StatusBar', nil, self)
		health:SetHeight(TukuiDB.Scale(18))
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(.1, .1, .1)
		
		self.Health = health
		self.Health.bg = healthBG
		
		health.frequentUpdates = true
		if db.showsmooth == true then
			health.Smooth = true
		end
		
		if db.unicolor == true then
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(.3, .3, .3, 1)
			healthBG:SetVertexColor(.1, .1, .1, 1)		
		else
			health.colorDisconnected = true
			health.colorClass = true
			health.colorReaction = true			
		end
		
		-- Unit name
		local Name = health:CreateFontString(nil, "OVERLAY")
		Name:SetPoint("CENTER", panel, "CENTER", 0, TukuiDB.Scale(1))
		Name:SetFont(font1, 12)
		Name:SetJustifyH("CENTER")

		self:Tag(Name, '[Tukui:getnamecolor][Tukui:namemedium] [Tukui:diffcolor][level]')
		self.Name = Name
		
		-- width and height of target of target
		self:SetAttribute("initial-height", TukuiDB.Scale(36))
		self:SetAttribute("initial-width", TukuiDB.Scale(129))
	end

	------------------------------------------------------------------------
	--	Arena or boss units layout (both mirror'd)
	------------------------------------------------------------------------
	
	if (unit and unit:find("arena%d") and TukuiCF["arena"].unitframes == true) or (unit and unit:find("boss%d") and db.showboss == true) then
		-- Right-click focus on arena or boss units
		self:SetAttribute("type2", "focus")
		
		-- health 
		local health = CreateFrame('StatusBar', nil, self)
		health:SetHeight(TukuiDB.Scale(22))
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)

		health.frequentUpdates = true
		health.colorDisconnected = true
		if db.showsmooth == true then
			health.Smooth = true
		end
		health.colorClass = true
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(.1, .1, .1)

		health.value = TukuiDB.SetFontString(health, font1,12, "OUTLINE")
		health.value:SetPoint("LEFT", TukuiDB.Scale(2), TukuiDB.Scale(1))
		health.PostUpdate = TukuiDB.PostUpdateHealth
				
		self.Health = health
		self.Health.bg = healthBG
		
		health.frequentUpdates = true
		if db.showsmooth == true then
			health.Smooth = true
		end
		
		if db.unicolor == true then
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(.3, .3, .3, 1)
			healthBG:SetVertexColor(.1, .1, .1, 1)		
		else
			health.colorDisconnected = true
			health.colorClass = true
			health.colorReaction = true	
		end
	
		-- power
		local power = CreateFrame('StatusBar', nil, self)
		power:SetHeight(TukuiDB.Scale(6))
		power:SetPoint("TOPLEFT", health, "BOTTOMLEFT", 0, -TukuiDB.mult)
		power:SetPoint("TOPRIGHT", health, "BOTTOMRIGHT", 0, -TukuiDB.mult)
		power:SetStatusBarTexture(normTex)
		
		power.frequentUpdates = true
		power.colorPower = true
		if db.showsmooth == true then
			power.Smooth = true
		end

		local powerBG = power:CreateTexture(nil, 'BORDER')
		powerBG:SetAllPoints(power)
		powerBG:SetTexture(normTex)
		powerBG.multiplier = 0.3
		
		power.value = TukuiDB.SetFontString(health, font1, 12, "OUTLINE")
		power.value:SetPoint("RIGHT", TukuiDB.Scale(-2), TukuiDB.Scale(1))
		power.PreUpdate = TukuiDB.PreUpdatePower
		power.PostUpdate = TukuiDB.PostUpdatePower
				
		self.Power = power
		self.Power.bg = powerBG
		
		-- names
		local Name = health:CreateFontString(nil, "OVERLAY")
		Name:SetPoint("CENTER", health, "CENTER", 0, TukuiDB.Scale(1))
		Name:SetJustifyH("CENTER")
		Name:SetFont(font1, 12, "OUTLINE")
		Name:SetShadowColor(0, 0, 0)
		Name:SetShadowOffset(1.25, -1.25)
		
		self:Tag(Name, '[Tukui:getnamecolor][Tukui:namelong]')
		self.Name = Name
		
		-- create buff at left of unit if they are boss units
		if (unit and unit:find("boss%d")) then
			local buffs = CreateFrame("Frame", nil, self)
			buffs:SetHeight(26)
			buffs:SetWidth(252)
			buffs:SetPoint("RIGHT", self, "LEFT", TukuiDB.Scale(-4), 0)
			buffs.size = 26
			buffs.num = 3
			buffs.spacing = 2
			buffs.initialAnchor = 'RIGHT'
			buffs["growth-x"] = "LEFT"
			buffs.PostCreateIcon = TukuiDB.PostCreateAura
			buffs.PostUpdateIcon = TukuiDB.PostUpdateAura
			self.Buffs = buffs
		end

		-- create debuff for both arena and boss units
		local debuffs = CreateFrame("Frame", nil, self)
		debuffs:SetHeight(26)
		debuffs:SetWidth(200)
		debuffs:SetPoint('LEFT', self, 'RIGHT', TukuiDB.Scale(4), 0)
		debuffs.size = 26
		debuffs.num = 5
		debuffs.spacing = 2
		debuffs.initialAnchor = 'LEFT'
		debuffs["growth-x"] = "LEFT"
		debuffs.PostCreateIcon = TukuiDB.PostCreateAura
		debuffs.PostUpdateIcon = TukuiDB.PostUpdateAura
		debuffs.onlyShowPlayer = db.playerdebuffsonly
		self.Debuffs = debuffs	
		
		
		if (unit and unit:find("arena%d")) or (unit and unit:find("boss%d")) then
			if (unit and unit:find("boss%d")) then
				self.Buffs:SetPoint("RIGHT", self, "LEFT", -4, 0)
				self.Buffs.num = 3
				self.Buffs.numBuffs = 3
				self.Buffs.initialAnchor = "RIGHT"
				self.Buffs["growth-x"] = "LEFT"
			end
			self.Debuffs.num = 5
			self.Debuffs.size = 26
			self.Debuffs:SetPoint('LEFT', self, 'RIGHT', 4, 0)
			self.Debuffs.initialAnchor = "LEFT"
			self.Debuffs["growth-x"] = "RIGHT"
			self.Debuffs["growth-y"] = "DOWN"
			self.Debuffs:SetHeight(26)
			self.Debuffs:SetWidth(200)
			self.Debuffs.onlyShowPlayer = db.playerdebuffsonly
		end	
		
		-- trinket feature via trinket plugin
		if not IsAddOnLoaded("Gladius") then
			if (unit and unit:find('arena%d')) then
				local Trinketbg = CreateFrame("Frame", nil, self)
				Trinketbg:SetHeight(26)
				Trinketbg:SetWidth(26)
				Trinketbg:SetPoint("RIGHT", self, "LEFT", -6, 0)				
				TukuiDB.SetTemplate(Trinketbg)
				Trinketbg:SetFrameLevel(0)
				self.Trinketbg = Trinketbg
				
				local Trinket = CreateFrame("Frame", nil, Trinketbg)
				Trinket:SetAllPoints(Trinketbg)
				Trinket:SetPoint("TOPLEFT", Trinketbg, TukuiDB.Scale(2), TukuiDB.Scale(-2))
				Trinket:SetPoint("BOTTOMRIGHT", Trinketbg, TukuiDB.Scale(-2), TukuiDB.Scale(2))
				Trinket:SetFrameLevel(1)
				Trinket.trinketUseAnnounce = true
				self.Trinket = Trinket
			end
		end
		
		self:SetAttribute("initial-height", TukuiDB.Scale(29))
		self:SetAttribute("initial-width", TukuiDB.Scale(200))
	end

	------------------------------------------------------------------------
	--	Main tanks and Main Assists layout (both mirror'd)
	------------------------------------------------------------------------
	
	if(self:GetParent():GetName():match"oUF_MainTank" or self:GetParent():GetName():match"oUF_MainAssist") then
		-- Right-click focus on maintank or mainassist units
		self:SetAttribute("type2", "focus")
		
		-- health 
		local health = CreateFrame('StatusBar', nil, self)
		health:SetHeight(TukuiDB.Scale(20))
		health:SetPoint("TOPLEFT")
		health:SetPoint("TOPRIGHT")
		health:SetStatusBarTexture(normTex)
		
		local healthBG = health:CreateTexture(nil, 'BORDER')
		healthBG:SetAllPoints()
		healthBG:SetTexture(.1, .1, .1)
				
		self.Health = health
		self.Health.bg = healthBG
		
		health.frequentUpdates = true
		if db.showsmooth == true then
			health.Smooth = true
		end
		
		if db.unicolor == true then
			health.colorDisconnected = false
			health.colorClass = false
			health:SetStatusBarColor(.3, .3, .3, 1)
			healthBG:SetVertexColor(.1, .1, .1, 1)
		else
			health.colorDisconnected = true
			health.colorClass = true
			health.colorReaction = true	
		end
		
		-- names
		local Name = health:CreateFontString(nil, "OVERLAY")
		Name:SetPoint("CENTER", health, "CENTER", 0, TukuiDB.Scale(1))
		Name:SetJustifyH("CENTER")
		Name:SetFont(font1, 12, "OUTLINE")
		Name:SetShadowColor(0, 0, 0)
		Name:SetShadowOffset(1.25, -1.25)
		
		self:Tag(Name, '[Tukui:getnamecolor][Tukui:nameshort]')
		self.Name = Name
			
		self:SetAttribute("initial-height", TukuiDB.Scale(20))
		self:SetAttribute("initial-width", TukuiDB.Scale(100))	
	end

	------------------------------------------------------------------------
	--	Features we want for all units at the same time
	------------------------------------------------------------------------
	
	-- here we create an invisible frame for all element we want to show over health/power.
	-- because we can only use self here, and self is under all elements.
	local InvFrame = CreateFrame("Frame", nil, self)
	InvFrame:SetFrameStrata("HIGH")
	InvFrame:SetFrameLevel(5)
	InvFrame:SetAllPoints()
	
	-- symbols, now put the symbol on the frame we created above.
	local RaidIcon = InvFrame:CreateTexture(nil, "OVERLAY")
	RaidIcon:SetTexture("Interface\\AddOns\\Tukui\\media\\textures\\raidicons.blp") -- thx hankthetank for texture
	RaidIcon:SetHeight(20)
	RaidIcon:SetWidth(20)
	RaidIcon:SetPoint("TOP", 0, 8)
	self.RaidIcon = RaidIcon
	
	return self
end

------------------------------------------------------------------------
--	Default position of Tukui unitframes
------------------------------------------------------------------------

-- for lower reso
local adjustXY = 0
local totdebuffs = 0
if TukuiDB.lowversion then adjustXY = 24 end
if db.totdebuffs then totdebuffs = 24 end

oUF:RegisterStyle('Tukz', Shared)

oUF:SetActiveStyle('Tukz')
oUF:Spawn('player', "oUF_Tukz_player"):SetPoint("BOTTOMLEFT", TukuiActionBarBackground, "TOPLEFT", 0,8+adjustXY)
oUF:Spawn('focus', "oUF_Tukz_focus"):SetPoint("CENTER", TukuiInfoRight, "CENTER")
oUF:Spawn('target', "oUF_Tukz_target"):SetPoint("BOTTOMRIGHT", TukuiActionBarBackground, "TOPRIGHT", 0,8+adjustXY)

if TukuiDB.lowversion then
	oUF:Spawn("targettarget", "oUF_Tukz_targettarget"):SetPoint("BOTTOMRIGHT", TukuiActionBarBackground, "TOPRIGHT", 0,8)
	oUF:Spawn("pet", "oUF_Tukz_pet"):SetPoint("BOTTOMLEFT", TukuiActionBarBackground, "TOPLEFT", 0,8)
else
	oUF:Spawn('pet', "oUF_Tukz_pet"):SetPoint("BOTTOM", TukuiActionBarBackground, "TOP", 0,49+totdebuffs)
	oUF:Spawn('targettarget', "oUF_Tukz_targettarget"):SetPoint("BOTTOM", TukuiActionBarBackground, "TOP", 0,8)
end
if db.showfocustarget == true then oUF:Spawn("focustarget", "oUF_Tukz_focustarget"):SetPoint("BOTTOM", 0, 224) end


if not IsAddOnLoaded("Gladius") then
	local arena = {}
	for i = 1, 5 do
		arena[i] = oUF:Spawn("arena"..i, "oUF_Arena"..i)
		if i == 1 then
			arena[i]:SetPoint("BOTTOM", UIParent, "BOTTOM", 252, 260)
		else
			arena[i]:SetPoint("BOTTOM", arena[i-1], "TOP", 0, 10)
		end
	end
end

if not IsAddOnLoaded("DXE") then
	for i = 1,MAX_BOSS_FRAMES do
		local t_boss = _G["Boss"..i.."TargetFrame"]
		t_boss:UnregisterAllEvents()
		t_boss.Show = TukuiDB.dummy
		t_boss:Hide()
		_G["Boss"..i.."TargetFrame".."HealthBar"]:UnregisterAllEvents()
		_G["Boss"..i.."TargetFrame".."ManaBar"]:UnregisterAllEvents()
	end

	local boss = {}
	for i = 1, MAX_BOSS_FRAMES do
		boss[i] = oUF:Spawn("boss"..i, "oUF_Boss"..i)
		if i == 1 then
			boss[i]:SetPoint("BOTTOM", UIParent, "BOTTOM", 252, 260)
		else
			boss[i]:SetPoint('BOTTOM', boss[i-1], 'TOP', 0, 10)             
		end
	end
end

if db.maintank == true then
	local tank = oUF:SpawnHeader("oUF_MainTank", nil, 'raid, party, solo', 
		"showRaid", true, "groupFilter", "MAINTANK", "yOffset", 5, "point" , "BOTTOM",
		"template", "oUF_tukzMtt"
	)
	tank:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
end

if db.mainassist == true then
	local assist = oUF:SpawnHeader("oUF_MainAssist", nil, 'raid, party, solo', 
		"showRaid", true, "groupFilter", "MAINASSIST", "yOffset", 5, "point" , "BOTTOM",
		"template", "oUF_tukzMtt"
	)
	assist:SetPoint("CENTER", UIParent, "CENTER", 0, -100)
end

local party = oUF:SpawnHeader("oUF_noParty", nil, "party", "showParty", true)

------------------------------------------------------------------------
--	Just a command to test buffs/debuffs alignment
------------------------------------------------------------------------

local testui = TestUI or function() end
TestUI = function()
	testui()
	UnitAura = function()
		-- name, rank, texture, count, dtype, duration, timeLeft, caster
		return 'penancelol', 'Rank 2', 'Interface\\Icons\\Spell_Holy_Penance', random(5), 'Magic', 0, 0, "player"
	end
	if(oUF) then
		for i, v in pairs(oUF.units) do
			if(v.UNIT_AURA) then
				v:UNIT_AURA("UNIT_AURA", v.unit)
			end
		end
	end
end
SlashCmdList.TestUI = TestUI
SLASH_TestUI1 = "/testui"

------------------------------------------------------------------------
-- Right-Click on unit frames menu. 
-- Doing this to remove SET_FOCUS eveywhere.
-- SET_FOCUS work only on default unitframes.
-- Main Tank and Main Assist, use /maintank and /mainassist commands.
------------------------------------------------------------------------

do
	UnitPopupMenus["SELF"] = { "PVP_FLAG", "LOOT_METHOD", "LOOT_THRESHOLD", "OPT_OUT_LOOT_TITLE", "LOOT_PROMOTE", "DUNGEON_DIFFICULTY", "RAID_DIFFICULTY", "RESET_INSTANCES", "RAID_TARGET_ICON", "LEAVE", "CANCEL" };
	UnitPopupMenus["PET"] = { "PET_PAPERDOLL", "PET_RENAME", "PET_ABANDON", "PET_DISMISS", "CANCEL" };
	UnitPopupMenus["PARTY"] = { "MUTE", "UNMUTE", "PARTY_SILENCE", "PARTY_UNSILENCE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "WHISPER", "PROMOTE", "PROMOTE_GUIDE", "LOOT_PROMOTE", "VOTE_TO_KICK", "UNINVITE", "INSPECT", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "PVP_REPORT_AFK", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL" }
	UnitPopupMenus["PLAYER"] = { "WHISPER", "INSPECT", "INVITE", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL" }
	UnitPopupMenus["RAID_PLAYER"] = { "MUTE", "UNMUTE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "WHISPER", "INSPECT", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "RAID_LEADER", "RAID_PROMOTE", "RAID_DEMOTE", "LOOT_PROMOTE", "RAID_REMOVE", "PVP_REPORT_AFK", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL" }
	UnitPopupMenus["RAID"] = { "MUTE", "UNMUTE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "RAID_LEADER", "RAID_PROMOTE", "LOOT_PROMOTE", "RAID_DEMOTE", "RAID_REMOVE", "PVP_REPORT_AFK", "CANCEL" }
	UnitPopupMenus["VEHICLE"] = { "RAID_TARGET_ICON", "VEHICLE_LEAVE", "CANCEL" }
	UnitPopupMenus["TARGET"] = { "RAID_TARGET_ICON", "CANCEL" }
	UnitPopupMenus["ARENAENEMY"] = { "CANCEL" }
	UnitPopupMenus["FOCUS"] = { "RAID_TARGET_ICON", "CANCEL" }
	UnitPopupMenus["BOSS"] = { "RAID_TARGET_ICON", "CANCEL" }
end

