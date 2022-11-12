#include <a_samp>
#include <zcmd>
#include <sscanf2>
#define MSG SendClientMessage

new trigoCmds[][] = {
    "sinx",
    "cosy",
    "sinxcosy",
    "myface",
    "face"

};

new str[124];
public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" TrigoScript");
	print("--------------------------------------\n");

    for(new i = 0; i < sizeof trigoCmds; i++) {
        format(str, sizeof str, "/%s %s", trigoCmds[i], str);
    }
    SendClientMessageToAll(-1, str);
    str[0] = EOS;
	return 1;
}
/* Idea:
* Make job function immediately return a TASK
* This task should be a reference variable
* This reference will be filled in somewhere
* When its filled in, I call a callback saying: I am hea!
*/
// new mystuff;
new bool:showcoords;
new changingangle = 0;
public OnPlayerUpdate(playerid) {
	if(showcoords) { 
		new Float:x, Float:y, Float:z, Float:a;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);	
		format(str, sizeof str, "%f %f %f %f", x, y, z, a);
		MSG(playerid, 0x00FF00FF, str);
		if(changingangle == 360) {
			changingangle = 0;
			showcoords = false;
		}
		SetPlayerFacingAngle(playerid, changingangle);
		cmd_sinxcosy(playerid, "");
		changingangle++;
	}
}
public OnRconCommand(cmd[])
{
	if(!strcmp(cmd, "go", true)) {
		FunctionA();
	}
    return 0;
}

FunctionA() {
	new bfunc;
	printf("Doing something... %d", GetTickCount());
	bfunc = FunctionB();
	printf("%d", bfunc);
	printf("Doing something afterwards... %d", GetTickCount());
}

FunctionB() {
	
	return 1;
}
CMD:showcoords(playerid, params[]) {
	if(showcoords) { 
		showcoords = false;
	} else {
		showcoords = true;
	}
	return 1;
}
CMD:sinx(playerid, params[]) {
	new Float:x, Float:y, Float:z, Float:a;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);
	format(str, sizeof str, "SINb4: %f", x);
    MSG(playerid, -1, str);
	new Float:xorg = x;
	x += (1 * floatsin(-a, degrees));
	format(str, sizeof str, "SINafter: %f; difference: %f", x, xorg-x);
	MSG(playerid, -1, str);
	SetPlayerPos(playerid, x, y, z);
	return 1;
}
CMD:cosy(playerid, params[]) {
	new Float:x, Float:y, Float:z, Float:a;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);
	format(str, sizeof str, "COSb4: %f", x);
    MSG(playerid, -1, str);
	new Float:yorg = y;
	y += (1 * floatcos(-a, degrees));
	format(str, sizeof str, "COSafter: %f; difference: %f", y, yorg-y);
	MSG(playerid, -1, str);
	SetPlayerPos(playerid, x, y, z);
	return 1;
}

CMD:sinxcosy(playerid, params[]) {
	new Float:x, Float:y, Float:z, Float:a;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);
	// format(str, sizeof str, "SINCOSS b4: %f %f", x, y);
    // MSG(playerid, 0xff0000FF, str);
	x += (floatsin(-a, degrees));
	y += (floatcos(-a, degrees));
	// format(str, sizeof str, "SINCOSS after: %f %f", x, y);
	// MSG(playerid, 0xe50000FF, str);
	SetPlayerPos(playerid, x, y, z);
	return 1;
}
CMD:face(playerid, params[]) {
	new Float:angle;
	sscanf(params, "f", angle);
	SetPlayerFacingAngle(playerid, angle);
	format(str, sizeof str, "setangle %f", angle);
    MSG(playerid, -1, str);
	return 1;
}
CMD:myface(playerid, params[]) {
	new Float:angle;
	GetPlayerFacingAngle(playerid, angle);
	format(str, sizeof str, "curangle %f", angle);
    MSG(playerid, -1, str);
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}
