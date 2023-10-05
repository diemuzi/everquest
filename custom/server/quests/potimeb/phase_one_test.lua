-- NPCID 223169
--Phase 1 - Anar of Water Trial
--potimeb

local event_counter = 0;
local anar = false;

--specify trial boundaries for player check routine
local min_x = -75;
local max_x = 90;
local min_y = 805;
local max_y = 920;
local player_limit = 18;

function event_spawn(e)
	-- create a proximity to set the spawn timer
	event_counter = 0;
	local xloc = e.self:GetX();
	local yloc = e.self:GetY();
	eq.set_proximity(xloc - 80, xloc + 80, yloc - 60, yloc + 60);
end

function event_enter(e)
	-- tell zone_status phase 1 was started
	eq.signal(223097,1,5*1000);
	-- wait 45 seconds before spawning the mobs.
	eq.clear_proximity();
	eq.set_timer("Phase1Water",45000);
	eq.set_timer("player_count",5 * 1000);	--check to ensure only 18 players in trial area
end

function event_timer(e)
	if(e.timer == "Phase1Water") then
		-- spawn first wave of 3 a_pile_of_living_rubble
		eq.spawn2(223092,0,0,48,892,495,371);
		eq.spawn2(223093,0,0,48,842,495,371);
		eq.stop_timer("Phase1Water");
	elseif(e.timer == "player_count") then
		CheckPlayerCount(e);
	end
end

function event_signal(e)
	-- signal 1 comes from the phase 1 a_rock_shaped_assassin
	-- and is used to increment a counter so we know when to spawn the next wave.
	if (e.signal == 1) then
		event_counter = event_counter + 1;
		-- spawn Anar_of_Water
		if (event_counter == 6) then

			-- Check on which version to spawn
			local expedition = eq.get_expedition()
			if (expedition.valid and not expedition:HasLockout('Anar of Water')) then
				eq.unique_spawn(223104,0,0,68,867,495,371);  	--Anar_of_Water (223104)
			else
				eq.unique_spawn(223091,0,0,68,867,495,371);	--#Shadow_of_Anar (223091)
			end
			--event_counter = 0;
		end
	-- signal 2 comes from Anar_of_Water
	elseif (e.signal == 2) then
		anar = true;
	end
	TrialWinCheck(e);
end

function TrialWinCheck(e)	--to make successful end event once both boss and adds are dead
	if kazrok then
		-- tell zone_status
		eq.signal(223097,223172); -- Add Loot Lockout for Phase 1 Wing
		eq.signal(223097,2); -- Increment Phase 1 Wing Counter
		eq.local_emote({e.self:GetX(), e.self:GetY(), e.self:GetZ()},MT.LightGray,80,"Ethereal mists gather at the far wall, causing it to fade in and out of focus.");

		-- depop as my job is done.
		eq.depop();
	end
end

function CheckPlayerCount(e)
	local player_list = eq.get_entity_list():GetClientList();
	local count = 0;
	if(player_list ~= nil) then
		for pc in player_list.entries do
			if pc:GetX() >= min_x and pc:GetX() <= max_x and pc:GetY() >= min_y and pc:GetY() <= max_y and not pc:GetGM() then
				count = count + 1;
				if count > player_limit then
					pc:MovePC(219,-37,-110,13,0);	--boot to Time A
				end
			end
		end
	end
end

