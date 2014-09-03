//Including a_samp is required for all the SAMP functions
#include <a_samp>

//here we can define some variables, these are PRE-PROCESSOR variables and cant be changed after compilation
#define     		SERVER_NAME     		"Lilly's Deathmatch"
#define 			COLOR_WHITE 			0xFFFFFFAA
#define 			COLOR_LIGHTRED 			0xFF6347AA
#define 			COLOR_REALRED 			0xFF0606FF

enum g_ePlayer
{
	p_iKills,
	p_iDeaths,
	p_aGuns[12] //This will be used to store weapons server-side so players can't hack weapons, however we won't completely set this up.
}

new g_arrPlayers[MAX_PLAYERS][g_ePlayer]; //creates an array the size of MAX_PLAYERS containing info found in g_ePlayer enum
new g_iClassCam[MAX_PLAYERS]; //an array that is used to hold a variable for each player, hence the size of MAX_PLAYERS

//stock function to clear all player vairables
stock FlushPlayerVars(playerid)
{
	g_arrPlayers[playerid][p_iKills] = 0;
	g_arrPlayers[playerid][p_iDeaths] = 0;
	g_iClassCam[playerid] = 0;
	for(new i = 0; i < 12; i++)
	{
		g_arrPlayers[playerid][p_aGuns][i] = 0;
	}
}

//this stock function checks the weapon id and returns the slot id that it belongs in
stock GetWeaponSlot(iWeapon)
{
	switch(iWeapon) 
	{
		case 0, 1:
			return 0;
		case 2, 3, 4, 5, 6, 7, 8, 9:
			return 1;
		case 22, 23, 24:
			return 2;
		case 25, 26, 27:
			return 3;
		case 28, 29, 32:
			return 4;
		case 30, 31:
			return 5;
		case 33, 34:
			return 6;
		case 35, 36, 37, 38:
			return 7;
		case 16, 17, 18, 39, 40:
			return 8;
		case 41, 42, 43:
			return 9;
		case 10, 11, 12, 13, 14, 15:
			return 10;
		case 44, 45, 46:
			return 11;
	}
	return -1;
}

//main() is called when the gamemode launches
main()
{
	print("\n----------------------------------");
	print(SERVER_NAME" written by Lilly!"); //adds the define 'SERVER_NAME' in front of the ' written by Lilly'
	print("----------------------------------\n");
}

//OnGameModeInit is also called when the gamemode launches and is the usual location for startup code
public OnGameModeInit()
{
	//This is what shows in the 'Mode' in the SAMP browser
	SetGameModeText("Lilly's Deathmatch");
	EnableStuntBonusForAll(0); //disables stunt bonuses from vehicles
	DisableInteriorEnterExits(); //disables the singleplayer doors
	SetNameTagDrawDistance(45.0); //sets the default name tag distance
	AllowInteriorWeapons(1); //allows weapons inside interiors
	UsePlayerPedAnims(); //tells every skin to use the CJ animation

	//10 classes with first 10 skins, no guns or ammo
	AddPlayerClass(0, -2720.2239, 127.6736, 7.0391, 266.1427, 0, 0, 0, 0, 0, 0);
	AddPlayerClass(1, -2720.2239, 127.6736, 7.0391, 266.1427, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(2, -2720.2239, 127.6736, 7.0391, 266.1427, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(3, -2720.2239, 127.6736, 7.0391, 266.1427, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(4, -2720.2239, 127.6736, 7.0391, 266.1427, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(5, -2720.2239, 127.6736, 7.0391, 266.1427, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(6, -2720.2239, 127.6736, 7.0391, 266.1427, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(7, -2720.2239, 127.6736, 7.0391, 266.1427, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(8, -2720.2239, 127.6736, 7.0391, 266.1427, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(9, -2720.2239, 127.6736, 7.0391, 266.1427, 0, 0, 0, 0, 0, 0);
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	SetPlayerColor(playerid, COLOR_WHITE);
	FlushPlayerVars(playerid);
	SendClientMessage(playerid, COLOR_WHITE, "Welcome to "SERVER_NAME"!"); //adds 'SERVER_NAME' into the text
	return 1;
}

public OnPlayerDisconnect(playerid)
{
    FlushPlayerVars(playerid);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    SendDeathMessage(killerid, playerid, reason); //sends the message to the little death box on the right
	g_arrPlayers[playerid][p_iDeaths]++; //adds a death to the player
	if(killerid != INVALID_PLAYER_ID) 
	{
		g_arrPlayers[killerid][p_iKills]++; //checks if it is a player before adding a kill
		SetPlayerScore(killerid, g_arrPlayers[killerid][p_iKills]); //sets their scoreboard score to their kills
		if(reason < 43) //if the reason is a players weapon (43 is a camera, 42 is the last 'weapon' that can kill people
		{
			if(reason != 19 && reason != 20 && reason != 21) //these aren't weapons and shouldnt be classified as so, we check that these weren't somehow called
			{
				new iSlot = GetWeaponSlot(reason); //gets the slot of the weapon the player killed with
				SetPlayerArmedWeapon(killerid, g_arrPlayers[killerid][p_aGuns][iSlot]); //sets their armed weapon to the weapon they killed with so we can get the correct weapons ammo
				new iAmmo = GetPlayerAmmo(killerid); //get the ammo from the player (no option for specific slot, only player)
		  		switch(iSlot)
				{
				    //This adds the specified amount of ammo to the weapon in the slot
				    
				    //Slots 0 and 1 are melee
					case 2: SetPlayerAmmo(killerid, iSlot, iAmmo+25); //pistol
					case 3: SetPlayerAmmo(killerid, iSlot, iAmmo+25); //shotgun
					case 4: SetPlayerAmmo(killerid, iSlot, iAmmo+50); //smg
					case 5: SetPlayerAmmo(killerid, iSlot, iAmmo+300); //assault rifle
					case 6: SetPlayerAmmo(killerid, iSlot, iAmmo+15); //rifle
				}
			}
		}
	}
	ResetPlayerWeapons(playerid); //resets the players weapon
	return 1;
}

public OnPlayerSpawn(playerid)
{
	SetPlayerVirtualWorld(playerid, 0); //sets the VW to 0 so they can see other players
    g_iClassCam[playerid] = 0; //sets the class camera variable to 0 as they aren't selecting a class anymore
    ResetPlayerWeapons(playerid); //resets the players weapon
	//This can be shortened to 'g_arrPlayers[playerid][p_aGuns][GetWeaponSlot(24)] = 24;' however it isn't as readable
	new iSlot; //creates a new variable called iSlot
	iSlot = GetWeaponSlot(24); //stores the weapon slot for a deagle
	g_arrPlayers[playerid][p_aGuns][iSlot] = 24; //tells the server the player has a deagle in the correct slot
	iSlot = GetWeaponSlot(25); //stores the weapon slot for a shotgun
	g_arrPlayers[playerid][p_aGuns][iSlot] = 25; //tells the server the player has a shotgun in the correct lost
	GivePlayerWeapon(playerid, 24, 20); //deagle with 20 bullets
	GivePlayerWeapon(playerid, 25, 50); //shotgun with 50 bullets
	GameTextForPlayer(playerid, "~w~You have now~n~Spawned!", 5000, 1); //GameTextForPlayer with a 5000ms show timer, however type 1 is 8 seconds independant of specified time
	return 1;
}

public OnPlayerRequestClass(playerid)
{
	if(g_iClassCam[playerid] != 1)
	{
	    //sets the camera position to look at the player selecting the class
	    SetPlayerPos(playerid, -2720.2239, 127.6736, 7.0391);
	    SetPlayerVirtualWorld(playerid, 1); //changes the virtual world to 1 so players dont kill them
	    SetPlayerFacingAngle(playerid, 266.1427); //sets the angle the player is facing so they are looking at the camera
		SetPlayerCameraPos(playerid, -2712.9026, 127.7270, 8.6155);
		SetPlayerCameraLookAt(playerid, -2713.9053, 127.7203, 8.4305);
		g_iClassCam[playerid] = 1;  //sets the class camera variable 1 while we select a class so this isnt repeated
	}
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/stats", true))
    {
        new
		szString[24+MAX_PLAYER_NAME], //this string is 24 characters + MAX_PLAYER_NAME, allowing enough room for all 3 strings to be formatted
		szPlayername[MAX_PLAYER_NAME+1];
		
		GetPlayerName(playerid, szPlayername, sizeof(szPlayername)); //sizeof function returns the size of the array, in this case 25 (MAX_PLAYER_NAME is 24 + 1 character for null or \0)
        format(szString, sizeof(szString), "Stats for player %s.", szPlayername); //formats the specified text into szString
        SendClientMessage(playerid, COLOR_WHITE, szString); //SendClientMessage sends a message to the specified player id, in this case the person who did the command
        format(szString, sizeof(szString), "Kills: %d", g_arrPlayers[playerid][p_iKills]); //formatting again replaces the old string with this text
        SendClientMessage(playerid, COLOR_WHITE, szString);
        format(szString, sizeof(szString), "Deaths: %d", g_arrPlayers[playerid][p_iDeaths]); //formatting again replaces the old string with this text
        SendClientMessage(playerid, COLOR_WHITE, szString);
        return 1;
    }
    return 0;
}
