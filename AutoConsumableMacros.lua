local consumablesByZone = {
    ["Blade's Edge Mountains"] = {
        ["hp"] = 32910, -- Red Ogre Brew Special
        ["mana"] = 32909 -- Blue Ogre Brew Special
    },
    ["Serpentshrine Cavern"] = {
        ["hp"] = 32904, -- Cenarion Healing Salve
        ["mana"] = 32903 -- Cenarion Mana Salve
    },
    ["Tempest Keep"] = {
        ["hp"] = 32905, -- Super Healing Potion
        ["mana"] = 32902 -- Super Mana Potion
    },
    ["default"] = {
        ["hp"] = 22829, -- Super Healing Potion
        ["mana"] = 22832 -- Super Mana Potion
    }
};

-- TODO update TK
-- TODO add dungeons
-- TODO support healthstone ranks
-- TODO check item counts
-- TODO update on bag item change?
-- TODO support food/water

local function InitMacros()
    CreateMacro("AutoConsHP", "INV_MISC_QUESTIONMARK", "")
    CreateMacro("AutoConsMana", "INV_MISC_QUESTIONMARK", "")
end

local function UpdateMacros(zone)
	--do stuff
    local consumablesForZone = consumablesByZone[zone] or consumablesByZone["default"]

    EditMacro("AutoConsHP", nil, nil, "#showtooltip\n/cast item:" .. consumablesForZone["hp"])
    EditMacro("AutoConsMana", nil, nil, "#showtooltip\n/cast item:" .. consumablesForZone["mana"])

end

-- Create our main table for this addon
AutoConsumableMacros = AutoConsumableMacros or {}

-- Create the frame that we will use for our events
AutoConsumableMacros.frame = CreateFrame("Frame", "AutoConsumableMacros", UIParent)
AutoConsumableMacros.frame:SetFrameStrata("BACKGROUND")

AutoConsumableMacros.frame:RegisterEvent("PLAYER_LOGIN")
AutoConsumableMacros.frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")

AutoConsumableMacros.frame:SetScript("OnEvent", function(self, event, ...)
    if (event == "PLAYER_LOGIN") then
        InitMacros()
    end

    if (event == "PLAYER_LOGIN" or event == "ZONE_CHANGED_NEW_AREA") then
        local zone = GetZoneText()

        print(event, zone)

        UpdateMacros(zone)
    end
end)

print("AutoConsumableMacros loaded")
