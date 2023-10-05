function event_say(e)
    -- Class Name
    local class_name = e.other:GetClassName();

    -- Player Name
    local player_name = e.other:GetCleanName();

    -- Hail
    if (e.message:findi("hail")) then
        if (class_name == "Berserker" or class_name == "Monk" or class_name == "Rogue" or class_name == "Warrior") then
            e.self:Say("Young fighter, I am the greatest spell scribe Norrath has ever seen. I do not waste my time on brutes like you!");
        elseif (class_name == "Bard") then
            e.self:Say("With just one look, I can see that your songbook is lacking, " .. player_name .. "! Would you like me to " .. eq.say_link("scribe") .. " all of the known " .. class_name .. " songs for you?");
        elseif (class_name == "Beastlord" or class_name == "Cleric" or class_name == "Druid" or class_name == "Enchanter" or class_name == "Magician" or class_name == "Necromancer" or class_name == "Paladin" or class_name == "Ranger" or class_name == "Shadowknight" or class_name == "Shaman" or class_name == "Wizard") then
            e.self:Say("With just one look, I can see that your spellbook is lacking, " .. player_name .. "! Would you like me to " .. eq.say_link("scribe") .. " all of the known " .. class_name .. " spells for you?");
        end
    end

    -- Scribe
    if (e.message:findi("scribe")) then
        if (class_name == "Bard" or class_name == "Beastlord" or class_name == "Cleric" or class_name == "Druid" or class_name == "Enchanter" or class_name == "Magician" or class_name == "Necromancer" or class_name == "Paladin" or class_name == "Ranger" or class_name == "Shadowknight" or class_name == "Shaman" or class_name == "Wizard") then
            -- Unmem all songs / spells
            e.other:UnmemSpellAll(true);

            -- Remove all songs / spells
            e.other:UnscribeSpellAll(true);

            -- Scribe songs / spells
            e.other:ScribeSpells(e.other:GetLevel(), 0);

            if (class_name == "Bard") then
                e.self:Say("You look like a more powerful " .. class_name .. " already " .. player_name .. ". Go out and test your songs!");
            else
                e.self:Say("You look like a more powerful " .. class_name .. " already " .. player_name .. ". Go out and test your spells!");
            end
        else
            e.self:Say("Begone, " .. class_name .. " lest I turn you into a froglok tad!");
        end
    end
end

function event_trade(e)
    -- Require items library
    local item_lib = require("items");

    -- Return unused items
    item_lib.return_items(e.self, e.other, e.trade);
end