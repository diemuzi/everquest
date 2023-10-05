function event_say(e)
    -- Hail
    if (e.message:findi("hail")) then
        e.self:Say("Hello, " .. e.other:GetCleanName() .. "! It appears you could use some help with your " .. eq.say_link("combat skills") .. ". Would you like me to teach you?");
    end

    -- Combat Skills
    if (e.message:findi("combat skills")) then
        for i = 0, 77 do
            if (i >= 0 and i <= 42 or i >= 48 and i <= 54 or i >= 70 and i <= 77) then
                -- Check if we can have this skill
                if (e.other:CanHaveSkill(i)) then
                    local max_skill = e.other:MaxSkill(i);

                    if (max_skill > e.other:GetRawSkill(i)) then
                        e.other:SetSkill(i, max_skill);
                    end
                end
            end
        end

        e.self:Say("You look like a more capable " .. e.other:GetClassName() .. " already " .. e.other:GetCleanName() .. ". Go out and test your skills!");
    end
end

function event_trade(e)
    -- Require items library
    local item_lib = require("items");

    -- Return unused items
    item_lib.return_items(e.self, e.other, e.trade);
end