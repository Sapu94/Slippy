-- TODO LIST (in no particular order):
--	overall:
--		1. Make sure all of the included librarys are getting used and get rid of any that aren't.
--		2. Incorperate more with Quick Auctions: mat cost / scroll selling price.
--		3. Have the queue be refreshed when an enchant is cast and remove that enchant from the list.
--		4. Who doesn't love localizations?!
--		5. Make less stuff global!
--	gui.lua
--		1. Add tooltip functionality.
--		2. Add total costs of the materials to the summary window.

Slippy = LibStub("AceAddon-3.0"):NewAddon("Slippy", "AceConsole-3.0", "AceEvent-3.0")
AceGUI = LibStub("AceGUI-3.0")
Slippyversion = "1.5" -- current version of the addon
local QAAPI_STATUS

-- default values for the different material costs for new profiles in SlippyDB
local Slippydefaults = {
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

-- Called when the addon is loaded
function Slippy:OnInitialize()
	--checks to make sure that the command QAAPI:GetData exists and warns the user if it doesn't.
	--will later automatically disable components that rely on the QAAPI to avoid errors.
	if pcall(function() QAAPI:GetData() end) then 
		QAAPI_STATUS = true
		self:Print("Loaded Slippy v" .. Slippyversion .. " and QAAPI successfully!")
	else
		self:Print("Loaded Slippy v" .. Slippyversion .. "!")
		self:Print("Warning: Your version of Quick Auctions does not support the QAAPI.")
		self:Print("Some features may be disabled or give errors.")
		self:Print("Please read the README file in the Slippy directory for more information.")
		QAAPI_STATUS = false
	end
	
	db = LibStub:GetLibrary("AceDB-3.0"):New("SlippyDB", Slippydefaults, true)
    self:RegisterChatCommand("sl", "ChatCommand")
    self:RegisterChatCommand("slippy", "ChatCommand")
	Slippy:Register_Options_Frame() -- Loads options-table
	Slippy_Frame_Shown_12356741 = "0"
	Slippy:FrameToggle()
	frame:Hide()
end

-- Called when the addon is enabled - for possible future use
function Slippy:OnEnable() end

-- Called when the addon is disabled - for possible future use
function Slippy:OnDisable() end

-- deals with slash commands
function Slippy:ChatCommand(input)
	if input == "config" then	-- '/sl config' opens up the options window
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
	elseif input == "summary" then	-- '/sl summary' opens up the main window
		frame:Show()
		tab:SelectTab("tab1")
	elseif input == "queue" then	-- '/sl queue' opens up the summary window
		Slippy:Calctotals()
		frame2:Show()
		tab2:SelectTab("tab21")
	elseif input == "test" then
		SlippyGUI_Background:Show()
	else	-- if the command is unrecognized, print out the slash commands to help the user
        self:Print("Slash Commands:")
		print("/sl summary - Opens window for viewing / selecting enchants.")
		print("/sl queue - Opens window for viewing totals / craft queue.")
		print("/sl config - Opens the options frame.")
    end
end

-- Calcuates the costs for all enchants of the passed slot.
function Slippy:Calc(slot)
	-- table.getn returns the size of the table which here is the number of enchants in a slot
	for i=1, table.getn(slippyData[slot][1]) do
		slippyData[slot][12][i] = slippyData[slot][2][i]*db.profile.dust
			+ slippyData[slot][3][i]*db.profile.gce + slippyData[slot][4][i]*db.profile.lce
			+ slippyData[slot][5][i]*db.profile.dream + slippyData[slot][6][i]*db.profile.abyss
			+ slippyData[slot][7][i]*db.profile.titanium + slippyData[slot][8][i]*db.profile.water
			+ slippyData[slot][9][i]*db.profile.earth + slippyData[slot][10][i]*db.profile.air
			+ slippyData[slot][11][i]*db.profile.titansteel
		--GUItable[2][slot][i]:SetText(slippydata[slot][12][i] .. "g")
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
		-- for j=1, 9 do
			-- for i=1, table.getn(slippyData[j][1]) do
				-- db.profile.totals[k] = db.profile.totals[k] + slippyData[j][k+1][i]*Slippy:BooleanToNumber(slippyData[j][1][i])
			-- end
		-- end
		for i=1, table.getn(slippyData[7][1]) do
			db.profile.totals[k] = db.profile.totals[k] + slippyData[8][k+1][i]*Slippy:BooleanToNumber(slippyData[8][1][i]) +
				slippyData[7][k+1][i]*Slippy:BooleanToNumber(slippyData[7][1][i]) +
				slippyData[1][k+1][i]*Slippy:BooleanToNumber(slippyData[1][1][i])
			if k == 1 then
				db.profile.totals[11] = db.profile.totals[11] + Slippy:BooleanToNumber(slippyData[8][1][i]) + Slippy:BooleanToNumber(slippyData[1][1][i])
				db.profile.totals[12] = db.profile.totals[12] + Slippy:BooleanToNumber(slippyData[7][1][i])
			end
		end
		
		for i=1, table.getn(slippyData[6][1]) do
			db.profile.totals[k] = db.profile.totals[k] + slippyData[6][k+1][i]*Slippy:BooleanToNumber(slippyData[6][1][i])
			if k == 1 then
				db.profile.totals[12] = db.profile.totals[12] + Slippy:BooleanToNumber(slippyData[6][1][i])
			end
		end
		
		for i=1, table.getn(slippyData[4][1]) do
			db.profile.totals[k] = db.profile.totals[k] + slippyData[2][k+1][i]*Slippy:BooleanToNumber(slippyData[2][1][i]) +
				slippyData[4][k+1][i]*Slippy:BooleanToNumber(slippyData[4][1][i])
			if k == 1 then
				db.profile.totals[12] = db.profile.totals[12] + Slippy:BooleanToNumber(slippyData[2][1][i]) +	Slippy:BooleanToNumber(slippyData[4][1][i])
			end
		end
		
		for i=1, table.getn(slippyData[5][1]) do
			db.profile.totals[k] = db.profile.totals[k] + slippyData[9][k+1][i]*Slippy:BooleanToNumber(slippyData[9][1][i]) +
				slippyData[5][k+1][i]*Slippy:BooleanToNumber(slippyData[5][1][i]) +
				slippyData[3][k+1][i]*Slippy:BooleanToNumber(slippyData[3][1][i])
			if k == 1 then
				db.profile.totals[11] = db.profile.totals[11] + Slippy:BooleanToNumber(slippyData[9][1][i])
				db.profile.totals[12] = db.profile.totals[12] + Slippy:BooleanToNumber(slippyData[5][1][i]) + Slippy:BooleanToNumber(slippyData[3][1][i])
			end
		end
	end
	-- these few commands deal with the extra materials (titanium bar, eternals, etc)
	db.profile.totals[6] = db.profile.totals[6] + 2*Slippy:BooleanToNumber(slippyData[5][1][5])
	db.profile.totals[7] = db.profile.totals[7] + Slippy:BooleanToNumber(slippyData[2][1][1])
	db.profile.totals[8] = db.profile.totals[8] + Slippy:BooleanToNumber(slippyData[4][1][3]) + 6*Slippy:BooleanToNumber(slippyData[7][1][2]) +
		8*Slippy:BooleanToNumber(slippyData[6][1][4])
	db.profile.totals[9] = db.profile.totals[9] + 4*Slippy:BooleanToNumber(slippyData[9][1][6])
	db.profile.totals[10] = db.profile.totals[10] + Slippy:BooleanToNumber(slippyData[9][1][1])
	
	-- calculates the total number of enchants selected by adding the weapon and armor vellum totals
	db.profile.totals[13] = db.profile.totals[12] + db.profile.totals[11]
end

-- simple function to convert true->1 and false->0
function Slippy:BooleanToNumber(value)
	if value then return 1
	else return 0
	end
end

-- resets all of the data when the "Reset Craft Queue" button is pressed
function Slippy:ResetData()
	queue[0]:SetText("You currently have no enchants in the queue.")
	self:Print("Craft Queue Reset")

	for slot=1,9 do
		for enchant=1, table.getn(slippyData[slot][1]) do
			slippyData[slot][1][enchant] = false
			slippyData[slot][12][enchant] = 0
		end
	end	
end

-- Allows an easy to use interface with the Quick Auctions API
-- The parameters are the slot for the enchant (boots, gloves, shield, etc)
-- and the index of the item (ex. slippyData[2][][#])
-- Returns a table with the following information (assuming you return into a variable called dataTbl):
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
function Slippy:GetQAData(slot, enchant)
	if not QAAPI_STATUS then 
		print("Error[Slippy:GetQAData]: No QA scan data found.")
	return nil end
	
	local sName, sLink = GetItemInfo(slippyData[slot][13][enchant])
	return QAAPI:GetData(sLink)
end

-- Parameters: Slot and Enchant number for slippyData[slot][#][enchant]
-- Returns the profit based off the lowest buyout price according to QA
function Slippy:CalcProfit(slot, enchant)
	local tbl = Slippy:GetQAData(slot, enchant)
	local profit
	
	if not pcall(function() return tbl.records[1].buyout end) then 
		self:Print("Error[Slippy:CalcProfit]: No QA scan data found.")
	return end
	
	profit = math.floor(tbl.records[1].buyout/10000 - slippyData[slot][12][enchant] + 0.5)
	return profit
end

-- converts an itemID into the name of the item. For example,
-- Slippy:GetItemName(slippyData[2][13][1]) returns "Scroll of Enchant Boots - Icewalker"
function Slippy:GetItemName(sItemID)
	local sName = GetItemInfo(sItemID)
	return sName
end