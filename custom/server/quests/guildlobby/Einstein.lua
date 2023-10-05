-- Cost for Tinkering
local cost_tinkering = 10000;

function event_say(e)
    -- Hail
    if (e.message:findi("hail")) then
        e.self:Say("Hello, " .. e.other:GetCleanName() .. ". It appears you could use some help with your " .. eq.say_link("tinkering") .. "? This skill will cost you " .. cost_tinkering .. " platinum.");
    end

    -- Tinkering
    if (e.message:findi("tinkering")) then
        -- Make certain we are a Gnome
        if (e.other:GetRaceBitmask() == 2048 and e.other:CanHaveSkill(57)) then
            -- Check if we have enough money
            if (e.other:GetCarriedPlatinum() >= cost_tinkering) then
                local max_skill = e.other:MaxSkill(57);

                if (max_skill > e.other:GetRawSkill(57)) then
                    e.other:SetSkill(57, max_skill);

                    if (cost_tinkering > 0) then
                        e.other:TakePlatinum(cost_tinkering, true);
                    end

                    e.self:Say("You are now proficient in Tinkering.");
                end
            else
                e.self:Say("You do not have enough platinum to cover the costs of my services.");
            end
        else
            e.self:Say("Sorry, but only Gnomes can learn the secrets of Tinkering.");
        end
    end
end

function event_trade(e)
    -- Require items library
    local item_lib = require("items");

    -- Return unused items
    item_lib.return_items(e.self, e.other, e.trade);
end