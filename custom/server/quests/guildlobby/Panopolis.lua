-- Cost for Alchemy
local cost_alchemy = 10000;

function event_say(e)
    -- Hail
    if (e.message:findi("hail")) then
        e.self:Say("Hello, " .. e.other:GetCleanName() .. ". It appears you could use some help with your " .. eq.say_link("alchemy") .. "? This skill will cost you " .. cost_alchemy .. " platinum.");
    end

    -- Alchemy
    if (e.message:findi("alchemy")) then
        -- Make certain we are a Shaman
        if (e.other:GetClassBitmask() == 512 and e.other:CanHaveSkill(59)) then
            -- Check if we have enough money
            if (e.other:GetCarriedPlatinum() >= cost_alchemy) then
                local max_skill = e.other:MaxSkill(59);

                if (max_skill > e.other:GetRawSkill(59)) then
                    e.other:SetSkill(59, max_skill);

                    if (cost_alchemy > 0) then
                        e.other:TakePlatinum(cost_alchemy, true);
                    end

                    e.self:Say("You are now proficient in Alchemy.");
                end
            else
                e.self:Say("You do not have enough platinum to cover the costs of my services.");
            end
        else
            e.self:Say("Sorry, but only Shamans can learn the secrets of Alchemy.");
        end
    end
end

function event_trade(e)
    -- Require items library
    local item_lib = require("items");

    -- Return unused items
    item_lib.return_items(e.self, e.other, e.trade);
end