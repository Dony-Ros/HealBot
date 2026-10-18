--====================================================
-- HealBot Slash Commands
--====================================================

local function ToggleActionPanel()
    HealBot_TogglePanel(HealBot_Action)
end

local function ToggleOptionsPanel()
    HealBot_TogglePanel(HealBot_Options)
end

local function HardReload()
    HealBot_AddChat(HEALBOT_CHAT_ADDONID .. HEALBOT_CHAT_HARDRELOAD)
    HealBot_SetResetFlag("HARD")
end

local function SoftReload()
    HealBot_AddChat(HEALBOT_CHAT_ADDONID .. HEALBOT_CHAT_SOFTRELOAD)
    HealBot_SetResetFlag("SOFT")
end

local function ResetCustomDebuffs()
    HealBot_Reset_flag = 2
end

local function ResetSkins()
    HealBot_Reset_flag = 3
end

local function ShowInfo()
    HealBot_Comms_Info()
end

local function EnableHealBot()
    HealBot_Options_DisableHealBot:SetChecked(0)
    HealBot_Options_ToggleHealBot(0)
    HealBot_AddChat(HEALBOT_CHAT_ADDONID .. HEALBOT_CHAT_ENABLED)
end

local function DisableHealBot()
    HealBot_Options_DisableHealBot:SetChecked(1)
    HealBot_Options_ToggleHealBot(1)
    HealBot_AddChat(HEALBOT_CHAT_ADDONID .. HEALBOT_CHAT_DISABLED)
end

local function ToggleUse10()
    HealBot_Config.MacroUse10 = HealBot_Config.MacroUse10 == 1 and 0 or 1
    HealBot_AddChat(
        HEALBOT_CHAT_ADDONID ..
        (HealBot_Config.MacroUse10 == 1 and HEALBOT_CHAT_USE10ON or HEALBOT_CHAT_USE10OFF)
    )
end

local function ToggleBuffWatch()
    HealBot_Config.BuffWatch = HealBot_Config.BuffWatch == 1 and 0 or 1
    HealBot_Options_MonitorBuffs:SetChecked(HealBot_Config.BuffWatch)
    HealBot_Options_MonitorBuffs_Toggle()
end

local function ToggleDebuffWatch()
    HealBot_Config.DebuffWatch = HealBot_Config.DebuffWatch == 1 and 0 or 1
    HealBot_Options_MonitorDebuffs:SetChecked(HealBot_Config.DebuffWatch)
    HealBot_Options_MonitorDebuffs_Toggle()
end

local function ToggleWeakenedSoul()
    HealBot_Config.ShowWSicon = HealBot_Config.ShowWSicon == 1 and 0 or 1
    HealBot_AddChat(
        HEALBOT_CHAT_ADDONID ..
        HEALBOT_DEBUFF_WEAKENED_SOUL ..
        " - " ..
        (HealBot_Config.ShowWSicon == 1 and HEALBOT_WORD_ON or HEALBOT_WORD_OFF)
    )
end

--====================================================
-- Command Map
--====================================================

local CommandHandlers = {

    [""]          = ToggleActionPanel,
    ["o"]         = ToggleOptionsPanel,
    ["options"]   = ToggleOptionsPanel,
    ["opt"]       = ToggleOptionsPanel,
    ["config"]    = ToggleOptionsPanel,
    ["cfg"]       = ToggleOptionsPanel,

    ["ui"]        = HardReload,
    ["ri"]        = SoftReload,

    ["rc"]        = ResetCustomDebuffs,
    ["rs"]        = ResetSkins,

    ["info"]      = ShowInfo,
    ["ver"]       = ShowInfo,
    ["status"]    = ShowInfo,

    ["enable"]    = EnableHealBot,
    ["disable"]   = DisableHealBot,

    ["use10"]     = ToggleUse10,

    ["bt"]        = ToggleBuffWatch,
    ["dt"]        = ToggleDebuffWatch,
    ["ws"]        = ToggleWeakenedSoul,
}

--====================================================
-- Entry Point
--====================================================

function HealBot_SlashCmd(msg)
    local cmd, a, b, c = string.split(" ", msg or "")
    cmd = string.lower(cmd or "")

    local handler = CommandHandlers[cmd]
    if handler then
        handler(a, b, c)
    else
        HealBot_AddChat(HEALBOT_CHAT_ADDONID .. HEALBOT_CHAT_UNKNOWNCMD .. (msg or ""))
    end
end
