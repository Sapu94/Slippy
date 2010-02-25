function Slippy:FrameToggle()
	local totalCost = "0"
	
	local function DrawGroup1(container)
		local desc = AceGUI:Create("Label")
		desc:SetText("This is Tab 1")
		desc:SetFullWidth(true)
		container:AddChild(desc)
		 
		local button = AceGUI:Create("Button")
		button:SetText("Tab 1 Button")
		button:SetWidth(200)
		container:AddChild(button)
		button:SetCallback("OnClick", function() self.frame:hide() end)
	end

	-- function that draws the widgets for the second tab
	local function DrawGroup2(container)
		local desc = AceGUI:Create("Label")
		desc:SetText("This is Tab 2")
		desc:SetFullWidth(true)
		container:AddChild(desc)
		
		local button = AceGUI:Create("Button")
		button:SetText("Tab 2 Button")
		button:SetWidth(200)
		container:AddChild(button)
	end

	-- Callback function for OnGroupSelected
	local function SelectGroup(container, event, group)
		container:ReleaseChildren()
		if group == "tab1" then
			DrawGroup1(container)
		elseif group == "tab2" then
			DrawGroup2(container)
		end
	end

	-- Create the frame container
	frame = AceGUI:Create("Frame")
	frame:SetTitle("Example Frame")
	frame:SetStatusText(totalCost)
	frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
	frame:SetCallback("OnHide", function() AceGUI:ReleaseChildren(container)end)
	-- Fill Layout - the TabGroup widget will fill the whole frame
	frame:SetLayout("List")

	-- Create the TabGroup
	tab =  AceGUI:Create("TabGroup")
	tab:SetLayout("Flow")
	tab:SetRelativeWidth(1)
	tab:SetHeight(400)
	-- Setup which tabs to show
	tab:SetTabs({{text="Tab 1", value="tab1"}, {text="Tab 2", value="tab2"}})
	-- Register callback
	tab:SetCallback("OnGroupSelected", SelectGroup)
	-- Set initial Tab (this will fire the OnGroupSelected callback)
	tab:SelectTab("tab1")

	tab2 = AceGUI:Create("TabGroup")
	--tab2:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT")
	tab2:SetRelativeWidth(1)
	tab2:SetLayout("Flow")
	tab2:SetTabs({{text="Tab 1", value="tab1"}, {text="Tab 2", value="tab2"}})
	-- Register callback
	tab2:SetCallback("OnGroupSelected", SelectGroup)
	-- Set initial Tab (this will fire the OnGroupSelected callback)
	tab2:SelectTab("tab1")
	-- add to the frame container
	frame:AddChild(tab)
	frame:AddChild(tab2)
	Slippy_Frame_Shown_12356741 = "1"
end

local slippy_options_frame = { -- Config Settings!!!!
	type = "group", 
	args = {
		SlippyOptionsDescription = {
			type = "description",
			name = "Easy way to view the materials and total estimated cost of user selected current enchants.\nFeel free to contact us at |cff00ff00SlippyAddon@gmail.com\r",
		},
		--Options Frame!
		SlippyOptionsHeader = {
			order = 2,
			type = "header",
			name = GetAddOnMetadata("Slippy", "title").." v"..GetAddOnMetadata("Slippy", "version"),
		},
		SlippyOptFrame = {
			order = 3,
			type  = "group",
			name  = "Enchant Options",
			handler = Slippy,
			args = {
				Header = {  -- Title which appears as a main-tab-option
					type = "header",
					order = 1,
					name = "Enchant Options"
				},
				description = {  -- Description - shows up at the top of the right-pane
					type = "description",
					order = 2,
					name = "Set values for materials in gold.\nExample: 20.32 = 20 Gold, 32 Silver",
				},
				infiniteDust = {
					type = "input",
					name = "Infinite Dust",
					desc = "The cost of 1 infinite dust in gold",
					get = "GetDust",
					set = "SetDust",
				},
				gce = {
					type = "input",
					name = "Greater Cosmic Essence",
					desc = "The cost of 1 greater cosmic essence in gold",
					get = "GetGCE",
					set = "SetGCE",
				},
				lce = {
					type = "input",
					name = "Lesser Cosmic Essence",
					desc = "The cost of 1 lesser cosmic essence in gold",
					get = "GetLCE",
					set = "SetLCE",
				},
				dream = {
					type = "input",
					name = "Dream Shard",
					desc = "The cost of 1 dream shard in gold",
					get = "GetDream",
					set = "SetDream",
				},
				abyss = {
					type = "input",
					name = "Abyss Crystal",
					desc = "The cost of 1 abyss crystal in gold",
					get = "GetAbyss",
					set = "SetAbyss",
				},
				titanium = {
					type = "input",
					name = "Titanium Bar",
					desc = "The cost of 1 Titanium Bar in gold",
					get = "GetTitanium",
					set = "SetTitanium",
				},
				water = {
					type = "input",
					name = "Crystallized Water",
					desc = "The cost of 1 Crystallized Water in gold",
					get = "GetWater",
					set = "SetWater",
				},
				earth = {
					type = "input",
					name = "Eternal Earth",
					desc = "The cost of 1 eternal earth in gold",
					get = "GetEarth",
					set = "SetEarth",
				},
				air = {
					type = "input",
					name = "Eternal Air",
					desc = "The cost of 1 eternal air in gold",
					get = "GetAir",
					set = "SetAir",
				},
				titansteel = {
					type = "input",
					name = "Titansteel Bar",
					desc = "The cost of 1 titansteel bar in gold",
					get = "GetTitansteel",
					set = "SetTitansteel",
				},
			},
		},
	},
}
	
function Slippy:Register_Options_Frame() 
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Slippy", slippy_options_frame)
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Slippy", "Slippy")
end

-- Creates a frame with the proper offsets. Easy of coding purposes. 
-- Returns a reference to the created frame.
function Slippy:CreateFrame(anchor,anchorpoint,x,y,width,height,name,type1,buttonText)
	TempFrame=CreateFrame(type1,"SlippyGUI_MainBackground_Frame_"..name,anchor)
	if(TempFrame:IsVisible()) then
		while 1>0 do
			if(TempFrame:IsVisible()==nil) then
				break;
			end
			TempFrame:Hide()
		end
	end
	
	if(strlower(type1)=="button") then
		MyFrame=CreateFrame(type1,"SlippyGUI_MainBackground_Frame_"..name,anchor,"UIPanelButtonTemplate")
		MyFrame:SetText(buttonText)
	else
		MyFrame=CreateFrame(type1,"SlippyGUI_MainBackground_Frame_"..name,anchor)
	end
	
	MyFrame:SetPoint(anchorpoint,x,y)
	MyFrame:SetWidth(width)
	MyFrame:SetHeight(height)
	return MyFrame
end

-- the long and complicated function which handles ALL swapping of Main content for the main-frame. 
-- The basic gist of it is that it inputs a number which corresponds to a button on the left-menu. 
-- That number is then used to create a frame and anchor that frame to the main-content area.
function Slippy:SlippyGUI_SelectGroup(number)
	f=Slippy:CreateFrame(SlippyGUI_MainBackground1,"TOPLEFT",15,-15,555,310,"Test","Frame")
	g=Slippy:CreateFrame(f,"TOPLEFT",5,-5,100,20,"Button_1Test","Button","This is Some text")
end
	
	
	
	
	