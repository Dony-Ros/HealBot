local Healbot_MyPrivateHeals = {}

function HealBot_Panel_RetPrivateHeals(unit)
    return Healbot_MyPrivateHeals[unit]
end
function Healbot_SetRole_Icon(hbGUID,icon)
    if not HealBot_UnitID[hbGUID] then return end
    xUnit = HealBot_UnitID[hbGUID]
    if not xUnit or not HealBot_Unit_Button[xUnit] or not UnitExists(xUnit) then return end
    local xbar = HealBot_Action_HealthBar(HealBot_Unit_Button[xUnit]);
    if xbar then
        iconName = _G[xbar:GetName() .. "Icon17"];
        iconName:SetTexture(icon)
    end
end
function HealBot_Panel_ToggelPrivateHealer(unit)
    local hbGUID = HealBot_UnitGUID(unit)

    if not Healbot_MyPrivateHeals[unit] then
        Healbot_MyPrivateHeals[unit] = hbGUID

        Healbot_SetRole_Icon(hbGUID,Healbot_Role_Icons["HEALER"])

    else
        Healbot_MyPrivateHeals[unit] = nil
        Healbot_SetRole_Icon(hbGUID,nil)
    end
   
    if Delay_RecalcParty < 2 then
        Delay_RecalcParty = 2
    end

end