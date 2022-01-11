local sscConsumables = {
    ["hp"] = 32904, -- Cenarion Healing Salve
    ["mana"] = 32903 -- Cenarion Mana Salve
};

local tkConsumables = {
    ["hp"] = 32905, -- Super Healing Potion
    ["mana"] = 32902 -- Super Mana Potion
};

local defaultConsumables = {
    ["hp"] = 22829, -- Super Healing Potion
    ["mana"] = 22832 -- Super Mana Potion
}

local consumablesByZone = {
    ["Blade's Edge Mountains"] = {
        ["hp"] = 32910, -- Red Ogre Brew Special
        ["mana"] = 32909 -- Blue Ogre Brew Special
    },
    ["Serpentshrine Cavern"] = sscConsumables,
    ["The Slave Pens"] = sscConsumables,
    ["The Underbog"] = sscConsumables,
    ["The Steamvault"] = sscConsumables,
    ["Tempest Keep"] = tkConsumables,
    ["The Botanica"] = tkConsumables,
    ["The Mechanar"] = tkConsumables,
    ["The Arcatraz"] = tkConsumables,
    ["default"] = defaultConsumables
};

local function InitMacros()
    if (GetMacroBody("AutoConsHP") == nil) then
        CreateMacro("AutoConsHP", "INV_MISC_QUESTIONMARK", "")
    end

    if (GetMacroBody("AutoConsMana") == nil) then
        CreateMacro("AutoConsMana", "INV_MISC_QUESTIONMARK", "")
    end

    if (GetMacroBody("AutoConsHS") == nil) then
        CreateMacro("AutoConsHS", "INV_MISC_QUESTIONMARK", "")
    end

    if (GetMacroBody("AutoConsFood") == nil) then
        CreateMacro("AutoConsFood", "INV_MISC_QUESTIONMARK", "")
    end

    if (GetMacroBody("AutoConsWater") == nil) then
        CreateMacro("AutoConsWater", "INV_MISC_QUESTIONMARK", "")
    end
end

local function UpdatePotionMacros(zone)
    local consumablesForZone = consumablesByZone[zone] or consumablesByZone["default"]

    local hpCount = GetItemCount(consumablesForZone["hp"])
    local manaCount = GetItemCount(consumablesForZone["mana"])

    local hpId = hpCount > 0 and consumablesForZone["hp"] or defaultConsumables["hp"]
    local manaId = manaCount > 0 and consumablesForZone["mana"] or defaultConsumables["mana"]

    EditMacro("AutoConsHP", nil, nil, "#showtooltip\n/cast item:" .. hpId)
    EditMacro("AutoConsMana", nil, nil, "#showtooltip\n/cast item:" .. manaId)

end

local largeHsId = 22105
local mediumHsId = 22104
local smallHsId = 22103

local function UpdateHealthstoneMacro()
    local largeCount = GetItemCount(largeHsId)
    local mediumCount = GetItemCount(mediumHsId)
    local smallCount = GetItemCount(smallHsId)

    local hsId = largeCount > 0 and largeHsId or mediumCount > 0 and mediumHsId or smallCount > 0 and smallHsId

    if hsId then
        EditMacro("AutoConsHS", nil, nil, "#showtooltip item:" .. hsId .. "\n/cast item:" .. largeHsId .. "\n/cast item:" .. mediumHsId .. "\n/cast item:" .. smallHsId)
    end
end

local function UpdateFoodMacros()
    local conjuredCount = GetItemCount(34062)

    local foodId = conjuredCount > 0 and 34062 or 29448
    local waterId = conjuredCount > 0 and 34062 or 27860

    EditMacro("AutoConsFood", nil, nil, "#showtooltip\n/cast item:" .. foodId)
    EditMacro("AutoConsWater", nil, nil, "#showtooltip\n/cast item:" .. waterId)
end

-- TODO spell power food

AutoConsumableMacros = AutoConsumableMacros or {}
AutoConsumableMacros.frame = CreateFrame("Frame", "AutoConsumableMacros", UIParent)
AutoConsumableMacros.frame:SetFrameStrata("BACKGROUND")

AutoConsumableMacros.frame:RegisterEvent("PLAYER_LOGIN")
AutoConsumableMacros.frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
-- AutoConsumableMacros.frame:RegisterEvent("PLAYER_LEAVE_COMBAT")
AutoConsumableMacros.frame:RegisterEvent("UNIT_INVENTORY_CHANGED")

AutoConsumableMacros.frame:SetScript("OnEvent", function(self, event, ...)
    if (event == "PLAYER_LOGIN") then
        InitMacros()
    end

    if (event == "PLAYER_LOGIN" or event == "ZONE_CHANGED_NEW_AREA" or event == "UNIT_INVENTORY_CHANGED") then
        local zone = GetZoneText()

        UpdatePotionMacros(zone)
        UpdateFoodMacros()
    end

    if (event == "PLAYER_LOGIN" or event == "UNIT_INVENTORY_CHANGED") then
        UpdateHealthstoneMacro()
        UpdateFoodMacros()
    end
end)

print("AutoConsumableMacros loaded")
