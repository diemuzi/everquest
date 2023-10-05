function event_say(e)
    -- Hail
    if (e.message:findi("hail")) then
        e.self:Say("Hello, " .. e.other:GetCleanName() .. "! Would you like to " .. eq.say_link("change your gender") .. "?");
    end

    -- Change your gender
    if (e.message:findi("change your gender")) then
        e.other:Message(4, "Please choose " .. eq.say_link("male") .. " or " .. eq.say_link("female") .. ", then you will be disconnected.");
    end

    -- Female
    if (e.message:findi("female")) then
        -- Set female gender
        e.other:SetBaseGender(1);

        -- Kick to login
        e.other:WorldKick();
    elseif (e.message:findi("male")) then
        -- Set male gender
        e.other:SetBaseGender(0);

        -- Kick to login
        e.other:WorldKick();
    end
end

function event_trade(e)
    -- Require items library
    local item_lib = require("items");

    -- Return unused items
    item_lib.return_items(e.self, e.other, e.trade);
end