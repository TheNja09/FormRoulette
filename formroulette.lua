waitABit = 980
waitReset = 10
formTimer = 0
baseTimer = 101
function _OnFrame()
    World = ReadByte(Now + 0x00)
    Room = ReadByte(Now + 0x01)
    Place = ReadShort(Now + 0x00)
    Door = ReadShort(Now + 0x02)
    Map = ReadShort(Now + 0x04)
    Btl = ReadShort(Now + 0x06)
    Evt = ReadShort(Now + 0x08)
    Cheats()
end

function _OnInit()
    if GAME_ID == 0xF266B00B or GAME_ID == 0xFAF99301 and ENGINE_TYPE == "ENGINE" then--PCSX2
        Platform = 'PS2'
        Now = 0x032BAE0 --Current Location
        Save = 0x032BB30 --Save File
        Obj0 = 0x1C94100 --00objentry.bin
        Sys3 = 0x1CCB300 --03system.bin
        Btl0 = 0x1CE5D80 --00battle.bin
        Slot1 = 0x1C6C750 --Unit Slot 1
    elseif GAME_ID == 0x431219CC and ENGINE_TYPE == 'BACKEND' then--PC
        Platform = 'PC'
        Now = 0x0714DB8 - 0x56454E
        Save = 0x09A7070 - 0x56450E
        Obj0 = 0x2A22B90 - 0x56450E
        Sys3 = 0x2A59DB0 - 0x56450E
        Btl0 = 0x2A74840 - 0x56450E
        Slot1 = 0x2A20C58 - 0x56450E
    end
end

function Events(M,B,E) --Check for Map, Btl, and Evt
    return ((Map == M or not M) and (Btl == B or not B) and (Evt == E or not E))
end

function Cheats()
	WriteByte(0x24F5C38, 0)
	if ReadFloat(0xFFFFFFFFFFE9AA08) < 2 then
	WriteFloat(0xFFFFFFFFFFE9AA08, 3)
	end
	if ReadArray(0x24F5B48) ~= {00, 00, 00, 00} then
		waitReset = waitReset - 1
		if waitReset == 0 then
			WriteArray(0x24F5B48, {00, 00, 00, 00})
			waitReset = 30
		end
	end
	if baseTimer == 2 and ReadByte(0x444861) ~= 13 and ReadByte(0x24AA5B6) > 0 then
	chooseDrive = math.random(1,6)
	elseif baseTimer == 2 and ReadByte(0x444861) ~= 13 and ReadByte(0x24AA5B6) == 0 then
	chooseDrive = math.random(1,5)
	elseif baseTimer == 2 and ReadByte(0x444861) == 13 and ReadByte(0x24AA5B6) > 0 then
	chooseDrive = math.random(2,6)
	elseif baseTimer == 2 and ReadByte(0x444861) == 13 and ReadByte(0x24AA5B6) == 0 then
	chooseDrive = math.random(2,5)
	end
	if baseTimer == 1 and ReadByte(0x24A96B6) == 0 and ReadByte(Save+0x3524) == 0 and ReadShort(Now+0) ~= 0x0E07 and ReadShort(Now+0) ~= 0x0507 and ReadShort(Now+0) ~= 0x1A12 and ReadShort(Now+0) ~= 0x1712 and ReadByte(Now+0) ~= 0x0A then
		if chooseDrive == 1 then
		WriteArray(0x24F5B48, {04, 00, 01, 00}) -- Force Valor Form
		elseif chooseDrive == 2 then
		WriteArray(0x24F5B48, {04, 00, 02, 00}) -- Force Wisdom Form
		elseif chooseDrive == 3 then
		WriteArray(0x24F5B48, {04, 00, 03, 00}) -- Force Limit Form
		elseif chooseDrive == 4 then
		WriteArray(0x24F5B48, {04, 00, 04, 00}) -- Force Master Form
		elseif chooseDrive == 5 then
		WriteArray(0x24F5B48, {04, 00, 05, 00}) -- Force Final Form
		elseif chooseDrive == 6 then
		WriteArray(0x24F5B48, {04, 00, 06, 00}) -- Force Anti Form
		end
	end
	if ReadByte(Save+0x3524) == 0 and baseTimer > 0 then
	baseTimer = baseTimer - 1
	end
	if baseTimer == 0 then
	baseTimer = 3
	end
end
