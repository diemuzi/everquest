-- Cost for Languages
local cost_language = 10000;

function event_say(e)
    -- Hail
    if (e.message:findi("hail")) then
        e.self:Say("Greetings, " .. e.other:GetCleanName() .. ". It sounds like you are having trouble understanding some words. Would you like a " .. eq.say_link("language") .. " lesson for " .. cost_language .. " platinum?");
    end

    -- Language
    if (e.message:findi("language")) then
        -- Check if we have enough money
        if (e.other:GetCarriedPlatinum() >= cost_language) then
            for i = 0, 27 do
                e.other:SetLanguageSkill(i, 100);
            end

            if (cost_language > 0) then
                e.other:TakePlatinum(cost_language, true);
            end

            e.self:Say("noitanod ruoy rof uoy knahT");
        else
            e.self:Say("You do not have enough platinum to cover the costs of my services.");
        end
    end
end

function event_trade(e)
    -- Require items library
    local item_lib = require("items");

    -- Return unused items
    item_lib.return_items(e.self, e.other, e.trade);
end