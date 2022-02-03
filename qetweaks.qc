// The variable we use to hold tweak-enabling flags
float qetweaks;

// 1 of 3: Add flag definition
float QETWEAK_GGMOD           = 1;
float QETWEAK_MAP_START_OPEN  = 2;
float QETWEAK_MAP_DM1_UPGRADE = 4;
float QETWEAK_DOUBLE_JUMP     = 8;
float QETWEAK_GRAPPLING_HOOK  = 16;
float QETWEAK_PLAYER_HUD      = 32;
float QETWEAK_SPEEDOMETER     = 64;

// 2 of 3: Add string description
string QETWEAK_S_GGMOD           = "1: GGMod weapon adjustments enabled\n";
string QETWEAK_S_MAP_START_OPEN  = "2: start map stairs open\n";
string QETWEAK_S_MAP_DM1_UPGRADE = "4: dm1 map weapons upgraded\n";
string QETWEAK_S_DOUBLE_JUMP     = "8: Double-jump\n";
string QETWEAK_S_GRAPPLING_HOOK  = "16: Grappling hook\n";
string QETWEAK_S_PLAYER_HUD      = "32: Player HUD with game timer, score, and ammo counts\n";
string QETWEAK_S_SPEEDOMETER     = "64: Speedometer\n";

// 3 of 3: Add to welcome message
void() QETweaksWelcome = {
    centerprint(self,
        "Welcome to QETweaks\n"
        "\n"
        "Any bugs are probably related to the mod\n"
        "Tweaks server value: ",ftos(qetweaks),"\n"
        "\n"
        "Have fun!");

    sprint(self, "Enabled tweaks:\n");
    if (qetweaks & QETWEAK_GGMOD)
    {
        sprint(self, QETWEAK_S_GGMOD);
    }
    if (qetweaks & QETWEAK_MAP_START_OPEN)
    {
        sprint(self, QETWEAK_S_MAP_START_OPEN);
    }
    if (qetweaks & QETWEAK_MAP_DM1_UPGRADE)
    {
        sprint(self, QETWEAK_S_MAP_DM1_UPGRADE);
    }
    if (qetweaks & QETWEAK_DOUBLE_JUMP)
    {
        sprint(self, QETWEAK_S_DOUBLE_JUMP);
    }
    if (qetweaks & QETWEAK_GRAPPLING_HOOK)
    {
        sprint(self, QETWEAK_S_GRAPPLING_HOOK);
    }
    if (qetweaks & QETWEAK_PLAYER_HUD)
    {
        sprint(self, QETWEAK_S_PLAYER_HUD);
        if (cvar("scr_usekfont") == 1)
        {
            sprint(self, "  Recommend setting scr_usekfont 0\n");
        }
    }
    if (qetweaks & QETWEAK_SPEEDOMETER)
    {
        if (qetweaks & QETWEAK_PLAYER_HUD)
        {
            sprint(self, "Cannot enable both HUD and Speedometer!\n");
        }
        else
        {
            sprint(self, QETWEAK_S_SPEEDOMETER);
            if (cvar("scr_usekfont") == 1)
            {
                sprint(self, "  Recommend setting scr_usekfont 0\n");
            }
        }
    }
}

// Initialization
void() QETweaksInit = {

    // Initialize from "saved1" CVAR
    qetweaks = cvar("saved1");
}

// Update player HUD with match timer, current score, weapon and ammo count info
void QETweaksHudUpdate() =
{
    // Let the welcome message print
	if (time < 5)
		return;

	// Only update after delay time has been reached
	if (time < self.delay)
	{
        return;
    }

    // Only update every 0.1 seconds
    self.delay = time + 0.1;

    // Calculate time values for display
    local float cur_sec;
    local float cur_min;

    // Print different timer values based on what's interesting
    if (cvar("timelimit") != 0)
    {
        cur_sec = floor(cvar("timelimit") * 60 - time) % 60;
        cur_min = floor(floor(cvar("timelimit") * 60 - time) / 60);
    }
    else
    {
        cur_sec = floor(time) % 60;
        cur_min = floor(floor(time) / 60);
    }

    // Reminder: centerprint can do 7 strings, 40 lines, 50 characters wide
    msg_entity = self;
    WriteByte (MSG_ONE, SVC_CENTERPRINT);

    // 1 base(?) + 1 format string + 21 format parameters
    WriteShort (MSG_ONE, 23); // QE reserved

    // Print newlines to push hud to bottom of screen
    local float newlines;
    if (cvar("cl_hud") == 3) // Quake HUD full
    {
        if (cvar("scr_usekfont") == 0)
        {
            newlines = 19;
        }
        else
        {
            newlines = 15;
        }
    }
    else if (cvar("cl_hud") == 2) // Quake HUD standard
    {
        if (cvar("scr_usekfont") == 0)
        {
            newlines = 20;
        }
        else
        {
            newlines = 16;
        }
    }
    else if (cvar("cl_hud") == 0) // Quake HUD off
    {
        if (cvar("scr_usekfont") == 0)
        {
            newlines = 21;
        }
        else
        {
            newlines = 17;
        }
    }
    else // Quake HUD or minimal
    {
        newlines = 17;
    }
    local float i;
    for(i = 0; i < newlines; i = i + 1)
    {
        WriteByte (MSG_ONE, '\n');
    }

    // Write format string
    if (cvar("scr_usekfont") == 0)
    {
        WriteString(MSG_ONE,
            // Timer
            "\x10{}{}:{}{}\x11                                          \n"
            // Frags, Cells
            "\x10{}{}{}{}{}\x11                                   {}\x10{}{}\x11\n"
            // Rockets
            "                                           {}\x10{}{}\x11\n"
            // Nails
            "                                           {}\x10{}{}\x11\n"
            // Shells
            "                                           {}\x10{}{}\x11\n"
        );
    }
    else
    {
        WriteString(MSG_ONE,
            // Timer
            "  {}{}:{}{}                                          \n"
            // Frags, Cells
            " {}{}{}{}{}                                 {} {}{} \n"
            // Rockets
            "                                        {} {}{} \n"
            // Nails
            "                                        {} {}{} \n"
            // Shells
            "                                        {} {}{} \n"
        );
    }

    // Timer
    // Padding
    if (cur_min < 10)
    {
        WriteString(MSG_ONE, "  ");
    }
    else if (cur_min < 100)
    {
        WriteString(MSG_ONE, " ");
    }
    else // >= 100
    {
        WriteString(MSG_ONE, "");
    }
    // Minutes
    WriteString(MSG_ONE, ftos(cur_min));
    // Seconds
    // Padding
    if (cur_sec < 10)
    {
        // Leading zero on seconds
        WriteString(MSG_ONE, "0");
    }
    else
    {
        WriteString(MSG_ONE, "");
    }
    // Value
    WriteString(MSG_ONE, ftos(cur_sec));

    // Frags/Score
    // Spacing before score
    WriteString(MSG_ONE, "");
    WriteString(MSG_ONE, "");
    WriteString(MSG_ONE, "   ");
    // 3-digit score padding
    if (self.frags < -9)
    {
        WriteString(MSG_ONE, "");
    }
    else if (self.frags < 0)
    {
        WriteString(MSG_ONE, " ");
    }
    else if (self.frags < 10)
    {
        WriteString(MSG_ONE, "  ");
    }
    else if (self.frags < 100)
    {
        WriteString(MSG_ONE, " ");
    }
    else // >= 100
    {
        WriteString(MSG_ONE, "");
    }
    // Value
    WriteString(MSG_ONE, ftos(self.frags));

    // LG, Cells
    if (self.items & IT_LIGHTNING)
    {
        if (cvar("scr_usekfont") == 0)
        {
            WriteString(MSG_ONE, " \sl"); // bronze l
        }
        else
        {
            WriteString(MSG_ONE, " l"); // white l
        }
    }
    else
    {
        WriteString(MSG_ONE, "  ");
    }
    // Padding
    if (self.ammo_cells < 10)
    {
        WriteString(MSG_ONE, "  ");
    }
    else if (self.ammo_cells < 100)
    {
        WriteString(MSG_ONE, " ");
    }
    else // >= 100
    {
        WriteString(MSG_ONE, "");
    }
    // Value
    WriteString(MSG_ONE, ftos(self.ammo_cells));

    // RL/GL, Rockets
    if ((self.items & IT_GRENADE_LAUNCHER) && (self.items & IT_ROCKET_LAUNCHER))
    {
        if (cvar("scr_usekfont") == 0)
        {
            WriteString(MSG_ONE, "\sgr"); // bronze gr
        }
        else
        {
            WriteString(MSG_ONE, "gr"); // white gr
        }
    }
    else if (self.items & IT_GRENADE_LAUNCHER)
    {
        if (cvar("scr_usekfont") == 0)
        {
            WriteString(MSG_ONE, " \sg"); // bronze g
        }
        else
        {
            WriteString(MSG_ONE, " g"); // white g
        }
    }
    else if (self.items & IT_ROCKET_LAUNCHER)
    {
        if (cvar("scr_usekfont") == 0)
        {
            WriteString(MSG_ONE, " \sr"); // bronze r
        }
        else
        {
            WriteString(MSG_ONE, " r"); // white r
        }
    }
    else
    {
        WriteString(MSG_ONE, "  ");
    }
    // Padding
    if (self.ammo_rockets < 10)
    {
        WriteString(MSG_ONE, "  ");
    }
    else if (self.ammo_rockets < 100)
    {
        WriteString(MSG_ONE, " ");
    }
    else // >= 100
    {
        WriteString(MSG_ONE, "");
    }
    // Value
    WriteString(MSG_ONE, ftos(self.ammo_rockets));

    // NG/SNG, Nails
    if ((self.items & IT_NAILGUN) && (self.items & IT_SUPER_NAILGUN))
    {
        if (cvar("scr_usekfont") == 0)
        {
            WriteString(MSG_ONE, "\sns"); // bronze ns
        }
        else
        {
            WriteString(MSG_ONE, "ns"); // white ns
        }
    }
    else if (self.items & IT_NAILGUN)
    {
        if (cvar("scr_usekfont") == 0)
        {
            WriteString(MSG_ONE, " \sn"); // bronze n
        }
        else
        {
            WriteString(MSG_ONE, " n"); //white n
        }
    }
    else if (self.items & IT_SUPER_NAILGUN)
    {
        if (cvar("scr_usekfont") == 0)
        {
            WriteString(MSG_ONE, " \ss"); // bronze s
        }
        else
        {
            WriteString(MSG_ONE, " s"); // white s
        }
    }
    else
    {
        WriteString(MSG_ONE, "  ");
    }
    // Padding
    if (self.ammo_nails < 10)
    {
        WriteString(MSG_ONE, "  ");
    }
    else if (self.ammo_nails < 100)
    {
        WriteString(MSG_ONE, " ");
    }
    else // >= 100
    {
        WriteString(MSG_ONE, "");
    }
    // Value
    WriteString(MSG_ONE, ftos(self.ammo_nails));

    // SG/SSG, Shells
    if ((self.items & IT_SHOTGUN) && (self.items & IT_SUPER_SHOTGUN))
    {
        if (cvar("scr_usekfont") == 0)
        {
            WriteString(MSG_ONE, "\sss"); // bronze ss
        }
        else
        {
            WriteString(MSG_ONE, "ss"); // white ss
        }
    }
    else if (self.items & IT_SHOTGUN)
    {
        if (cvar("scr_usekfont") == 0)
        {
            WriteString(MSG_ONE, " \ss"); //bronze s
        }
        else
        {
            WriteString(MSG_ONE, " s"); //white s
        }
    }
    else if (self.items & IT_SUPER_SHOTGUN)
    {
        if (cvar("scr_usekfont") == 0)
        {
            WriteString(MSG_ONE, " \ss"); // bronze s
        }
        else
        {
            WriteString(MSG_ONE, " s"); // white s
        }
    }
    else
    {
        WriteString(MSG_ONE, "  ");
    }
    // Padding
    if (self.ammo_shells < 10)
    {
        WriteString(MSG_ONE, "  ");
    }
    else if (self.ammo_shells < 100)
    {
        WriteString(MSG_ONE, " ");
    }
    else // >= 100
    {
        WriteString(MSG_ONE, "");
    }
    // Value
    WriteString(MSG_ONE, ftos(self.ammo_shells));

    // Everything after the format string parameters gets eaten

    // Terminating null byte
    WriteByte (MSG_ONE, 0);
}

// Update speedometer
void QETweaksSpeedometerUpdate() =
{
    // Let the welcome message print
	if (time < 5)
		return;

    // Get current speed and remove the z component
    local vector xy_velocity;
	xy_velocity = self.velocity;
	xy_velocity_z = 0;

    // Get vector length and truncate to nearest integer
    local float current_speed;
	current_speed = floor(vlen(xy_velocity));

    local float current_meter;
    if (current_speed < 320)
    {
        current_meter = 0;
    }
    else
    {
        current_meter = floor((current_speed - 320)/ 16);
    }

	// Reminder: centerprint can do 7 strings, 40 lines, 50 characters wide
    msg_entity = self;
    WriteByte (MSG_ONE, SVC_CENTERPRINT);

    // 1 base(?) + 1 format string + 1 format parameter (speed)
    WriteShort (MSG_ONE, 3); // QE reserved

    // Print newlines to push hud to bottom of screen
    local float newlines;
    if (cvar("cl_hud") == 3) // Quake HUD full
    {
        if (cvar("scr_usekfont") == 0)
        {
            newlines = 23;
        }
        else
        {
            newlines = 21;
        }
    }
    else if (cvar("cl_hud") == 2) // Quake HUD standard
    {
        if (cvar("scr_usekfont") == 0)
        {
            newlines = 24;
        }
        else
        {
            newlines = 21;
        }
    }
    else if (cvar("cl_hud") == 0) // Quake HUD off
    {
        if (cvar("scr_usekfont") == 0)
        {
            newlines = 23;
        }
        else
        {
            newlines = 21;
        }
    }
    else // Quake HUD minimal
    {
        newlines = 18;
    }
    local float i;
    for(i = 0; i < newlines; i = i + 1)
    {
        WriteByte (MSG_ONE, '\n');
    }

    if (cvar("scr_usekfont") == 0) {
        WriteByte (MSG_ONE, 128);
        for(i = 0; i < 10; i = i + 1)
        {
            if (i == current_meter)
            {
                WriteByte (MSG_ONE, 131);
            }
            else
            {
                WriteByte (MSG_ONE, 129);
            }
        }
        WriteByte (MSG_ONE, 130);
        WriteByte (MSG_ONE, '\n');
    }
    else
    {
        WriteByte (MSG_ONE, '[');
        for(i = 0; i < 10; i = i + 1)
        {
            if (i == current_meter)
            {
                WriteByte (MSG_ONE, 'q');
            }
            else
            {
                WriteByte (MSG_ONE, ' ');
            }
        }
        WriteByte (MSG_ONE, ']');
        WriteByte (MSG_ONE, '\n');
    }

    // Write format string
    if (cvar("scr_usekfont") == 0)
    {
        WriteString(MSG_ONE,"\x10{}\x11\n");
    }
    else
    {
        WriteString(MSG_ONE,"{}\n");
    }

    // Format string parameter
    WriteString(MSG_ONE,ftos(current_speed));

    // Everything after the format string parameters gets eaten

    // Terminating null byte
    WriteByte (MSG_ONE, 0);
}
