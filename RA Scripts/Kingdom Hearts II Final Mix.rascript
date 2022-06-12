// Kingdom Hearts II: Final Mix
// #ID = 2781

function Delta(mem) => prev(mem)

areas = {
    65535: { "worldId": 255, "name": "Title", "display": "On the title screen…", "areaId": 255, "hideWorld": 1, },523: { "worldId": 2, "name": "SunsetStation", "display": "Sunset Station", "areaId": 11, "hideWorld": 0, },522: { "worldId": 2, "name": "SunsetTerrace", "display": "Sunset Terrace", "areaId": 10, "hideWorld": 0, },548: { "worldId": 2, "name": "Tunnelway", "display": "Tunnelway", "areaId": 36, "hideWorld": 0, },524: { "worldId": 2, "name": "SunsetHill", "display": "Sunset Hill", "areaId": 12, "hideWorld": 0, },520: { "worldId": 2, "name": "StationPlaza", "display": "Station Plaza", "areaId": 8, "hideWorld": 0, },518: { "worldId": 2, "name": "StationHeights", "display": "Market Street: Station Heights", "areaId": 6, "hideWorld": 0, },515: { "worldId": 2, "name": "BackAlley", "display": "Back Alley", "areaId": 3, "hideWorld": 0, },514: { "worldId": 2, "name": "UsualSpot", "display": "The Usual Spot", "areaId": 2, "hideWorld": 0, },516: { "worldId": 2, "name": "Sandlot", "display": "Sandlot", "areaId": 4, "hideWorld": 0, },519: { "worldId": 2, "name": "TramCommon", "display": "Market Street: Tram Common", "areaId": 7, "hideWorld": 0, },525: { "worldId": 2, "name": "Woods", "display": "The Woods", "areaId": 13, "hideWorld": 0, },513: { "worldId": 2, "name": "RoxasRoom", "display": "Roxas’s Room", "areaId": 1, "hideWorld": 0, },526: { "worldId": 2, "name": "Courtyard", "display": "Mansion: Courtyard", "areaId": 14, "hideWorld": 0, },527: { "worldId": 2, "name": "Foyer", "display": "Mansion: Foyer", "areaId": 15, "hideWorld": 0, },530: { "worldId": 2, "name": "WhiteRoom", "display": "Mansion: The White Room", "areaId": 18, "hideWorld": 0, },529: { "worldId": 2, "name": "Library", "display": "Mansion: Library", "areaId": 17, "hideWorld": 0, },533: { "worldId": 2, "name": "ComputerRoom", "display": "Mansion: Computer Room", "areaId": 21, "hideWorld": 0, },531: { "worldId": 2, "name": "BasementHall", "display": "Mansion: Basement Hall", "areaId": 19, "hideWorld": 0, },532: { "worldId": 2, "name": "BasementHallAxel", "display": "Mansion: Basement Hall", "areaId": 20, "hideWorld": 0, },534: { "worldId": 2, "name": "BasementCorridor", "display": "Mansion: Basement Corridor", "areaId": 22, "hideWorld": 0, },535: { "worldId": 2, "name": "PodRoom", "display": "Mansion: Pod Room", "areaId": 23, "hideWorld": 0, },544: { "worldId": 2, "name": "StationOfSerenity", "display": "Station of Serenity", "areaId": 32, "hideWorld": 1, },545: { "worldId": 2, "name": "StationOfCalling", "display": "Station of Calling", "areaId": 33, "hideWorld": 1, },546: { "worldId": 2, "name": "StationOfAwakening", "display": "Station of Awakening", "areaId": 34, "hideWorld": 1, },
}

worlds = {
    1: "End of Sea",
2: "Twilight Town",
3: "Destiny Islands",
4: "Hollow Bastion",
5: "Beast's Castle",
6: "Olympus Coliseum",
7: "Agrabah",
8: "Land of Dragons",
9: "100-Acre Wood",
10: "Pride Lands",
11: "Atlantica",
12: "Disney Castle",
13: "Timeless River",
14: "",
15: "World Map",
16: "Port Royal",
17: "Space Paranoids",
19: "The World That Never Was",
}

function areaId() => byte(0x32bae1)
function worldId() => byte(0x32bae0)
function level() => byte(0x32e02f)

function GetLocationByName(name)
{
    for i in areas
    {
        area = areas[i]
        if (area["name"] == name)
        {
            return area
        }
    }
}

function GetWorldIdByName(name)
{
    for i in worlds
    {
        world = worlds[i]
        if (world == name)
        {
            return i
        }
    }
}

function IsInLocation(name)
{
    area = GetLocationByName(name)
    return areaId() == area["areaId"] && worldId() == area["worldId"]
}

function IsInWorld(name)
{
    world = GetWorldIdByName(name)
    return worldId() == world
}

function WasInLocation(name)
{
    area = GetLocationByName(name)
    return Delta(areaId()) == area["areaId"] && Delta(worldId()) == area["worldId"]
}

function GetAreaRPLookup()
{
    ret = {}
    for hash in areas
    {
        area = areas[hash]
        ret[hash] = area["display"]
    }
    return ret
}

function playTime() => dword(0x32df74)

function GetWorldById(worldId)
{
    for i in worlds
    {
        if (i == worldId)
        {
            return worlds[i]
        }
    }
    return ""
}

function GetRPWorldLookup()
{
    groups = {}
    
    for hash in areas
    {
        area = areas[hash]
        
        if (area["hideWorld"] == 1)
        {
            groups[hash] = ""
        }
        else
        {
            groups[hash] = GetWorldById(area["worldId"]) + ": "
        }
    }
    
    return groups
} 

function IsOnTitleScreen() => IsInLocation("Title")

function GetAreaHash(areaId, worldId) => areaId + worldId * 256

rich_presence_conditional_display(!IsOnTitleScreen(), "Level {0} | {1}{2} | Play time: {3}",
    //rich_presence_lookup("Characters", currentCharacter(), CharacterIdToNames()),
    rich_presence_value("Level", level(), "VALUE"),
    rich_presence_lookup("WorldDisplay", GetAreaHash(areaId(), worldId()), GetRPWorldLookup()),
    rich_presence_lookup("Areas", GetAreaHash(areaId(), worldId()), GetAreaRPLookup()),
    rich_presence_value("Play Time", playTime() / 60, "SECS")
)

rich_presence_conditional_display(IsOnTitleScreen(), "On the title screen...")

rich_presence_display("Somewhere in the World...")

function fieldPointer() => dword(0x348754)
function fieldActionId() => dword(fieldPointer() + 0x154)
function IsActiveInTheField() => fieldPointer() != 0
function JustBecameActiveInTheField() => Delta(fieldPointer()) == 0 && IsActiveInTheField()

function IsDead() => fieldActionId() == 0x36
function IdleWithSkateboard() => fieldActionId() == 0xfc
function LandedWithSkateboard() => fieldActionId() == 0x101
function JustDidActionWithId(id) => fieldActionId() == id && Delta(fieldActionId()) != id
function DidMethodGrab() => once(JustDidActionWithId(0x109))
function DidHeelflip() => once(JustDidActionWithId(0x10a))
function Did360DegreeSpin() => once(JustDidActionWithId(0x10b))
function DidAirWalk() => once(JustDidActionWithId(0x10c))
function JustDidGrind() => JustDidActionWithId(0x10d)

function bonusLevel() => byte(0x32f230)
function BonusObtained() => Delta(bonusLevel()) + 1 == bonusLevel()

function eventId() => byte(0x32bae8)
function BattleCheckpointReached(location, eventId)
{
    return never(!IsActiveInTheField()) && never(!IsInLocation(location)) && never(IsDead())
        && once(eventId() == eventId && IsActiveInTheField() && IsInLocation(location) && JustBecameActiveInTheField())
}

achievement(title = "Doing Everything I Can", description = "Perform all three different aerial skateboard tricks before touching the ground.", points = 1,
    trigger = IsActiveInTheField() && tally(3, [ DidMethodGrab(), Did360DegreeSpin(), DidAirWalk() ])
        && never(LandedWithSkateboard()) && never(JustDidGrind()) && never(IdleWithSkateboard()) && IsInWorld("Twilight Town")
)

achievement(title = "We Tech Those [m]", description = "Finish off the Twilight Thorn with the Break Raid Reaction Command.", points = 10,
    trigger = BattleCheckpointReached(location = "StationOfAwakening", eventId = 0x9d)
        && trigger_when(fieldActionId() == 0x102 && BonusObtained())
)