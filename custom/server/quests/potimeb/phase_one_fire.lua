-- NPCID 223169
--Phase 1 - Kazrok of Fire Trial
--potimeb

local event_counter = 0;
local kazrok = false;

--specify trial boundaries for player check routine
local min_x = -75;
local max_x = 90;
local min_y = 505;
local max_y = 635;
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
	eq.set_timer("Phase1Fire",45000);
	eq.set_timer("player_count",5 * 1000);	--check to ensure only 18 players in trial area
end

function event_timer(e)
	if(e.timer == "Phase1Fire") then
		-- spawn first wave of 3 a_pile_of_living_rubble
		eq.spawn2(223088,0,0,45,573,504,371);
		eq.spawn2(223088,0,0,68,553,504,371);
		eq.spawn2(223088,0,0,68,594,504,371);
		eq.stop_timer("Phase1Fire");
	elseif(e.timer == "player_count") then
		CheckPlayerCount(e);
	end
end

function event_signal(e)
	if (e.signal == 1) then
		-- Check on which version to spawn
		local expedition = eq.get_expedition()
		if (expedition.valid and not expedition:HasLockout('Kazrok of Fire')) then
			eq.unique_spawn(223090,0,0,68,573,504,371);  	--#Kazrok_of_Fire (223090)
		else
			eq.unique_spawn(223244,0,0,68,573,504,371);	--#Shadow_of_Kazrok (223244)  PH version
		end
	-- signal 2 comes from Kazrok_of_Fire
	elseif (e.signal == 2) then
	    event_counter = event_counter + 1;

		kazrok = true;
	end
	TrialWinCheck(e);
end

function TrialWinCheck(e)	--to make successful end event once both boss and adds are dead
	if kazrok and not eq.get_entity_list():IsMobSpawnedByNpcTypeID(223088) then
		-- tell zone_status
		eq.signal(223097,223173); -- Add Loot Lockout for Phase 1 Wing
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

