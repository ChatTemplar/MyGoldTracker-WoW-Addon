local MyGoldTracker = {}
MyGoldTrackerDB = MyGoldTrackerDB or {}

local function OnEvent(self, event, ...)
    if event == "PLAYER_LOGIN" then
        if not MyGoldTrackerDB.sessions then
            MyGoldTrackerDB.sessions = {}
        end
        MyGoldTracker.currentSession = { startGold = GetMoney(), goldGained = 0, goldLost = 0 }
    elseif event == "PLAYER_MONEY" then
        local currentGold = GetMoney()
        local goldChange = currentGold - MyGoldTracker.currentSession.startGold

        if goldChange > 0 then
            MyGoldTracker.currentSession.goldGained = MyGoldTracker.currentSession.goldGained + goldChange
        else
            MyGoldTracker.currentSession.goldLost = MyGoldTracker.currentSession.goldLost + math.abs(goldChange)
        end

        MyGoldTracker.currentSession.startGold = currentGold
        MyGoldTracker_UpdateUI()
    elseif event == "PLAYER_LOGOUT" then
        table.insert(MyGoldTrackerDB.sessions, MyGoldTracker.currentSession)
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_MONEY")
frame:RegisterEvent("PLAYER_LOGOUT")
frame:SetScript("OnEvent", OnEvent)

local displayFrame = CreateFrame("Frame", "MyGoldTrackerFrame", UIParent)
displayFrame:SetSize(200, 100)
displayFrame:SetPoint("TOPLEFT", 10, -10)

local goldGainedText = displayFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
goldGainedText:SetPoint("TOPLEFT", 0, 0)
goldGainedText:SetText("Gold Gained: 0")

local goldLostText = displayFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
goldLostText:SetPoint("TOPLEFT", 0, -20)
goldLostText:SetText("Gold Lost: 0")

function MyGoldTracker_UpdateUI()
    local goldGained = MyGoldTracker.currentSession.goldGained
    local goldLost = MyGoldTracker.currentSession.goldLost

    goldGainedText:SetText("Gold Gained: " .. GetCoinTextureString(goldGained))
    goldLostText:SetText("Gold Lost: " .. GetCoinTextureString(goldLost))
end