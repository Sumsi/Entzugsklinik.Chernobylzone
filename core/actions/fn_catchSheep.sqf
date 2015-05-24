/*
	File: fn_catchTurtle.sqf
	Author: Bryan "Tonic" Boardwine
	
	Description:
	Catches a dead turtle?
*/
private["_obj"];
_obj = cursorTarget;
if(isNull _obj) exitWith {}; //Not valid
if(alive _obj) exitWith {}; //It's alive, don't take it charlie!

if(([true,"sheepraw",1] call life_fnc_handleInv)) then
{
	deleteVehicle _obj;
	titleText["Du hast etwas Schaafsfleisch genommen.", "PLAIN"];
};