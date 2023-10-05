local race_type;

local races = {
    [1] = "Human",
    [2] = "Barbarian",
    [3] = "Erudite",
    [4] = "Wood Elf",
    [5] = "High Elf",
    [6] = "Dark Elf",
    [7] = "Half Elf",
    [8] = "Dwarf",
    [9] = "Troll",
    [10] = "Ogre",
    [11] = "Halfling",
    [12] = "Gnome",
    [128] = "Iksar",
    [130] = "Vah Shir",
    [330] = "Froglok",
    [522] = "Drakkin"
};

function event_say(e)
    -- Hail
    if (e.message:findi("hail")) then
        e.self:Say("Hello, " .. e.other:GetCleanName() .. "! Would you like to " .. eq.say_link("change your race") .. "?");
    end

    -- Change your race
    if (e.message:findi("change your race")) then
        e.other:Message(15, "Choose a new race.");

        for _, v in pairs(races) do
            e.other:Message(15, eq.say_link(v));
        end
    end

    -- Races
    for k, v in pairs(races) do
        if (e.message:findi(v)) then
            e.other:Message(15, "Are you sure you want to change your race to a " .. v .. "?");
            e.other:Message(4, "If you " .. eq.say_link("wish to proceed") .. ", then you will be disconnected.");

            race_type = k;
        end
    end

    -- Wish to proceed
    if (e.message:findi("wish to proceed")) then
        -- Set race
        e.other:SetBaseRace(race_type);

        -- Kick to login
        e.other:WorldKick();
    end
end

function event_trade(e)
    -- Require items library
    local item_lib = require("items");

    -- Return unused items
    item_lib.return_items(e.self, e.other, e.trade);
end