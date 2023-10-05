local tradeskills = {
    Fishing = 55,
    Research = 58,
    Baking = 60,
    Tailoring = 61,
    Smithing = 63,
    Fletching = 64,
    Brewing = 65,
    Jewelcrafting = 68,
    Pottery = 69
};

local cost_tradeskill = 10000;

function event_say(e)
    -- Hail
    if (e.message:findi("hail")) then
        e.self:Say("Hello, " .. e.other:GetCleanName() .. ". Would you like me to teach you some " .. eq.say_link("tradeskills") .. "? Each skill will cost you " .. cost_tradeskill .. " platinum.");
    end

    -- Tradeskills
    if (e.message:findi("tradeskills")) then
        local skills = "";

        for k, _ in pairs(tradeskills) do
            skills = skills .. eq.say_link(k) .. " | ";
        end

        e.other:Message(15, "I can teach you the following: " .. skills:sub(1, -3));
    end

    for k, v in pairs(tradeskills) do
        if (e.message:findi(k)) then
            if (e.other:GetCarriedPlatinum() >= cost_tradeskill) then
                -- Check if we can have this skill
                if (e.other:CanHaveSkill(v)) then
                    local max_skill = e.other:MaxSkill(v);

                    if (max_skill > e.other:GetRawSkill(v)) then
                        e.other:SetSkill(v, max_skill);

                        e.other:TakePlatinum(cost_tradeskill, true);

                        e.self:Say("You are now proficient in " .. k .. ".");
                    end
                end
            else
                e.self:Say("You do not have enough platinum to cover the costs of my services.");
            end
        end
    end
end

function event_trade(e)
    -- Require items library
    local item_lib = require("items");

    -- Return unused items
    item_lib.return_items(e.self, e.other, e.trade);
end