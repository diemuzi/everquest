function event_say(e)
    -- Hail
    if (e.message:findi("hail")) then
        e.self:Say("Hello, " .. e.other:GetCleanName() .. "! Looks like you could use one of my " .. eq.say_link("lucky charms") .. ". Are you up for a challenge?");
    end

    -- Luck Charms
    if (e.message:findi("lucky charms")) then
        eq.task_selector({ 505746 });
    end
end

function event_trade(e)
    -- Require items library
    local item_lib = require("items");

    -- Return unused items
    item_lib.return_items(e.self, e.other, e.trade);
end