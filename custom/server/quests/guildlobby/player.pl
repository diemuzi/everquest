sub EVENT_CLICKDOOR {
    if ($doorid == 2 || $doorid == 4 || $doorid == 40 || $doorid == 42) {
        if ($uguild_id > 0) {
            $client->SendToGuildHall();
        }
    }
    elsif ((($doorid >= 5) && ($doorid <= 38)) || (($doorid >= 43) && ($doorid <= 76))) {
        $client->OpenLFGuildWindow();
    }
}

sub EVENT_ENTERZONE {
    #off the map
    if ($client->GetX() > 315 || $client->GetX() < -315 || $client->GetY() > 685 || $client->GetY() < -60 || $client->GetZ() < -5 || $client->GetZ() > 15) {
        $client->MovePC(344, 0, 312, 2, 0); # Zone: guildlobby
    }

    #if I am idle for more than xx seconds, auto-afk and go invisible/don't draw model
    quest::settimer("afk_check", 900); #5 minutes
}

sub EVENT_SIGNAL {
    #signals received from enter/exit proximity of various NPCs
    if ($client->GetAFK()) {
        $client->SetAFK(0);

        $client->Message(4, "You are no longer AFK.");

        quest::settimer("afk_check", 900);
    }
}

sub EVENT_TIMER {
    if ($timer eq "afk_check") {
        $client->SetAFK(1);

        $client->Message(4, "You are idle, Auto-AFK.");

        $client->MovePC(344, 286, 1046, -18, 253);

        quest::stoptimer("afk_check");
    }
}
