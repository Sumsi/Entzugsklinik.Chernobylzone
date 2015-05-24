disableSerialization;

_mode = _this select 0;

_display = findDisplay 6000;
_houseListbox    = _display displayCtrl 6003;
_ownInvListbox   = _display displayCtrl 6013;
_hausClassname   = _display displayCtrl 6001;
_hausAmount      = _display displayCtrl 6002;
_ownInvClassname = _display displayCtrl 6011;
_ownInvAmount    = _display displayCtrl 6012;

_index1 = lbCurSel _houseListbox;
_index2 = lbCurSel _ownInvListbox;

curHouse = cursorTarget;

_pid = (curHouse getVariable "inUse") select 1;

if (_pid!=getplayerUID player) exitWith { hint parseText "<t color='#FF0000' size='1'>Das Inventar wurde durch den Anti-Dupeschutz geschlossen!";curHouse setVariable ["inUse",[false,""],true];closeDialog 0; };

_selClassname1 = _houseListbox lbData _index1;
_selClassname2 = _ownInvListbox lbData _index2;

if (_pid==getplayerUID player) then {
	switch (_mode) do {
		case 0 : {
			if (_selClassname1 == "") exitWith {};
			_house = cursorTarget;
			_content = _house getVariable "content";
			_index = -1;
			_wasRemoved = false;
			_wasHandled = false;
			{
				_index = _index + 1;
				if (_x select 0 == _selClassname1 AND _selClassname1 != "B_supplyCrate_F" AND _selClassname1 != "Box_IND_AmmoVeh_F" AND _selClassname1 != "Box_IND_WpsSpecial_F" AND _selClassname1 != "Box_IND_Grenades_F") then {

					_uniformWasMoved = false;
					_canBeRemoved = true;


					/*if (_selClassname1 in arma3_weapons AND !_wasHandled) then { player addWeapon _selClassname1;_wasHandled = true; };
					if (_selClassname1 in arma3_backpacks AND !_wasHandled) then { player addBackpack _selClassname1;_wasHandled = true; };
					if (_selClassname1 in arma3_magazines AND !_wasHandled) then {
						if (!_wasHandled) then {
							if (player canAdd _selClassname1) then {
								player addMagazine _selClassname1;
								_wasHandled = true;
							} else { _canBeRemoved = false;_wasHandled = true; };
						};
					};

					if !(_wasHandled) then {
						if (player canAdd _selClassname1) then {
							player addItem _selClassname1;
							//player assignItem _selClassname1;
						} else { _canBeRemoved = false; };
					};*/
					
					[_selClassname1,true] spawn life_fnc_handleItem;

					if (_canBeRemoved AND !_wasRemoved) then {
						if (((_content select _index select 1)-1)==0) then {
							_content deleteAt _index;
							cursorTarget setVariable ["content",_content,true];
							_wasRemoved = true;
						} else {
							_content set [_index,[_selClassname1,((_content select _index select 1)-1)]];
							cursorTarget setVariable ["content",_content,true];
							_wasRemoved = true;
						};
					} else {
						_item = [_selClassname1] call VAS_fnc_fetchCfgDetails;
						hint format ["Du hast keinen Platz in deinem Inventar fuer: %1",_item select 1];
					};
				};
			} forEach _content;
		};
		case 1 : {
			if (_selClassname2 == "") exitWith {};
			_house = cursorTarget;
			_content = _house getVariable "content";

			_boxslotsused = 0;
				{
					if (_x select 0 in ["B_supplyCrate_F","Box_IND_AmmoVeh_F","Box_IND_WpsSpecial_F","Box_IND_Grenades_F"]) then {} else {
								_boxslotsused = _boxslotsused + (_x select 1);
						};
				} forEach _content;

			if ((_boxslotsused+1) <= curHouseSpace) then {

					_wasHandled = false;

					/*_details = [_selClassname1] call life_fnc_fetchCfgDetails;
					switch (_details select 6) do
					{
						case "CfgGlasses": {if(_selClassname2 == goggles player) then {removeGoggles player;} else {player removeItem _item;};_wasHandled=true;};
					};

					if (!_wasHandled AND _selClassname2 in ["GrenadeHand_stone"]) then {player removeMagazine _selClassname2; _wasHandled = true;};
					if (!_wasHandled AND _selClassname2 in arma3_weapons AND (currentWeapon player != _selClassname2) AND (uniform player != _selClassname2) AND (vest player != _selClassname2) AND !(_selClassname1 in (assignedItems player))) then { player removeItem _selClassname2; _wasHandled = true;};
					if (!_wasHandled AND _selClassname2 in arma3_magazines) then { player removeMagazine _selClassname2; _wasHandled = true;};
					if (!_wasHandled AND _selClassname2 in arma3_items && (_selClassname2 != vest player) && (_selClassname2 != uniform player)) then { player removeItem _selClassname2; _wasHandled = true;};
					if (!_wasHandled AND _selClassname2 in arma3_backpacks) then { removeBackpackGlobal player; _wasHandled = true;};
					if (!_wasHandled) then
					{
						if (_selClassname2==currentWeapon player) then { player removeWeapon _selClassname2; };
						if (_selClassname2==vest player) then { removeVest player; };
						if (_selClassname2==uniform player) then { removeUniform player; }
					};*/
					
				[_selClassname2,false] spawn life_fnc_handleItem;

				_wasInArray = false;
				_index = -1;
				{
					_index = _index + 1;
					if (_x select 0 == _selClassname2) then {
						_wasInArray = true;
						_content set [_index,[_selClassname2,((_content select _index select 1)+1)]];
						cursorTarget setVariable ["content",_content,true];
					};
				} forEach _content;
				if (!_wasInArray) then {_content pushBack [_selClassname2,1];cursorTarget setVariable ["content",_content,true];};
			} else {
				if (true) exitWith {hint "Das Haus ist voll!"};
			};
		};
	};

	//closeDialog 0;

	if (true) then {[] spawn life_fnc_openHouseVInv;};
};

[] spawn {
	sleep 0.1;
	if (isNull (findDisplay 6000)) then {
		[] call SOCK_fnc_updateRequest;
		[[curHouse],"TON_fnc_updateHouseContainers",false,false] call life_fnc_MP;
		curHouse setVariable ["inUse",[false,""],true];
		life_houseInUse = false;
	} else {
		sleep 0.1;
		if (isNull (findDisplay 6000)) then {
			[] call SOCK_fnc_updateRequest;
			[[curHouse],"TON_fnc_updateHouseContainers",false,false] call life_fnc_MP;
			curHouse setVariable ["inUse",[false,""],true];
			life_houseInUse = false;
		} else {};
	};
};