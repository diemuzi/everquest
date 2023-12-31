local level = {
    0,
    1000,
    8000,
    27000,
    64000,
    125000,
    216000,
    343000,
    512000,
    729000,
    1000000,
    1331000,
    1728000,
    2197000,
    2744000,
    3375000,
    4096000,
    4913000,
    5832000,
    6859000,
    8000000,
    9261000,
    10648000,
    12167000,
    13824000,
    15625000,
    17576000,
    19683000,
    21952000,
    24389000,
    29700000,
    32770100,
    36044800,
    39530700,
    43234400,
    51450000,
    55987200,
    60783600,
    65846400,
    71182800,
    83200000,
    89597296,
    96314400,
    103359104,
    110739200,
    127575000,
    136270400,
    145352192,
    154828800,
    164708608,
    175000000,
    198976496,
    224972800,
    253090896,
    299181600,
    349387488,
    403916800,
    462982496,
    526802400,
    616137024,
    669600000,
    703641088,
    738816768,
    775145728,
    812646400,
    851337472,
    891237632,
    932365312,
    974739200,
    1018377920,
    1063299968,
    1109524096,
    1157068800,
    1205952640,
    1256194432,
    1307812480,
    1360825600,
    1415252352,
    1471111168,
    1528420864,
    1587200000,
    1647467136,
    1709240832,
    1772539648,
    1837382400,
    1903787520,
    1971773568,
    2041359360,
    2112563200,
    2185403904,
    2259899904,
    2336070144,
    2413932800,
    2493506816,
    2574810368,
    2657862400,
    2742681600,
    2829286400,
    2917695232,
    3007926784
};

function event_say(e)
    -- Hail
    if (e.message:findi("hail")) then
        e.self:Say("Greetings, " .. e.other:GetCleanName() .. ". I have been sent to aid you on your journey! Tell me, what level would you like to be?");
    end

    -- Level 1 - 100
    for k, v in ipairs(level) do
        e.self:Say(eq.say_link("Level " .. tostring(k)));

        if (e.message:findi("level " .. tostring(k))) then
            e.self:Say("Setting your level to " .. tostring(k));

            e.other:SetEXP(v, e.other:GetAAExp());

            e.other:SetClientMaxLevel(k);
        end
    end
end

function event_trade(e)
    -- Require items library
    local item_lib = require("items");

    -- Return unused items
    item_lib.return_items(e.self, e.other, e.trade);
end