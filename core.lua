-- TODO LIST (in no particular order):
--	overall:
--		1. Make sure all of the included librarys are getting used and get rid of any that aren't.
--		2. Incorperate more with Quick Auctions: mat cost, craft queue, scroll selling price.
--		3. Have the queue be refreshed when an enchant is cast and remove that enchant from the list.
--		4. Who doesn't love localizations?!
--		5. Look into better splitting up the files.
--		6. Fix the bug that causes problems when more than one window is open at a time.
--		7. Make less stuff global!
--	core.lua:
--		1. Improve the options interface. Fix the "Show Vellums" box
--	gui.lua
--		1. Add tooltip functionality.
--		2. Make the text in the summary frame larger / easier to read.
--		3. Improve how the GUI closes / releases widgets and frames.
--		4. Get rid of the "Calculate Prices" buttons and caluclate them automatically upon loading the tab instead.
--		5. Add total costs of the materials to the summary window.
--		6. Combine the windows with a dynamic summary.

Slippy = LibStub("AceAddon-3.0"):NewAddon("Slippy", "AceConsole-3.0", "AceEvent-3.0")
AceGUI = LibStub("AceGUI-3.0")
Slippyversion = "1.2" -- current version of the addon

-- default values for the different material costs for new profiles in SlippyDB
Slippydefaults = {
	profile = {
		infiniteDust = 2,
		gce = 15,
		lce = 5,
		dream = 6,
		abyss = 29,
		titanium = 18,
		water = 0.2,
		earth = 6,
		air = 21,
		titansteel = 130,
		vellum = true,
		totals = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	},
}

-- options frame
local options = {
    name = "Slippy",
    handler = Slippy,
    type = "group",
    args = {
		infiniteDust = {
            type = "input",
            name = "Infinite Dust",
            desc = "The cost of 1 infinite dust in gold",
            get = function(info) return db.profile.dust end,
            set = function(info, val) db.profile.dust=val end,
        },
		gce = {
            type = "input",
            name = "Greater Cosmic Essence",
            desc = "The cost of 1 greater cosmic essence in gold",
            get = function(info) return db.profile.gce end,
            set = function(info, val) db.profile.gce=val end,
        },
		lce = {
            type = "input",
            name = "Lesser Cosmic Essence",
            desc = "The cost of 1 lesser cosmic essence in gold",
            get = function(info) return db.profile.lce end,
            set = function(info, val) db.profile.lce=val end,
        },
		dream = {
            type = "input",
            name = "Dream Shard",
            desc = "The cost of 1 dream shard in gold",
            get = function(info) return db.profile.dream end,
            set = function(info, val) db.profile.dream=val end,
        },
		abyss = {
            type = "input",
            name = "Abyss Crystal",
            desc = "The cost of 1 abyss crystal in gold",
            get = function(info) return db.profile.abyss end,
            set = function(info, val) db.profile.abyss=val end,
        },
		titanium = {
            type = "input",
            name = "Titanium Bar",
            desc = "The cost of 1 Titanium Bar in gold",
            get = function(info) return db.profile.titanium end,
            set = function(info, val) db.profile.titanium=val end,
        },
		water = {
            type = "input",
            name = "Crystallized Water",
            desc = "The cost of 1 Crystallized Water in gold",
            get = function(info) return db.profile.water end,
            set = function(info, val) db.profile.water=val end,
        },
		earth = {
            type = "input",
            name = "Eternal Earth",
            desc = "The cost of 1 eternal earth in gold",
            get = function(info) return db.profile.earth end,
            set = function(info, val) db.profile.earth=val end,
        },
		air = {
            type = "input",
            name = "Eternal Air",
            desc = "The cost of 1 eternal air in gold",
            get = function(info) return db.profile.air end,
            set = function(info, val) db.profile.air=val end,
        },
		titansteel = {
            type = "input",
            name = "Titansteel Bar",
            desc = "The cost of 1 titansteel bar in gold",
            get = function(info) return db.profile.titansteel end,
            set = function(info, val) db.profile.titansteel=val end,
        },
		vellum = {
            type = "toggle",
            name = "Show Vellums",
            desc = "Toggles showing vellums in the totals window (on/off).",
            get = function(info) return db.profile.vellum end,
            set = function(info, val) db.profile.vellum=val end,
        },
    },
}

-- dataTbl = {
    -- quantity = #, -- total number of items, including stacked
    -- onlyPlayer = true/false, -- Is the player the only one with items up
    -- records = { -- List of all items, by price per item. Multiple auctions at the same *per price* level and from the same person are merged
        -- {
            -- buyout = #, -- Buyout in copper, per item
            -- bid = #, -- Bid in copper, per item
            -- owner = "foo", -- Name 
            -- quantity = #, -- How many total are up at this tier/owner
            -- isPlayer = true/false,
        -- },
    -- },
-- }

-- Called when the addon is loaded
function Slippy:OnInitialize()
	self:Print("Loaded Slippy v" .. Slippyversion .. "!")
    db = LibStub:GetLibrary("AceDB-3.0"):New("SlippyDB", Slippydefaults, true)
	
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Slippy", options)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Slippy", "Slippy")
    self:RegisterChatCommand("sl", "ChatCommand")
    self:RegisterChatCommand("slippy", "ChatCommand")
	frame:Hide()
	frame2:Hide()
end

-- Called when the addon is enabled - for possible future use
function Slippy:OnEnable() end

-- Called when the addon is disabled - for possible future use
function Slippy:OnDisable() end

-- deals with slash commands
function Slippy:ChatCommand(input)
	if input == "config" then	-- '/sl config' opens up the options window
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
	elseif input == "test" then -- for testing out QA integration
		local dataTbl = Slippy:GetQAData(8, 1)
		self:Print(dataTbl.quantity)
	elseif input == "summary" then	-- '/sl summary' opens up the main window
		frame:Show()
		tab:SelectTab("tab1")
	elseif input == "queue" then	-- '/sl queue' opens up the summary window
		Slippy:Calctotals()
		frame2:Show()
		tab2:SelectTab("tab21")
	else	-- if the command is unrecognized, print out the slash commands to help the user
        self:Print("Slash Commands:")
		print("/sl summary - Opens window for viewing / selecting enchants.")
		print("/sl queue - Opens window for viewing totals / craft queue.")
		print("/sl config - Opens the options frame.")
    end
end

-- gets called whenever the value of a checkbox is changed
-- this function takes in the new value of the checkbox (true/false) as well as
-- the slot which corresponds to the type of item the enchant is for (boots, bracers, staff, etc)
-- and also it takes in a number corresponding to the enchant
-- it then sets the correct array from the data.lua file to the value of the checkbox
function Slippy:SetEnchant(value, slot, enchant)
	if slot == 1 then
		twoH[1][enchant] = value
	elseif slot == 2 then
		boots[1][enchant] = value
	elseif slot == 3 then
		bracers[1][enchant] = value
	elseif slot == 4 then
		chest[1][enchant] = value
	elseif slot == 5 then
		cloak[1][enchant] = value
	elseif slot == 6 then
		gloves[1][enchant] = value
	elseif slot == 7 then
		shield[1][enchant] = value
	elseif slot == 8 then
		staff[1][enchant] = value
	elseif slot == 9 then
		weapon[1][enchant] = value
	else print("Error: SetEnchant could not determine slot.") end
end

-- Calculates the costs for all of the 2H weapon enchants
function Slippy:CalcTwoH()
	for i=1, 2 do
		twoH[12][i] = twoH[2][i]*db.profile.dust + twoH[3][i]*db.profile.gce +
			twoH[4][i]*db.profile.lce + twoH[5][i]*db.profile.dream + twoH[6][i]*db.profile.abyss
		GUItable[2][1][i]:SetText(twoH[12][i] .. "g")
	end
end

-- Calculates the costs for all of the boot enchants
function Slippy:CalcBoots()
	for i=1, 8 do
		boots[12][i] = boots[2][i]*db.profile.dust + boots[3][i]*db.profile.gce + boots[4][i]*db.profile.lce
			+ boots[5][i]*db.profile.dream + boots[6][i]*db.profile.abyss + boots[8][i]*db.profile.water
		GUItable[2][2][i]:SetText(boots[12][i] .. "g")
	end
end

-- Calculates the costs for all of the bracer enchants
function Slippy:CalcBracers()
	for i=1, 9 do
		bracers[12][i] = bracers[2][i]*db.profile.dust + bracers[3][i]*db.profile.gce +
			bracers[4][i]*db.profile.lce + bracers[5][i]*db.profile.dream + bracers[6][i]*db.profile.abyss
		GUItable[2][3][i]:SetText(bracers[12][i] .. "g")
	end
end

-- Calculates the costs for all of the chest enchants
function Slippy:CalcChest()
	for i=1, 8 do
		chest[12][i] = chest[2][i]*db.profile.dust + chest[3][i]*db.profile.gce + chest[4][i]*db.profile.lce
			+ chest[5][i]*db.profile.dream + chest[6][i]*db.profile.abyss + chest[9][i]*db.profile.earth
		GUItable[2][4][i]:SetText(chest[12][i] .. "g")
	end
end

-- Calculates the costs for all of the cloak enchants
function Slippy:CalcCloak()
	for i=1, 9 do
		cloak[12][i] = cloak[2][i]*db.profile.dust + cloak[3][i]*db.profile.gce + cloak[4][i]*db.profile.lce
			+ cloak[5][i]*db.profile.dream + cloak[6][i]*db.profile.abyss + cloak[7][i]*db.profile.titanium
		GUItable[2][5][i]:SetText(cloak[12][i] .. "g")
	end
end

-- Calculates the costs for all of the glove enchants
function Slippy:CalcGloves()
	for i=1, 7 do
		gloves[12][i] = gloves[2][i]*db.profile.dust + gloves[3][i]*db.profile.gce + gloves[4][i]*db.profile.lce
			+ gloves[5][i]*db.profile.dream + gloves[6][i]*db.profile.abyss + gloves[9][i]*db.profile.earth
		GUItable[2][6][i]:SetText(gloves[12][i] .. "g")
	end
end

-- Calculates the costs for all of the shield enchants
function Slippy:CalcShield()
	for i=1, 2 do
		shield[12][i] = shield[2][i]*db.profile.dust + shield[3][i]*db.profile.gce + shield[4][i]*db.profile.lce
			+ shield[5][i]*db.profile.dream + shield[6][i]*db.profile.abyss + shield[9][i]*db.profile.earth
		GUItable[2][7][i]:SetText(shield[12][i] .. "g")
	end
end

-- Calculates the costs for all of the staff enchants
function Slippy:CalcStaff()
	for i=1, 2 do
		staff[12][i] = staff[2][i]*db.profile.dust + staff[3][i]*db.profile.gce + staff[4][i]*db.profile.lce
			+ staff[5][i]*db.profile.dream + staff[6][i]*db.profile.abyss
		GUItable[2][8][i]:SetText(staff[12][i] .. "g")
	end
end

-- Calculates the costs for all of the weapon enchants
function Slippy:CalcWeapon()
	for i=1, 9 do
		weapon[12][i] = weapon[2][i]*db.profile.dust + weapon[3][i]*db.profile.gce
		+ weapon[4][i]*db.profile.lce + weapon[5][i]*db.profile.dream + weapon[6][i]*db.profile.abyss
		+ weapon[10][i]*db.profile.air + weapon[11][i]*db.profile.titansteel
		GUItable[2][9][i]:SetText(weapon[12][i] .. "g")
	end
end

-- totals = dust, gce, lce, dream, abyss, titanium, water, earth, air, titansteel, wepeaonvellum, armorvellum, totalnumber
-- Calculates the total number of mats needed to craft the selected enchants
function Slippy:Calctotals()
	for i=1, 13 do	-- resets the totals to 0
		db.profile.totals[i] = 0
	end
	
	-- This series of for loops is where all the magic happens!
	-- The function BooleanToNumber converts the true/false value that represents
	-- if that enchant is selected or not to a 1 for true or a 0 for false.
	-- This is then multiplied by the number of the specific material needed for that enchant
	-- and added to the total of that specific material required for all selected enchants.
	-- Also, for each enchant selected, 1 is added to the number of the respective vellum needed
	-- to make an enchanting scroll for that enchant.
	for k=1, 5 do
		for i=1, 2 do
			db.profile.totals[k] = db.profile.totals[k] + staff[k+1][i]*Slippy:BooleanToNumber(staff[1][i]) +
				shield[k+1][i]*Slippy:BooleanToNumber(shield[1][i]) +
				twoH[k+1][i]*Slippy:BooleanToNumber(twoH[1][i])
			if k == 1 then
				db.profile.totals[11] = db.profile.totals[11] + Slippy:BooleanToNumber(staff[1][i]) + Slippy:BooleanToNumber(twoH[1][i])
				db.profile.totals[12] = db.profile.totals[12] + Slippy:BooleanToNumber(shield[1][i])
			end
		end
		
		for i=1, 7 do
			db.profile.totals[k] = db.profile.totals[k] + gloves[k+1][i]*Slippy:BooleanToNumber(gloves[1][i])
			if k == 1 then
				db.profile.totals[12] = db.profile.totals[12] + Slippy:BooleanToNumber(gloves[1][i])
			end
		end
		
		for i=1, 8 do
			db.profile.totals[k] = db.profile.totals[k] + boots[k+1][i]*Slippy:BooleanToNumber(boots[1][i]) +
				chest[k+1][i]*Slippy:BooleanToNumber(chest[1][i])
			if k == 1 then
				db.profile.totals[12] = db.profile.totals[12] + Slippy:BooleanToNumber(boots[1][i]) +	Slippy:BooleanToNumber(chest[1][i])
			end
		end
		
		for i=1, 9 do
			db.profile.totals[k] = db.profile.totals[k] + weapon[k+1][i]*Slippy:BooleanToNumber(weapon[1][i]) +
				cloak[k+1][i]*Slippy:BooleanToNumber(cloak[1][i]) +
				bracers[k+1][i]*Slippy:BooleanToNumber(bracers[1][i])
			if k == 1 then
				db.profile.totals[11] = db.profile.totals[11] + Slippy:BooleanToNumber(weapon[1][i])
				db.profile.totals[12] = db.profile.totals[12] + Slippy:BooleanToNumber(cloak[1][i]) + Slippy:BooleanToNumber(bracers[1][i])
			end
		end
	end
	-- these few commands deal with the extra materials (titanium bar, eternals, etc)
	db.profile.totals[6] = db.profile.totals[6] + 2*Slippy:BooleanToNumber(cloak[1][5])
	db.profile.totals[7] = db.profile.totals[7] + Slippy:BooleanToNumber(boots[1][1])
	db.profile.totals[8] = db.profile.totals[8] + Slippy:BooleanToNumber(chest[1][3]) + 6*Slippy:BooleanToNumber(shield[1][2]) +
		8*Slippy:BooleanToNumber(gloves[1][4])
	db.profile.totals[9] = db.profile.totals[9] + 4*Slippy:BooleanToNumber(weapon[1][6])
	db.profile.totals[10] = db.profile.totals[10] + Slippy:BooleanToNumber(weapon[1][1])
	
	-- calculates the total number of enchants selected by adding the weapon and armor vellum totals
	db.profile.totals[13] = db.profile.totals[12] + db.profile.totals[11]
end

function Slippy:BooleanToNumber(value)	-- simple function to convert true->1 and false->0
	if value then return 1
	elseif not value then return 0
	else print("Error: BooleanToNumber could not determine value")
	end
end

function Slippy:ResetData()	-- resets all of the data when the "Reset Craft Queue" button is pressed
	queue[0]:SetText("You currently have no enchants in the queue.")

	staff[1] = {false, false}
	staff[12] = {0, 0}
	shield[1] = {false, false}
	shield[12] = {0, 0}
	twoH[1] = {false, false}
	twoH[12] = {0, 0}
	gloves[1] = {false, false, false, false, false, false, false}
	gloves[12] = {0, 0, 0, 0, 0, 0, 0}
	chest[1] = {false, false, false, false, false, false, false, false}
	chest[12] = {0, 0, 0, 0, 0, 0, 0, 0}
	boots[1] = {false, false, false, false, false, false, false, false}
	boots[12] = {0, 0, 0, 0, 0, 0, 0, 0}
	weapon[1] = {false, false, false, false, false, false, false, false, false}
	weapon[12] = {0, 0, 0, 0, 0, 0, 0, 0, 0}
	bracers[1] = {false, false, false, false, false, false, false, false, false}
	bracers[12] = {0, 0, 0, 0, 0, 0, 0, 0, 0}
	cloak[1] = {false, false, false, false, false, false, false, false, false}
	cloak[12] = {0, 0, 0, 0, 0, 0, 0, 0, 0}
	
	frame2:Hide()
	self:Print("Craft Queue Reset")
end

function Slippy:GetQAData(group, index)
	local num

	if group == 1 then num = twoH[13][index]
	elseif group == 2 then num = boots[13][index]
	elseif group == 3 then num = bracers[13][index]
	elseif group == 4 then num = chest[13][index]
	elseif group == 5 then num = cloak[13][index]
	elseif group == 6 then num = gloves[13][index]
	elseif group == 7 then num = shield[13][index]
	elseif group == 8 then num = staff[13][index]
	elseif group == 9 then num = weapon[13][index]
	else self:Print("Error in Slippy:GetQAData - Could not determine group.")
	end
	
	local sName, sLink = GetItemInfo(num)
	return QAAPI:GetData(sLink)
end