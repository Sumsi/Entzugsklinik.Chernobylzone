/*
	File: fn_carSound_unlock.sqf
*/
private["_source"];
_source = [_this,0,ObjNull,[ObjNull]] call BIS_fnc_param;
if(isNull _source) exitWith {};

if(player distance _source < 40) then {
	_source say3D ["car_unlock", 0.2];
};