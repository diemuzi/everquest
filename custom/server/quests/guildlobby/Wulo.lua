local can_prestige = false;

local class_type;

local classes = {
    [1] = 'Warrior',
    [2] = 'Cleric',
    [3] = 'Paladin',
    [4] = 'Ranger',
    [5] = 'Shadow Knight',
    [6] = 'Druid',
    [7] = 'Monk',
    [8] = 'Bard',
    [9] = 'Rogue',
    [10] = 'Shaman',
    [11] = 'Necromancer',
    [12] = 'Wizard',
    [13] = 'Magician',
    [14] = 'Enchanter',
    [15] = 'Beastlord',
    [16] = 'Berserker'
};

local has_item_equipped = true;

local required_item = {
    [1] = 60332, -- Warrior
    [2] = 20076, -- Cleric
    [4] = 48147, -- Paladin
    [8] = 62649, -- Ranger
    [16] = 48136, -- Shadow Knight
    [32] = 62880, -- Druid
    [64] = 67742, -- Monk
    [128] = 77640, -- Bard
    [256] = 52348, -- Rogue
    [512] = 57405, -- Shaman
    [1024] = 64067, -- Necromancer
    [2048] = 16575, -- Wizard
    [4096] = 19839, -- Magician
    [8192] = 52962, -- Enchanter
    [16384] = 57054, -- Beastlord
    [32768] = 20072  -- Berserker
};

function event_say(e)
    -- Hail
    if (e.message:findi("hail")) then
        e.self:Say("Hello, " .. e.other:GetCleanName() .. "! Would you like to " .. eq.say_link("prestige") .. "?");

        -- Set to default values
        can_prestige = false;
        class_type = nil;
        has_item_equipped = true;
    end

    -- Prestige
    if (e.message:findi("prestige")) then
        -- Check if we have the required item and character is level 100
        if (e.other:CountItem(required_item[e.other:GetClassBitmask()]) == 1 and e.other:GetLevel() == 100) then
            e.self:Say("WOW! Congratulations! You've experienced quite a bit. How about a new adventure as a new class?");

            -- Check if we are naked
            inventory_check(e);

            class_type = nil;

            if (has_item_equipped == false) then
                e.other:Message(15, "Which class would you like to be next?");
                e.other:Message(15, "Cloth classes " .. eq.say_link("Enchanter") .. " -- " .. eq.say_link("Magician") .. " -- " .. eq.say_link("Necromancer") .. " -- " .. eq.say_link("Wizard"));
                e.other:Message(15, "Leather classes " .. eq.say_link("Beastlord") .. " -- " .. eq.say_link("Druid") .. " -- " .. eq.say_link("Monk"));
                e.other:Message(15, "Chain classes " .. eq.say_link("Berserker") .. " -- " .. eq.say_link("Ranger") .. " -- " .. eq.say_link("Rogue") .. " -- " .. eq.say_link("Shaman"));
                e.other:Message(15, "Plate classes " .. eq.say_link("Bard") .. " -- " .. eq.say_link("Cleric") .. " -- " .. eq.say_link("Paladin") .. " -- " .. eq.say_link("Shadow Knight") .. " -- " .. eq.say_link("Warrior"));

                can_prestige = true;
            end
        else
            e.self:Say("Sorry but you do not meet the requirements. You must be at least level 100 and have the required epic.");
        end
    end

    -- Classes
    if (can_prestige == true) then
        for k, v in ipairs(classes) do
            if (e.message:findi(v)) then
                e.other:Message(15, "Are you sure you want to change your class to a " .. v .. "?");
                e.other:Message(13, "Make sure all corpses are looted before continuing as they will be destroyed.");
                e.other:Message(4, "If you " .. eq.say_link("wish to proceed") .. ", then you will be disconnected.");

                class_type = k;
            end
        end

        -- Wish to proceed
        if (e.message:findi("wish to proceed")) then
            -- Check if we are naked
            inventory_check(e);

            -- Remove corpses
            remove_corpses(e);

            -- Return to level 1
            e.other:SetClientMaxLevel(1);

            -- Reset experience
            e.other:SetEXP(0, e.other:GetAAExp());

            -- Reset skills
            for i = 0, 77 do
                if (e.other:HasSkill(i)) then
                    e.other:SetSkill(i, 1);
                end
            end

            -- Reset languages
            for i = 0, 27 do
                e.other:SetLanguageSkill(i, 1);
            end

            -- Untrain Discs
            e.other:UntrainDiscAll(true);

            -- Unscribe spells
            e.other:UnscribeSpellAll(true);
            e.other:UnmemSpellAll(true);

            -- Set class
            e.other:SetBaseClass(class_type);

            -- Kick to login
            e.other:WorldKick();
        end
    end
end

function event_trade(e)
    -- Require items library
    local item_lib = require("items");

    -- Return unused items
    item_lib.return_items(e.self, e.other, e.trade);
end

function inventory_check(e)
    local inventory = {
        [0] = 'Charm', -- Charm
        [1] = 'Ear', -- Ear1
        [2] = 'Head', -- Head
        [3] = 'Face', -- Face
        [4] = 'Ear', -- Ear2
        [5] = 'Neck', -- Neck
        [6] = 'Shoulder', -- Shoulders
        [7] = 'Arm', -- Arms
        [8] = 'Back', -- Back
        [9] = 'Wrist', -- Wrist1
        [10] = 'Wrist', -- Wrist2
        [11] = 'Range', -- Range
        [12] = 'Hand', -- Hands
        [13] = 'Primary', -- Primary
        [14] = 'Secondary', -- Secondary
        [15] = 'Finger', -- Finger1
        [16] = 'Finger', -- Finger2
        [17] = 'Chest', -- Chest
        [18] = 'Leg', -- Legs
        [19] = 'Feet', -- Feet
        [20] = 'Waist', -- Waist
        [21] = 'PowerSource', -- PowerSource
        [22] = 'Ammo' -- Ammo
    };

    -- Check if we are naked
    for k, v in pairs(inventory) do
        if (e.other:GetItemIDAt(k) > 0) then
            e.other:Message(15, "You have a " .. v .. " item equipped. Please remove it.");

            has_item_equipped = true;

            return 1;
        else
            has_item_equipped = false;
        end
    end
end

function remove_corpses(e)
    if (e.other:GetCorpseCount() > 0) then
        eq.summon_all_player_corpses(e.other:CharacterID(), e.self:GetX(), e.self:GetY(), e.self:GetZ(), 0);
    end

    local corpse_list = eq.get_entity_list():GetCorpseList();

    if (corpse_list ~= nil) then
        for corpse in corpse_list.entries do
            if (corpse:IsPlayerCorpse() and corpse:GetOwnerName() == e.other:GetName()) then
                corpse:Delete();
            end
        end
    end
end