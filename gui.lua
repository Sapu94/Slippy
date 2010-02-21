db = LibStub:GetLibrary("AceDB-3.0"):New("SlippyDB", Slippydefaults, true)

queue = {} -- contains the list of queued enchants

GUItable = {} 
-- GUItable[][][] works like this:
-- GUItable[type][group][row]
-- type: [1]=checkbox, [2]=editbox, [3]=label
-- group: local variable definied below, goes from 1 to 9

local group	-- contains the numerical representation of each type of enchant (boot, chest, etc)

for i=1,60 do
	queue[i] = nil
end

-- sets up the array that will store all the GUI elements by seeding it with 0s
for i=1,3 do
	GUItable[i] = {}
	for j=1,9 do
		GUItable[i][j] = {}
		for k=1,10 do
			GUItable[i][j][k] = {}
		end
	end
end

-- initiallizes the widgets for tab1 of the general frame
function DrawGroup1(container) -- 2H Weapon
	group = 1
	local lines = 2

	for i=1,lines-1 do
		GUItable[1][group][i] = AceGUI:Create("CheckBox")
		GUItable[1][group][i]:SetType("checkbox")
		GUItable[1][group][i]:SetValue(twoH[1][i])
		GUItable[1][group][i]:SetWidth(150)
		GUItable[1][group][i]:SetDescription(twoH[0][i])
		GUItable[2][group][i] = AceGUI:Create("EditBox")
		GUItable[2][group][i]:SetWidth(60)
		GUItable[2][group][i]:SetDisabled(true)
		GUItable[2][group][i]:SetText(twoH[12][i] .. "g")
		GUItable[3][group][i] = AceGUI:Create("Label")
		GUItable[3][group][i]:SetWidth(300)
	end
	
	GUItable[3][group][1]:SetWidth(100)
	GUItable[1][group][lines] = AceGUI:Create("CheckBox")
	GUItable[1][group][lines]:SetType("checkbox")
	GUItable[1][group][lines]:SetValue(twoH[1][lines])
	GUItable[1][group][lines]:SetWidth(150)
	GUItable[1][group][lines]:SetDescription(twoH[0][lines])
	GUItable[2][group][lines] = AceGUI:Create("EditBox")
	GUItable[2][group][lines]:SetWidth(60)
	GUItable[2][group][lines]:SetText(twoH[12][lines] .. "g")
	GUItable[2][group][lines]:SetDisabled(true)
	
	for i=1,lines do
		GUItable[1][group][i]:SetCallback("OnValueChanged", function(widget, event, value) Slippy:SetEnchant(value, group, i) end)
	end
	
	container:AddChild(GUItable[1][group][1])
	container:AddChild(GUItable[2][group][1])
	container:AddChild(GUItable[3][group][1])
	
	local button = AceGUI:Create("Button")
	button:SetText("Calcuate Prices")
	button:SetWidth(200)
	button:SetCallback("OnClick", function() Slippy:Calc(group) end)
	container:AddChild(button)
	
	for i=2,lines-1 do
		for k=1,3 do
			container:AddChild(GUItable[k][group][i])
		end
	end
	container:AddChild(GUItable[1][group][lines])
	container:AddChild(GUItable[2][group][lines])
end

-- initiallizes the widgets for tab2 of the general frame
function DrawGroup2(container) -- Boots
	group = 2
	local lines = 8

	for i=1,lines-1 do
	GUItable[1][group][i] = AceGUI:Create("CheckBox")
	GUItable[1][group][i]:SetType("checkbox")
	GUItable[1][group][i]:SetValue(boots[1][i])
	GUItable[1][group][i]:SetWidth(150)
	GUItable[1][group][i]:SetDescription(boots[0][i])
	GUItable[2][group][i] = AceGUI:Create("EditBox")
	GUItable[2][group][i]:SetWidth(60)
	GUItable[2][group][i]:SetDisabled(true)
	GUItable[2][group][i]:SetText(boots[12][i] .. "g")
	GUItable[3][group][i] = AceGUI:Create("Label")
	GUItable[3][group][i]:SetWidth(300)
	end
	
	GUItable[3][group][1]:SetWidth(100)
	GUItable[1][group][8] = AceGUI:Create("CheckBox")
	GUItable[1][group][8]:SetType("checkbox")
	GUItable[1][group][8]:SetValue(boots[1][8])
	GUItable[1][group][8]:SetWidth(150)
	GUItable[1][group][8]:SetDescription(boots[0][8])
	GUItable[2][group][8] = AceGUI:Create("EditBox")
	GUItable[2][group][8]:SetWidth(60)
	GUItable[2][group][8]:SetText(boots[12][8] .. "g")
	GUItable[2][group][8]:SetDisabled(true)
	
	for i=1,lines do
		GUItable[1][group][i]:SetCallback("OnValueChanged", function(widget, event, value) Slippy:SetEnchant(value, group, i) end)
	end
	
	container:AddChild(GUItable[1][group][1])
	container:AddChild(GUItable[2][group][1])
	container:AddChild(GUItable[3][group][1])
	
	local button = AceGUI:Create("Button")
	button:SetText("Calcuate Prices")
	button:SetWidth(200)
	button:SetCallback("OnClick", function() Slippy:Calc(2) end)
	container:AddChild(button)
	
	for i=2,lines-1 do
		for k=1,3 do
			container:AddChild(GUItable[k][group][i])
		end
	end
	container:AddChild(GUItable[1][group][8])
	container:AddChild(GUItable[2][group][8])
end

-- initiallizes the widgets for tab3 of the general frame
function DrawGroup3(container) -- Bracers
	group = 3
	local lines = 9

	for i=1,lines-1 do
		GUItable[1][group][i] = AceGUI:Create("CheckBox")
		GUItable[1][group][i]:SetType("checkbox")
		GUItable[1][group][i]:SetValue(bracers[1][i])
		GUItable[1][group][i]:SetWidth(150)
		GUItable[1][group][i]:SetDescription(bracers[0][i])
		GUItable[2][group][i] = AceGUI:Create("EditBox")
		GUItable[2][group][i]:SetWidth(60)
		GUItable[2][group][i]:SetDisabled(true)
		GUItable[2][group][i]:SetText(bracers[12][i] .. "g")
		GUItable[3][group][i] = AceGUI:Create("Label")
		GUItable[3][group][i]:SetWidth(300)
	end
	
	GUItable[3][group][1]:SetWidth(100)
	GUItable[1][group][lines] = AceGUI:Create("CheckBox")
	GUItable[1][group][lines]:SetType("checkbox")
	GUItable[1][group][lines]:SetValue(bracers[1][lines])
	GUItable[1][group][lines]:SetWidth(150)
	GUItable[1][group][lines]:SetDescription(bracers[0][lines])
	GUItable[2][group][lines] = AceGUI:Create("EditBox")
	GUItable[2][group][lines]:SetWidth(60)
	GUItable[2][group][lines]:SetText(bracers[12][lines] .. "g")
	GUItable[2][group][lines]:SetDisabled(true)
	
	for i=1,lines do
		GUItable[1][group][i]:SetCallback("OnValueChanged", function(widget, event, value) Slippy:SetEnchant(value, group, i) end)
	end
	
	container:AddChild(GUItable[1][group][1])
	container:AddChild(GUItable[2][group][1])
	container:AddChild(GUItable[3][group][1])
	
	local button = AceGUI:Create("Button")
	button:SetText("Calcuate Prices")
	button:SetWidth(200)
	button:SetCallback("OnClick", function() Slippy:Calc(group) end)
	container:AddChild(button)
	
	for i=2,lines-1 do
		for k=1,3 do
			container:AddChild(GUItable[k][group][i])
		end
	end
	container:AddChild(GUItable[1][group][lines])
	container:AddChild(GUItable[2][group][lines])
end

-- initiallizes the widgets for tab4 of the general frame
function DrawGroup4(container) -- Chest
	group = 4
	local lines = 8

	for i=1,lines-1 do
		GUItable[1][group][i] = AceGUI:Create("CheckBox")
		GUItable[1][group][i]:SetType("checkbox")
		GUItable[1][group][i]:SetValue(chest[1][i])
		GUItable[1][group][i]:SetWidth(150)
		GUItable[1][group][i]:SetDescription(chest[0][i])
		GUItable[2][group][i] = AceGUI:Create("EditBox")
		GUItable[2][group][i]:SetWidth(60)
		GUItable[2][group][i]:SetDisabled(true)
		GUItable[2][group][i]:SetText(chest[12][i] .. "g")
		GUItable[3][group][i] = AceGUI:Create("Label")
		GUItable[3][group][i]:SetWidth(300)
	end
	
	GUItable[3][group][1]:SetWidth(100)
	GUItable[1][group][lines] = AceGUI:Create("CheckBox")
	GUItable[1][group][lines]:SetType("checkbox")
	GUItable[1][group][lines]:SetValue(chest[1][lines])
	GUItable[1][group][lines]:SetWidth(150)
	GUItable[1][group][lines]:SetDescription(chest[0][lines])
	GUItable[2][group][lines] = AceGUI:Create("EditBox")
	GUItable[2][group][lines]:SetWidth(60)
	GUItable[2][group][lines]:SetText(chest[12][lines] .. "g")
	GUItable[2][group][lines]:SetDisabled(true)
	
	for i=1,lines do
		GUItable[1][group][i]:SetCallback("OnValueChanged", function(widget, event, value) Slippy:SetEnchant(value, group, i) end)
	end
	
	container:AddChild(GUItable[1][group][1])
	container:AddChild(GUItable[2][group][1])
	container:AddChild(GUItable[3][group][1])
	
	local button = AceGUI:Create("Button")
	button:SetText("Calcuate Prices")
	button:SetWidth(200)
	button:SetCallback("OnClick", function() Slippy:Calc(group) end)
	container:AddChild(button)
	
	for i=2,lines-1 do
		for k=1,3 do
			container:AddChild(GUItable[k][group][i])
		end
	end
	container:AddChild(GUItable[1][group][lines])
	container:AddChild(GUItable[2][group][lines])
end

-- initiallizes the widgets for tab5 of the general frame
function DrawGroup5(container) -- Cloak
	group = 5
	local lines = 9

	for i=1,lines-1 do
		GUItable[1][group][i] = AceGUI:Create("CheckBox")
		GUItable[1][group][i]:SetType("checkbox")
		GUItable[1][group][i]:SetValue(cloak[1][i])
		GUItable[1][group][i]:SetWidth(150)
		GUItable[1][group][i]:SetDescription(cloak[0][i])
		GUItable[2][group][i] = AceGUI:Create("EditBox")
		GUItable[2][group][i]:SetWidth(60)
		GUItable[2][group][i]:SetDisabled(true)
		GUItable[2][group][i]:SetText(cloak[12][i] .. "g")
		GUItable[3][group][i] = AceGUI:Create("Label")
		GUItable[3][group][i]:SetWidth(300)
	end
	
	GUItable[3][group][1]:SetWidth(100)
	GUItable[1][group][lines] = AceGUI:Create("CheckBox")
	GUItable[1][group][lines]:SetType("checkbox")
	GUItable[1][group][lines]:SetValue(cloak[1][lines])
	GUItable[1][group][lines]:SetWidth(150)
	GUItable[1][group][lines]:SetDescription(cloak[0][lines])
	GUItable[2][group][lines] = AceGUI:Create("EditBox")
	GUItable[2][group][lines]:SetWidth(60)
	GUItable[2][group][lines]:SetText(cloak[12][lines] .. "g")
	GUItable[2][group][lines]:SetDisabled(true)
	
	for i=1,lines do
		GUItable[1][group][i]:SetCallback("OnValueChanged", function(widget, event, value) Slippy:SetEnchant(value, group, i) end)
	end
	
	container:AddChild(GUItable[1][group][1])
	container:AddChild(GUItable[2][group][1])
	container:AddChild(GUItable[3][group][1])
	
	local button = AceGUI:Create("Button")
	button:SetText("Calcuate Prices")
	button:SetWidth(200)
	button:SetCallback("OnClick", function() Slippy:Calc(group) end)
	container:AddChild(button)
	
	for i=2,lines-1 do
		for k=1,3 do
			container:AddChild(GUItable[k][group][i])
		end
	end
	container:AddChild(GUItable[1][group][lines])
	container:AddChild(GUItable[2][group][lines])
end

-- initiallizes the widgets for tab6 of the general frame
function DrawGroup6(container) -- Gloves
	group = 6
	local lines = 7

	for i=1,lines-1 do
		GUItable[1][group][i] = AceGUI:Create("CheckBox")
		GUItable[1][group][i]:SetType("checkbox")
		GUItable[1][group][i]:SetValue(gloves[1][i])
		GUItable[1][group][i]:SetWidth(150)
		GUItable[1][group][i]:SetDescription(gloves[0][i])
		GUItable[2][group][i] = AceGUI:Create("EditBox")
		GUItable[2][group][i]:SetWidth(60)
		GUItable[2][group][i]:SetDisabled(true)
		GUItable[2][group][i]:SetText(gloves[12][i] .. "g")
		GUItable[3][group][i] = AceGUI:Create("Label")
		GUItable[3][group][i]:SetWidth(300)
	end
	
	GUItable[3][group][1]:SetWidth(100)
	GUItable[1][group][lines] = AceGUI:Create("CheckBox")
	GUItable[1][group][lines]:SetType("checkbox")
	GUItable[1][group][lines]:SetValue(gloves[1][lines])
	GUItable[1][group][lines]:SetWidth(150)
	GUItable[1][group][lines]:SetDescription(gloves[0][lines])
	GUItable[2][group][lines] = AceGUI:Create("EditBox")
	GUItable[2][group][lines]:SetWidth(60)
	GUItable[2][group][lines]:SetText(gloves[12][lines] .. "g")
	GUItable[2][group][lines]:SetDisabled(true)
	
	for i=1,lines do
		GUItable[1][group][i]:SetCallback("OnValueChanged", function(widget, event, value) Slippy:SetEnchant(value, group, i) end)
	end
	
	container:AddChild(GUItable[1][group][1])
	container:AddChild(GUItable[2][group][1])
	container:AddChild(GUItable[3][group][1])
	
	local button = AceGUI:Create("Button")
	button:SetText("Calcuate Prices")
	button:SetWidth(200)
	button:SetCallback("OnClick", function() Slippy:Calc(group) end)
	container:AddChild(button)
	
	for i=2,lines-1 do
		for k=1,3 do
			container:AddChild(GUItable[k][group][i])
		end
	end
	container:AddChild(GUItable[1][group][lines])
	container:AddChild(GUItable[2][group][lines])
end

-- initiallizes the widgets for tab7 of the general frame
function DrawGroup7(container) -- Shield
	group = 7
	local lines = 2

	for i=1,lines-1 do
		GUItable[1][group][i] = AceGUI:Create("CheckBox")
		GUItable[1][group][i]:SetType("checkbox")
		GUItable[1][group][i]:SetValue(shield[1][i])
		GUItable[1][group][i]:SetWidth(150)
		GUItable[1][group][i]:SetDescription(shield[0][i])
		GUItable[2][group][i] = AceGUI:Create("EditBox")
		GUItable[2][group][i]:SetWidth(60)
		GUItable[2][group][i]:SetDisabled(true)
		GUItable[2][group][i]:SetText(shield[12][i] .. "g")
		GUItable[3][group][i] = AceGUI:Create("Label")
		GUItable[3][group][i]:SetWidth(300)
	end
	
	GUItable[3][group][1]:SetWidth(100)
	GUItable[1][group][lines] = AceGUI:Create("CheckBox")
	GUItable[1][group][lines]:SetType("checkbox")
	GUItable[1][group][lines]:SetValue(shield[1][lines])
	GUItable[1][group][lines]:SetWidth(150)
	GUItable[1][group][lines]:SetDescription(shield[0][lines])
	GUItable[2][group][lines] = AceGUI:Create("EditBox")
	GUItable[2][group][lines]:SetWidth(60)
	GUItable[2][group][lines]:SetText(shield[12][lines] .. "g")
	GUItable[2][group][lines]:SetDisabled(true)
	
	for i=1,lines do
		GUItable[1][group][i]:SetCallback("OnValueChanged", function(widget, event, value) Slippy:SetEnchant(value, group, i) end)
	end
	
	container:AddChild(GUItable[1][group][1])
	container:AddChild(GUItable[2][group][1])
	container:AddChild(GUItable[3][group][1])
	
	local button = AceGUI:Create("Button")
	button:SetText("Calcuate Prices")
	button:SetWidth(200)
	button:SetCallback("OnClick", function() Slippy:Calc(group) end)
	container:AddChild(button)
	
	for i=2,lines-1 do
		for k=1,3 do
			container:AddChild(GUItable[k][group][i])
		end
	end
	container:AddChild(GUItable[1][group][lines])
	container:AddChild(GUItable[2][group][lines])
end

-- initiallizes the widgets for tab8 of the general frame
function DrawGroup8(container) -- Staff
	group = 8
	local lines = 2

	for i=1,lines-1 do
		GUItable[1][group][i] = AceGUI:Create("CheckBox")
		GUItable[1][group][i]:SetType("checkbox")
		GUItable[1][group][i]:SetValue(staff[1][i])
		GUItable[1][group][i]:SetWidth(150)
		GUItable[1][group][i]:SetDescription(staff[0][i])
		GUItable[2][group][i] = AceGUI:Create("EditBox")
		GUItable[2][group][i]:SetWidth(60)
		GUItable[2][group][i]:SetDisabled(true)
		GUItable[2][group][i]:SetText(staff[12][i] .. "g")
		GUItable[3][group][i] = AceGUI:Create("Label")
		GUItable[3][group][i]:SetWidth(300)
	end
	
	GUItable[3][group][1]:SetWidth(100)
	GUItable[1][group][lines] = AceGUI:Create("CheckBox")
	GUItable[1][group][lines]:SetType("checkbox")
	GUItable[1][group][lines]:SetValue(staff[1][lines])
	GUItable[1][group][lines]:SetWidth(150)
	GUItable[1][group][lines]:SetDescription(staff[0][lines])
	GUItable[2][group][lines] = AceGUI:Create("EditBox")
	GUItable[2][group][lines]:SetWidth(60)
	GUItable[2][group][lines]:SetText(staff[12][lines] .. "g")
	GUItable[2][group][lines]:SetDisabled(true)
	
	for i=1,lines do
		GUItable[1][group][i]:SetCallback("OnValueChanged", function(widget, event, value) Slippy:SetEnchant(value, group, i) end)
	end
	
	container:AddChild(GUItable[1][group][1])
	container:AddChild(GUItable[2][group][1])
	container:AddChild(GUItable[3][group][1])
	
	local button = AceGUI:Create("Button")
	button:SetText("Calcuate Prices")
	button:SetWidth(200)
	button:SetCallback("OnClick", function() Slippy:Calc(group) end)
	container:AddChild(button)
	
	for i=2,lines-1 do
		for k=1,3 do
			container:AddChild(GUItable[k][group][i])
		end
	end
	container:AddChild(GUItable[1][group][lines])
	container:AddChild(GUItable[2][group][lines])
end

-- initiallizes the widgets for tab9 of the general frame
function DrawGroup9(container) -- Weapon
	group = 9
	local lines = 9

	for i=1,lines-1 do
		GUItable[1][group][i] = AceGUI:Create("CheckBox")
		GUItable[1][group][i]:SetType("checkbox")
		GUItable[1][group][i]:SetValue(weapon[1][i])
		GUItable[1][group][i]:SetWidth(150)
		GUItable[1][group][i]:SetDescription(weapon[0][i])
		GUItable[2][group][i] = AceGUI:Create("EditBox")
		GUItable[2][group][i]:SetWidth(60)
		GUItable[2][group][i]:SetDisabled(true)
		GUItable[2][group][i]:SetText(weapon[12][i] .. "g")
		GUItable[3][group][i] = AceGUI:Create("Label")
		GUItable[3][group][i]:SetWidth(300)
	end
	
	GUItable[3][group][1]:SetWidth(100)
	GUItable[1][group][lines] = AceGUI:Create("CheckBox")
	GUItable[1][group][lines]:SetType("checkbox")
	GUItable[1][group][lines]:SetValue(weapon[1][lines])
	GUItable[1][group][lines]:SetWidth(150)
	GUItable[1][group][lines]:SetDescription(weapon[0][lines])
	GUItable[2][group][lines] = AceGUI:Create("EditBox")
	GUItable[2][group][lines]:SetWidth(60)
	GUItable[2][group][lines]:SetText(weapon[12][lines] .. "g")
	GUItable[2][group][lines]:SetDisabled(true)
	
	for i=1,lines do
		GUItable[1][group][i]:SetCallback("OnValueChanged", function(widget, event, value) Slippy:SetEnchant(value, group, i) end)
	end
	
	container:AddChild(GUItable[1][group][1])
	container:AddChild(GUItable[2][group][1])
	container:AddChild(GUItable[3][group][1])
	
	local button = AceGUI:Create("Button")
	button:SetText("Calcuate Prices")
	button:SetWidth(200)
	button:SetCallback("OnClick", function() Slippy:Calc(group) end)
	container:AddChild(button)
	
	for i=2,lines-1 do
		for k=1,3 do
			container:AddChild(GUItable[k][group][i])
		end
	end
	container:AddChild(GUItable[1][group][lines])
	container:AddChild(GUItable[2][group][lines])
end

-- initiallizes and activates the widgets for tab1 of the summary frame
function DrawGroup21(container) -- Material totals
	text1 = AceGUI:Create("Label")
	text1:SetText("Infinite Dusts: " .. db.profile.totals[1] .. "\n")
	container:AddChild(text1)
	
	text2 = AceGUI:Create("Label")
	text2:SetText("Greater Cosmic Essences: " .. db.profile.totals[2] .. "\n")
	container:AddChild(text2)
	
	text3 = AceGUI:Create("Label")
	text3:SetText("Lesser Cosmic Essences: " .. db.profile.totals[3] .. "\n")
	container:AddChild(text3)
	
	text4 = AceGUI:Create("Label")
	text4:SetText("Dream Shards: " .. db.profile.totals[4] .. "\n")
	container:AddChild(text4)
	
	text5 = AceGUI:Create("Label")
	text5:SetText("Abyss Crystals: " .. db.profile.totals[5] .. "\n")
	container:AddChild(text5)
	
	text6 = AceGUI:Create("Label")
	text6:SetText("Titanium Bars: " .. db.profile.totals[6] .. "\n")
	container:AddChild(text6)
	
	text7 = AceGUI:Create("Label")
	text7:SetText("Crystallized Waters: " .. db.profile.totals[7] .. "\n")
	container:AddChild(text7)
	
	text8 = AceGUI:Create("Label")
	text8:SetText("Eternal Earths: " .. db.profile.totals[8] .. "\n")
	container:AddChild(text8)
	
	text9 = AceGUI:Create("Label")
	text9:SetText("Eternal Airs: " .. db.profile.totals[9] .. "\n")
	container:AddChild(text9)
	
	text10 = AceGUI:Create("Label")
	text10:SetText("Titansteel Bars: " .. db.profile.totals[10] .. "\n")
	container:AddChild(text10)
		
	
	text11 = AceGUI:Create("Label")
	container:AddChild(text11)
	
	text12 = AceGUI:Create("Label")
	container:AddChild(text12)
	
	if db.profile.vellum then
		text11:SetText("Weapon Vellums: " .. db.profile.totals[11] .. "\n")
		text12:SetText("Armor Vellums: " .. db.profile.totals[12] .. "\n")
	else
		text11:SetText("")
		text12:SetText("")
	end
end

-- initiallizes the widgets for tab2 of the summary frame
function DrawGroup22(container)	
	for i=0, db.profile.totals[13] do
		queue[i] = AceGUI:Create("Label")
		container:AddChild(queue[i])
	end
	
	local f = 1
	
	-- checks to see if each enchant is Q'd to be crafted and adds it to the queue list if it is
	if db.profile.totals[13] > 0 then
		for k=1, 8 do
			if boots[1][k] then
				queue[f]:SetText("Enchant Boots - " .. boots[0][k])
				print("Enchant Boots - " .. boots[0][k])
				f = f + 1
			end
		end
		
		for k=1, 8 do
			if chest[1][k] then
				queue[f]:SetText("Enchant Chest - " .. chest[0][k])
				print("Enchant Chest - " .. chest[0][k])
				f = f + 1
			end
		end
		
		for k=1, 9 do
			if bracers[1][k] then
				queue[f]:SetText("Enchant Bracers - " .. bracers[0][k])
				print("Enchant Bracers - " .. bracers[0][k])
				f = f + 1
			end
		end
		
		for k=1, 9 do
			if cloak[1][k] then
				queue[f]:SetText("Enchant Cloak - " .. cloak[0][k])
				print("Enchant Cloak - " .. cloak[0][k])
				f = f + 1
			end
		end
		
		for k=1, 9 do
			if weapon[1][k] then
				queue[f]:SetText("Enchant Weapon - " .. weapon[0][k])
				print("Enchant Weapon - " .. weapon[0][k])
				f = f + 1
			end
		end
		
		for k=1, 2 do
			if staff[1][k] then
				queue[f]:SetText("Enchant Staff - " .. staff[0][k])
				print("Enchant Staff - " .. staff[0][k])
				f = f + 1
			end
		end
		
		for k=1, 2 do
			if shield[1][k] then
				queue[f]:SetText("Enchant Shield - " .. shield[0][k])
				print("Enchant Shield - " .. shield[0][k])
				f = f + 1
			end
		end
		
		for k=1, 2 do
			if twoH[1][k] then
				queue[f]:SetText("Enchant 2H Weapon - " .. twoH[0][k])
				print("Enchant 2H Weapon - " .. twoH[0][k])
				f = f + 1
			end
		end
		
		for k=1, 7 do
			if gloves[1][k] then
				queue[f]:SetText("Enchant Gloves - " .. gloves[0][k])
				print("Enchant Gloves - " .. gloves[0][k])
				f = f + 1
			end
		end
	else
		queue[0]:SetText("You currently have no enchants in the queue.")
	end
	
	-- creates the "Reset Craft Queue" button
	local button = AceGUI:Create("Button")
	button:SetText("Reset Craft Queue")
	button:SetWidth(200)
	button:SetCallback("OnClick", function() Slippy:ResetData() end)
	container:AddChild(button)
end

-- function for handling the user changing tabs in the general frame
function SelectGroup(container, event, group)
	container:ReleaseChildren()
	if group == "tab1" then
		DrawGroup1(container)
	elseif group == "tab2" then
		DrawGroup2(container)
	elseif group == "tab3" then
		DrawGroup3(container)
	elseif group == "tab4" then
		DrawGroup4(container)
	elseif group == "tab5" then
		DrawGroup5(container)
	elseif group == "tab6" then
		DrawGroup6(container)
	elseif group == "tab7" then
		DrawGroup7(container)
	elseif group == "tab8" then
		DrawGroup8(container)
	elseif group == "tab9" then
		DrawGroup9(container)
	end
end

-- function for handling the user changing tabs in the summary frame
function SelectGroup2(container, event, group)
	container:ReleaseChildren()
	if group == "tab21" then
		DrawGroup21(container)
	elseif group == "tab22" then
		DrawGroup22(container)
	end
end

-- Create frame 1 for selecting enchants / viewing costs
frame = AceGUI:Create("Frame")
frame:SetTitle("Slippy v" .. Slippyversion)
frame:SetLayout("Fill")

-- Create frame 2 for viewing the total materials needed / craft queue
frame2 = AceGUI:Create("Frame")
frame2:SetTitle("Slippy v" .. Slippyversion)
frame2:SetLayout("Fill")

-- Create the TabGroup for 'frame'
tab =  AceGUI:Create("TabGroup")
tab:SetLayout("Flow")
tab:SetTabs({{text="2H Weapon", value="tab1"}, {text="Boots", value="tab2"}, {text="Bracers", value="tab3"},
			{text="Chest", value="tab4"}, {text="Cloak", value="tab5"}, {text="Gloves", value="tab6"},
			{text="Shield", value="tab7"}, {text="Staff", value="tab8"}, {text="Weapon", value="tab9"}})
tab:SetCallback("OnGroupSelected", SelectGroup)
tab:SelectTab("tab1")
frame:AddChild(tab)

-- Create the TabGroup for 'frame2'
tab2 =  AceGUI:Create("TabGroup")
tab2:SetLayout("List")
tab2:SetTabs({{text="Material totals", value="tab21"}, {text="Craft Queue", value="tab22"}})
tab2:SetCallback("OnGroupSelected", SelectGroup2)
tab2:SelectTab("tab21")
frame2:AddChild(tab2)

-- Whenver a button is pressed in the general window, the respective number of that tab
-- and the enchant slot is sent here and then the correct calcuate function is called.
function Slippy:Calc(num)
	if num == 1 then Slippy:CalcTwoH()
	elseif num == 2 then Slippy:CalcBoots()
	elseif num == 3 then Slippy:CalcBracers()
	elseif num == 4 then Slippy:CalcChest()
	elseif num == 5 then Slippy:CalcCloak()
	elseif num == 6 then Slippy:CalcGloves()
	elseif num == 7 then Slippy:CalcShield()
	elseif num == 8 then Slippy:CalcStaff()
	elseif num == 9 then Slippy:CalcWeapon()
	else print("Error: gui.lua~Calc could not determine slot.") end
end