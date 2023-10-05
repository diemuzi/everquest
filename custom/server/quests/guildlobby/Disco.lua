function event_say(e)
    -- Hail
    if (e.message:findi("hail")) then
        e.self:Say("With just one look, I can see that you have forgotten the finer points of combat, " .. e.other:GetCleanName() .. ". Would you like me to " .. eq.say_link("teach") .. " you how to perform the skills that require more discipline than the basics?");
    end

    -- Teach
    if (e.message:findi("teach")) then
        -- Remove all discs
        e.other:UntrainDiscAll(true);

        -- Learn all discs
        e.other:LearnDisciplines(e.other:GetLevel(), 0);

        e.self:Say("You look like a more fierce combatant already. Go out and test your new abilities!");
    end
end

function event_trade(e)
    -- Require items library
    local item_lib = require("items");

    -- Return unused items
    item_lib.return_items(e.self, e.other, e.trade);
end