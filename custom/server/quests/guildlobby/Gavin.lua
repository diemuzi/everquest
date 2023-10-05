-- Cost for Lesser Buffs
local cost_lesser_buffs = 100;

-- Cost for Great Buffs
local cost_greater_buffs = 1000;

function event_say(e)
    -- Hail
    if (e.message:findi("hail")) then
        e.self:Say("Greetings, " .. e.other:GetCleanName() .. ". I have been sent to aid you on your journey! Would you like some " .. eq.say_link("lesser buffs") .. " for " .. cost_lesser_buffs .. " platinum, or some " .. eq.say_link("greater blessings") .. " for " .. cost_greater_buffs .. " platinum?");

        e.self:Say("I can also " .. eq.say_link("cure") .. " you and/or your pet for free.");
    end

    -- Lesser Buffs
    if (e.message:findi("lesser buffs")) then
        -- Check if we have enough money
        if (e.other:GetCarriedPlatinum() >= cost_lesser_buffs) then
            local array = { 276, 278, 219, 368, 146, 148, 279, 129 };

            for _, v in ipairs(array) do
                eq.cross_zone_cast_spell_by_char_id(e.other:CharacterID(), v);
            end

            if (cost_lesser_buffs > 0) then
                e.other:TakePlatinum(cost_lesser_buffs, true);
            end
        else
            e.self:Say("You do not have enough platinum to cover the costs of my services.");
        end
    end

    -- Greater Blessings
    if (e.message:findi("greater blessings")) then
        -- Check if we have enough money
        if (e.other:GetCarriedPlatinum() >= cost_greater_buffs) then
            local array = { 3692, 2505, 423, 356, 172, 64, 145, 1693, 15, 60, 61, 46, 2524 };

            for _, v in ipairs(array) do
                eq.cross_zone_cast_spell_by_char_id(e.other:CharacterID(), v);
            end

            if (cost_greater_buffs > 0) then
                e.other:TakePlatinum(cost_greater_buffs, true);
            end
        else
            e.self:Say("You do not have enough platinum to cover the costs of my services.");
        end
    end

    -- Cure
    if (e.message:findi("cure")) then
        eq.cross_zone_cast_spell_by_char_id(e.other:CharacterID(), 6594);
    end
end

function event_trade(e)
    -- Require items library
    local item_lib = require("items");

    -- Return unused items
    item_lib.return_items(e.self, e.other, e.trade);
end