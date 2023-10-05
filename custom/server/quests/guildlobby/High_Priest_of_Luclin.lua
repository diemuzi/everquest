function event_say(e)
    -- Hail
    if (e.message:findi("hail")) then
        e.self:Say("Greetings, " .. e.other:GetCleanName() .. ". When a hero of our world is slain their soul returns to the place it was last bound and the body is reincarnated. As a member of the Order of Eternity it is my duty to " .. eq.say_link("bind your soul") .. " to this location if that is your wish.");
    end

    -- Bind your soul
    if (e.message:findi("bind your soul")) then
        e.other:SetBindPoint(344, 0, -249.31, 423.78, 0.19, 145.25);

        e.self:Say("You are now bound to this zone " .. e.other:GetCleanName() .. ".");
    end
end

function event_trade(e)
    -- Require items library
    local item_lib = require("items");

    -- Return unused items
    item_lib.return_items(e.self, e.other, e.trade);
end