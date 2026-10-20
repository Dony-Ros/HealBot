local Spell_NameEditBox
local indexEE = 0
local ScrollViewContent = nil
local ShowSpellOnHud_CheckBox
local CanRess = false
local ShowOnHUD = false
local CurrentSpellType = 1 -- 1=Spell, 2=Dispell, 3=Buff

local SpellTypeNames = { "Spell", "Dispell", "Buff" }

local function SetTypeDisplay(typeId)
    local dd = _G["HealBot_Options_SpellManager_TypeDropDown"]
    if dd then
        _G[dd:GetName() .. "Text"]:SetText(SpellTypeNames[typeId] or "")
    end
end

function HealBot_Options_SpellManager_TypeDropDown_OnLoad(self)
    UIDropDownMenu_Initialize(self, function(frame, level)
        for id, text in ipairs(SpellTypeNames) do
            local info = {}
            info.text = text
            info.checked = (CurrentSpellType == id)
            info.func = function() HealBot_Options_SpellManager_SelectType(id) end
            UIDropDownMenu_AddButton(info, level)
        end
    end)
    UIDropDownMenu_SetWidth(self, 200)
    SetTypeDisplay(CurrentSpellType)
end

function HealBot_Options_ManageSpells(self)
    if _G["HealBot_Options_SpellManager"] then
        _G["HealBot_Options_SpellManager"]:Show()
    end
end

function HealBot_Options_SpellManager_OnShow()
    -- Reset the selected type to Spell when showing
    CurrentSpellType = 1
    SetTypeDisplay(1)
    HealBot_Options_SpellManager_UpdateOptionsVisibility(1)
end

function HealBot_Options_SpellManager_UpdateOptionsVisibility(spellType)
    if spellType == 1 then -- Spell
        _G["HealBot_Options_SpellManager_CanResurect"]:Show()
        _G["Healbot_Options_SpellManager_Dispells_F"]:Hide()
        ShowSpellOnHud_CheckBox:Show()
    elseif spellType == 2 then -- Dispell
        _G["Healbot_Options_SpellManager_Dispells_F"]:Show()
        _G["HealBot_Options_SpellManager_CanResurect"]:Hide()
        ShowSpellOnHud_CheckBox:Hide()
    elseif spellType == 3 then -- Buff
        _G["HealBot_Options_SpellManager_CanResurect"]:Hide()
        _G["Healbot_Options_SpellManager_Dispells_F"]:Hide()
        ShowSpellOnHud_CheckBox:Hide()
    else
        _G["Healbot_Options_SpellManager_Dispells_F"]:Hide()
        _G["HealBot_Options_SpellManager_CanResurect"]:Hide()
        ShowSpellOnHud_CheckBox:Hide()
    end
end

function HealBot_Options_SpellManager_SelectType(typeId)
    CurrentSpellType = typeId
    SetTypeDisplay(typeId)
    HealBot_Options_SpellManager_UpdateOptionsVisibility(typeId)
end

function HealBot_Options_SpellManager_RightPanel_OnLoad(self)
    -- Initialize any right panel specific settings
end

function HealBot_Options_SpellManager_NewSpell()
    -- Clear all fields for a new spell
    Spell_NameEditBox:SetText("")
    
    CurrentSpellType = 1
    SetTypeDisplay(1)
    HealBot_Options_SpellManager_UpdateOptionsVisibility(1)
    
    -- Reset checkboxes
    _G["HealBot_Options_SpellManager_CanResurect"]:SetChecked(false)
    ShowSpellOnHud_CheckBox:SetChecked(false)
    
    -- Reset dispell checkboxes
    _G["HealBot_Options_SpellManager_Dispell_Poison"]:SetChecked(false)
    _G["HealBot_Options_SpellManager_Dispell_Curse"]:SetChecked(false)
    _G["HealBot_Options_SpellManager_Dispell_Magic"]:SetChecked(false)
    _G["HealBot_Options_SpellManager_Dispell_Disese"]:SetChecked(false)
    _G["HealBot_Options_SpellManager_Dispell_Bleed"]:SetChecked(false)
    
    -- Reset variables
    CanRess = false
    ShowOnHUD = false
end

function HealBot_Options_SpellManager_DeleteSpell()
    local spellName = tonumber(Spell_NameEditBox:GetText())
    if not spellName then
        print("No spell selected to delete")
        return
    end
    
    if Healbot_Custom_SpellManager and Healbot_Custom_SpellManager[spellName] then
        -- Remove the button from the scroll frame
        if Healbot_Custom_SpellManager[spellName].Button then
            Healbot_Custom_SpellManager[spellName].Button:Hide()
            Healbot_Custom_SpellManager[spellName].Button = nil
        end
        
        -- Remove from the table
        Healbot_Custom_SpellManager[spellName] = nil
        
        -- Clear the edit fields
        Spell_NameEditBox:SetText("")
        
        print("Spell deleted: " .. spellName)
    else
        print("Spell not found: " .. spellName)
    end
end

local function CreateCustomSpellButton(SpellTable, content)
    local button = CreateFrame("Button", nil, content)
    button:SetPoint("TOP", content, "TOP", 0, indexEE)
    button:SetSize(200, 25)
    button:SetText(SpellTable.Spell)
    button:SetNormalFontObject("GameFontNormal")

    local ntex = button:CreateTexture()
    ntex:SetTexture("Interface/Buttons/UI-Panel-Button-Up")
    ntex:SetTexCoord(0, 0.625, 0, 0.6875)
    ntex:SetAllPoints()
    button:SetNormalTexture(ntex)

    local htex = button:CreateTexture()
    htex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
    htex:SetTexCoord(0, 0.625, 0, 0.6875)
    htex:SetAllPoints()
    button:SetHighlightTexture(htex)

    local ptex = button:CreateTexture()
    ptex:SetTexture("Interface/Buttons/UI-Panel-Button-Down")
    ptex:SetTexCoord(0, 0.625, 0, 0.6875)
    ptex:SetAllPoints()
    button:SetPushedTexture(ptex)

    indexEE = indexEE - 30

    button:HookScript("OnClick", function()
        healbot_options_ManageSpells_SelectSpell(SpellTable)
    end)

    SpellTable.Button = button
end

function healbot_options_ManageSpells_SelectSpell(SpellTable)
    -- Update the selected type
    CurrentSpellType = SpellTable.SpellType
    SetTypeDisplay(CurrentSpellType)
    HealBot_Options_SpellManager_UpdateOptionsVisibility(CurrentSpellType)

    Spell_NameEditBox:SetText(SpellTable.SpellID or "")
    
    if SpellTable.SpellType == 2 then -- Dispell
        _G["HealBot_Options_SpellManager_Dispell_Poison"]:SetChecked(SpellTable.Dispell_Poison or false)
        _G["HealBot_Options_SpellManager_Dispell_Curse"]:SetChecked(SpellTable.Dispell_Curse or false)
        _G["HealBot_Options_SpellManager_Dispell_Magic"]:SetChecked(SpellTable.Dispell_Magic or false)
        _G["HealBot_Options_SpellManager_Dispell_Disese"]:SetChecked(SpellTable.Dispell_Disese or false)
        _G["HealBot_Options_SpellManager_Dispell_Bleed"]:SetChecked(SpellTable.Dispell_Bleed or false)
    elseif SpellTable.SpellType == 1 then -- Spell
        CanRess = SpellTable.CanResurect or false
        _G["HealBot_Options_SpellManager_CanResurect"]:SetChecked(CanRess)
        if not CanRess then
            ShowSpellOnHud_CheckBox:Show()
            ShowSpellOnHud_CheckBox:SetChecked(SpellTable.ShowOnHUD or false)
            ShowOnHUD = SpellTable.ShowOnHUD or false
        else
            ShowSpellOnHud_CheckBox:Hide()
        end
    end
end

function HealBot_Options_SpellManager_CreateOrSaveSpell()
    local spellName = tonumber(Spell_NameEditBox:GetText())
    if not spellName then
        print("Please enter a spell ID")
        return
    end
    
    local spellinf = GetSpellInfo(spellName)
    if not spellinf then
        print("Invalid Spell ID: " .. spellName)
        return
    end
    
    if not Healbot_Custom_SpellManager then
        Healbot_Custom_SpellManager = {}
    end
    
    local isNew = not Healbot_Custom_SpellManager[spellName]
    
    if isNew then
        Healbot_Custom_SpellManager[spellName] = {}
        Healbot_Custom_SpellManager[spellName].Spell = spellinf
        Healbot_Custom_SpellManager[spellName].SpellID = spellName
        CreateCustomSpellButton(Healbot_Custom_SpellManager[spellName], ScrollViewContent)
    end

    -- Store the spell type
    Healbot_Custom_SpellManager[spellName].SpellType = CurrentSpellType
    
    if CurrentSpellType == 1 then -- Spell
        CanRess = _G["HealBot_Options_SpellManager_CanResurect"]:GetChecked()
        Healbot_Custom_SpellManager[spellName].CanResurect = CanRess
        Healbot_Custom_SpellManager[spellName].ShowOnHUD = ShowOnHUD  -- Make sure this is saved
        
        -- Clear dispell settings if they exist from previous saves
        Healbot_Custom_SpellManager[spellName].Dispell_Poison = nil
        Healbot_Custom_SpellManager[spellName].Dispell_Curse = nil
        Healbot_Custom_SpellManager[spellName].Dispell_Disese = nil
        Healbot_Custom_SpellManager[spellName].Dispell_Magic = nil
        Healbot_Custom_SpellManager[spellName].Dispell_Bleed = nil
        
    elseif CurrentSpellType == 2 then -- Dispell
        Healbot_Custom_SpellManager[spellName].Dispell_Poison = _G["HealBot_Options_SpellManager_Dispell_Poison"]:GetChecked()
        Healbot_Custom_SpellManager[spellName].Dispell_Curse = _G["HealBot_Options_SpellManager_Dispell_Curse"]:GetChecked()
        Healbot_Custom_SpellManager[spellName].Dispell_Disese = _G["HealBot_Options_SpellManager_Dispell_Disese"]:GetChecked()
        Healbot_Custom_SpellManager[spellName].Dispell_Magic = _G["HealBot_Options_SpellManager_Dispell_Magic"]:GetChecked()
        Healbot_Custom_SpellManager[spellName].Dispell_Bleed = _G["HealBot_Options_SpellManager_Dispell_Bleed"]:GetChecked()
        
        -- Clear spell-specific settings
        Healbot_Custom_SpellManager[spellName].CanResurect = nil
        Healbot_Custom_SpellManager[spellName].ShowOnHUD = nil
        
    elseif CurrentSpellType == 3 then -- Buff
        -- Clear all special settings for buffs
        Healbot_Custom_SpellManager[spellName].CanResurect = nil
        Healbot_Custom_SpellManager[spellName].ShowOnHUD = nil
        Healbot_Custom_SpellManager[spellName].Dispell_Poison = nil
        Healbot_Custom_SpellManager[spellName].Dispell_Curse = nil
        Healbot_Custom_SpellManager[spellName].Dispell_Disese = nil
        Healbot_Custom_SpellManager[spellName].Dispell_Magic = nil
        Healbot_Custom_SpellManager[spellName].Dispell_Bleed = nil
        
    end

    -- Call AddNewSpell to register with the HealBot system
    Healbot_Options_SpellManager_AddNewSpell(Healbot_Custom_SpellManager[spellName])
    print("Spell saved: " .. spellinf .. " (" .. spellName .. ")")
end

function HealBot_Options_ManageSpells_ScrollFrame_OnSpellsLoad(self)
    -- Get the scroll child frame
    local scrollChild = self:GetScrollChild()
    if scrollChild then
        ScrollViewContent = scrollChild
    else
        ScrollViewContent = self
    end
    
    ShowSpellOnHud_CheckBox = _G["HealBot_Options_SpellManager_ShowOnHUD"]
    Spell_NameEditBox = _G["HealBot_Options_SpellManager_SpellName"]

    if Healbot_Options_SpellManager_LoadCustomSpells then
        Healbot_Options_SpellManager_LoadCustomSpells()
    end

    indexEE = 0
    if Healbot_Custom_SpellManager then
        for key, value in pairs(Healbot_Custom_SpellManager) do
            CreateCustomSpellButton(value, ScrollViewContent)
        end
    end
    
    -- Set initial visibility
    HealBot_Options_SpellManager_UpdateOptionsVisibility(1)
end

function Healbot_Options_SpellManager_CanResurect_Click(self)
    CanRess = self:GetChecked()
    if CanRess then
        ShowSpellOnHud_CheckBox:Hide()
        ShowOnHUD = false
    else
        ShowSpellOnHud_CheckBox:Show()
    end
end

function Healbot_Options_SpellManager_ShowOnHUD_Click(self)
    ShowOnHUD = self:GetChecked()
end