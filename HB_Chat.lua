
function HealBot_AddChat(HBmsg)
    x = HealBot_Comms_GetChan("HBmsg");
    if x and HealBot_SpamCnt < 24 then
        HealBot_SpamCnt = HealBot_SpamCnt + 1;
        HBmsg = "[" .. date("%H:%M", time()) .. "] " .. HBmsg;
        SendChatMessage(HBmsg, "CHANNEL", nil, x);
    elseif (DEFAULT_CHAT_FRAME) then
        DEFAULT_CHAT_FRAME:AddMessage(HBmsg, 0.7, 0.7, 1.0);
    end
end
function HealBot_AddDebug(HBmsg)
    x = HealBot_Comms_GetChan("HBmsg");
    if x and HealBot_SpamCnt < 17 then
        HealBot_SpamCnt = HealBot_SpamCnt + 1;
        HBmsg = "[" .. date("%H:%M", time()) .. "] DEBUG: " .. HBmsg;
        SendChatMessage(HBmsg, "CHANNEL", nil, x);
    end
end

function HealBot_AddError(HBmsg)
    UIErrorsFrame:AddMessage(HBmsg, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
    HealBot_AddDebug(HBmsg);
end

function HealBot_ResetChatSpam()
    spamCount = 0
    spamTimer = 0
end
