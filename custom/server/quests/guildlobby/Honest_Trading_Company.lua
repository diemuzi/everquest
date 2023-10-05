function event_say(e)
    -- Hail
    if (e.message:findi("hail")) then
        e.self:Say("Hello, " .. e.other:GetCleanName() .. ". I can trade " .. eq.say_link("AA points") .. " for platinum?");
    end

    -- AA points
    if (e.message:findi("aa points")) then
        -- Level 50 or less cannot receive AA Points
        if (e.other:GetLevel() >= 51) then
            e.other:Message(15, "For " .. eq.say_link("1 AA point") .. " I require payment of 100 platinum.");
            e.other:Message(15, "For " .. eq.say_link("10 AA points") .. " I require payment of 1,000 platinum.");
            e.other:Message(15, "For " .. eq.say_link("100 AA points") .. " I require payment of 10,000 platinum.");
            e.other:Message(15, "For " .. eq.say_link("1000 AA points") .. " I require payment of 100,000 platinum.");
        else
            e.self:Say("Sorry, but you need to be at least level 51.");
        end
    end

    -- 1 AA Point
    if (e.message:findi("1 aa point")) then
        get_aa(e, 1, 100)
    end

    -- 10 AA Points
    if (e.message:findi("10 aa points")) then
        get_aa(e, 10, 1000)
    end

    -- 100 AA Points
    if (e.message:findi("100 aa points")) then
        get_aa(e, 100, 10000)
    end

    -- 1000 AA Points
    if (e.message:findi("1000 aa points")) then
        get_aa(e, 1000, 100000)
    end
end

function event_trade(e)
    -- Require items library
    local item_lib = require("items");

    -- Return unused items
    item_lib.return_items(e.self, e.other, e.trade);
end

function get_aa(e, point, platinum)
    -- Check if we have enough money
    if (e.other:GetCarriedPlatinum() >= platinum) then
        e.other:AddAAPoints(point);

        e.other:TakePlatinum(platinum, true);

        e.self:Say(point .. " AA Point(s) exchanged for " .. platinum .. " platinum.");
    else
        e.self:Say("You do not have enough platinum to cover the costs of my services.");
    end
end