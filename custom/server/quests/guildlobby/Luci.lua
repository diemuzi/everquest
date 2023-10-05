-- Cost for Poison Making
local cost_poison_making = 10000;

function event_say(e)
    -- Hail
    if (e.message:findi("hail")) then
        e.self:Say("Hello, " .. e.other:GetCleanName() .. ". It appears you could use some help with your " .. eq.say_link("poison making") .. "? This skill will cost you " .. cost_poison_making .. " platinum.");
    end

    -- Poison Making
    if (e.message:findi("poison making")) then
        -- Make certain we are a Rogue
        if (e.other:GetClassBitmask() == 256 and e.other:CanHaveSkill(56)) then
            -- Check if we have enough money
            if (e.other:GetCarriedPlatinum() >= cost_poison_making) then
                local max_skill = e.other:MaxSkill(56);

                if (max_skill > e.other:GetRawSkill(56)) then
                    e.other:SetSkill(56, max_skill);

                    if (cost_poison_making > 0) then
                        e.other:TakePlatinum(cost_poison_making, true);
                    end

                    e.self:Say("You are now proficient in Poison Making.");
                end
            else
                e.self:Say("You do not have enough platinum to cover the costs of my services.");
            end
        else
            e.self:Say("Sorry, but only Rogues can learn the secrets of Poison Making.");
        end
    end
end

function event_trade(e)
    -- Require items library
    local item_lib = require("items");

    -- Return unused items
    item_lib.return_items(e.self, e.other, e.trade);
end