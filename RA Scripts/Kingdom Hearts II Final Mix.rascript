// Kingdom Hearts II: Final Mix
// #ID = 2781

function Delta(mem) => prev(mem)

areas = {
    65535: { "worldId": 255, "name": "Title", "display": "On the title screen…", "areaId": 255, "hideWorld": 1, },523: { "worldId": 2, "name": "SunsetStation", "display": "Sunset Station", "areaId": 11, "hideWorld": 0, },522: { "worldId": 2, "name": "SunsetTerrace", "display": "Sunset Terrace", "areaId": 10, "hideWorld": 0, },548: { "worldId": 2, "name": "Tunnelway", "display": "Tunnelway", "areaId": 36, "hideWorld": 0, },524: { "worldId": 2, "name": "SunsetHill", "display": "Sunset Hill", "areaId": 12, "hideWorld": 0, },520: { "worldId": 2, "name": "StationPlaza", "display": "Station Plaza", "areaId": 8, "hideWorld": 0, },518: { "worldId": 2, "name": "StationHeights", "display": "Market Street: Station Heights", "areaId": 6, "hideWorld": 0, },515: { "worldId": 2, "name": "BackAlley", "display": "Back Alley", "areaId": 3, "hideWorld": 0, },514: { "worldId": 2, "name": "UsualSpot", "display": "The Usual Spot", "areaId": 2, "hideWorld": 0, },516: { "worldId": 2, "name": "Sandlot", "display": "Sandlot", "areaId": 4, "hideWorld": 0, },519: { "worldId": 2, "name": "TramCommon", "display": "Market Street: Tram Common", "areaId": 7, "hideWorld": 0, },525: { "worldId": 2, "name": "Woods", "display": "The Woods", "areaId": 13, "hideWorld": 0, },513: { "worldId": 2, "name": "RoxasRoom", "display": "Roxas’s Room", "areaId": 1, "hideWorld": 0, },526: { "worldId": 2, "name": "Courtyard", "display": "Mansion: Courtyard", "areaId": 14, "hideWorld": 0, },527: { "worldId": 2, "name": "Foyer", "display": "Mansion: Foyer", "areaId": 15, "hideWorld": 0, },530: { "worldId": 2, "name": "WhiteRoom", "display": "Mansion: The White Room", "areaId": 18, "hideWorld": 0, },529: { "worldId": 2, "name": "Library", "display": "Mansion: Library", "areaId": 17, "hideWorld": 0, },533: { "worldId": 2, "name": "ComputerRoom", "display": "Mansion: Computer Room", "areaId": 21, "hideWorld": 0, },531: { "worldId": 2, "name": "BasementHall", "display": "Mansion: Basement Hall", "areaId": 19, "hideWorld": 0, },532: { "worldId": 2, "name": "BasementHallAxel", "display": "Mansion: Basement Hall", "areaId": 20, "hideWorld": 0, },534: { "worldId": 2, "name": "BasementCorridor", "display": "Mansion: Basement Corridor", "areaId": 22, "hideWorld": 0, },535: { "worldId": 2, "name": "PodRoom", "display": "Mansion: Pod Room", "areaId": 23, "hideWorld": 0, },544: { "worldId": 2, "name": "StationOfSerenity", "display": "Station of Serenity", "areaId": 32, "hideWorld": 1, },545: { "worldId": 2, "name": "StationOfCalling", "display": "Station of Calling", "areaId": 33, "hideWorld": 1, },546: { "worldId": 2, "name": "StationOfAwakening", "display": "Station of Awakening", "areaId": 34, "hideWorld": 1, },517: { "worldId": 2, "name": "SandlotBattlefield", "display": "Sandlot", "areaId": 5, "hideWorld": 0, },521: { "worldId": 2, "name": "CentralStation", "display": "Central Station", "areaId": 9, "hideWorld": 0, },537: { "worldId": 2, "name": "Tower", "display": "The Tower", "areaId": 25, "hideWorld": 1, },541: { "worldId": 2, "name": "StarChamber", "display": "Tower: Star Chamber", "areaId": 29, "hideWorld": 1, },543: { "worldId": 2, "name": "WaywardStairs", "display": "Tower: Wayward Stairs", "areaId": 31, "hideWorld": 1, },550: { "worldId": 2, "name": "WaywardStairs2", "display": "Tower: Wayward Stairs", "areaId": 38, "hideWorld": 1, },542: { "worldId": 2, "name": "MoonChamber", "display": "Tower: Moon Chamber", "areaId": 30, "hideWorld": 1, },551: { "worldId": 2, "name": "WaywardStairs3", "display": "Tower: Wayward Stairs", "areaId": 39, "hideWorld": 1, },539: { "worldId": 2, "name": "SorcererLoft", "display": "Tower: Sorcerer’s Loft", "areaId": 27, "hideWorld": 1, },540: { "worldId": 2, "name": "Wardrobe", "display": "Tower: Wardrobe", "areaId": 28, "hideWorld": 1, },3840: { "worldId": 15, "name": "WorldMap", "display": "World Map", "areaId": 0, "hideWorld": 1, },1024: { "worldId": 4, "name": "VillainVale", "display": "Villain’s Vale", "areaId": 0, "hideWorld": 0, },1034: { "worldId": 4, "name": "Marketplace", "display": "Marketplace", "areaId": 10, "hideWorld": 0, },1033: { "worldId": 4, "name": "Borough", "display": "Borough", "areaId": 9, "hideWorld": 0, },1037: { "worldId": 4, "name": "Merlin", "display": "Merlin’s House", "areaId": 13, "hideWorld": 0, },2048: { "worldId": 8, "name": "BambooGrove", "display": "Bamboo Grove", "areaId": 0, "hideWorld": 0, },2049: { "worldId": 8, "name": "Encampment", "display": "Encampment", "areaId": 1, "hideWorld": 0, },2050: { "worldId": 8, "name": "Checkpoint", "display": "Checkpoint", "areaId": 2, "hideWorld": 0, },2052: { "worldId": 8, "name": "Village", "display": "Village", "areaId": 4, "hideWorld": 0, },2051: { "worldId": 8, "name": "MountainTrail", "display": "Mountain Trail", "areaId": 3, "hideWorld": 0, },2053: { "worldId": 8, "name": "VillageCave", "display": "Village Cave", "areaId": 5, "hideWorld": 0, },2060: { "worldId": 8, "name": "RuinedVillage", "display": "Village", "areaId": 12, "hideWorld": 0, },2054: { "worldId": 8, "name": "Ridge", "display": "Ridge", "areaId": 6, "hideWorld": 0, },2055: { "worldId": 8, "name": "Summit", "display": "Summit", "areaId": 7, "hideWorld": 0, },2056: { "worldId": 8, "name": "ImperialSquare", "display": "Imperial Square", "areaId": 8, "hideWorld": 0, },2057: { "worldId": 8, "name": "PalaceGate", "display": "Palace Gate", "areaId": 9, "hideWorld": 0, },1280: { "worldId": 5, "name": "EntranceHall", "display": "Entrance Hall", "areaId": 0, "hideWorld": 0, },1281: { "worldId": 5, "name": "Parlor", "display": "Parlor", "areaId": 1, "hideWorld": 0, },1286: { "worldId": 5, "name": "BeastCourtyard", "display": "Courtyard", "areaId": 6, "hideWorld": 0, },1282: { "worldId": 5, "name": "BelleRoom", "display": "Belle’s Room", "areaId": 2, "hideWorld": 0, },1287: { "worldId": 5, "name": "EastWing", "display": "The East Wing", "areaId": 7, "hideWorld": 0, },1284: { "worldId": 5, "name": "Ballroom", "display": "Ballroom", "areaId": 4, "hideWorld": 0, },1288: { "worldId": 5, "name": "WestHall", "display": "The West Hall", "areaId": 8, "hideWorld": 0, },1291: { "worldId": 5, "name": "Undercroft", "display": "Undercroft", "areaId": 11, "hideWorld": 0, },1290: { "worldId": 5, "name": "Dungeon", "display": "Dungeon", "areaId": 10, "hideWorld": 0, },1292: { "worldId": 5, "name": "SecretPassage", "display": "Secret Passage", "areaId": 12, "hideWorld": 0, },1289: { "worldId": 5, "name": "WestWing", "display": "The West Wing", "areaId": 9, "hideWorld": 0, },1283: { "worldId": 5, "name": "BeastRoom", "display": "The Beast’s Room", "areaId": 3, "hideWorld": 0, },1285: { "worldId": 5, "name": "BallroomBattle", "display": "Ballroom", "areaId": 5, "hideWorld": 0, },
}

worlds = {
    1: "End of Sea",
2: "Twilight Town",
3: "Destiny Islands",
4: "Hollow Bastion",
5: "Beast’s Castle",
6: "Olympus Coliseum",
7: "Agrabah",
8: "The Land of Dragons",
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

function difficulty() => byte(0x32dfc8)

function WasValueSet(mem, oldValue, newValue)
{
    return once(IsValueJustSet(mem, oldValue, newValue))
}

function IsValueJustSet(mem, oldValue, newValue)
{
    return Delta(mem) == oldValue && mem == newValue
}

function WasValueSetInGame(mem, oldValue, newValue)
{
    return IsAlwaysInGame() && WasValueSet(mem, oldValue, newValue)
}

function WasBitflagSetInGame(mem)
{
    return WasValueSetInGame(mem, 0, 1)
}

function menuPointer() => dword(0x35f0c0)
function MenuIsActive() => menuPointer() != 0
function gameStarted() => bit0(0x32d803)
function IsAlwaysInGame() => never(Delta(gameStarted()) == 0) && never(MenuIsActive())

function IsAtLeastOnDifficulty(value)
{
    if (value == "Beginner")
    {
        return difficulty() == 0
    }
    else if (value == "Standard")
    {
        return difficulty() >= 0x1
    }
    else if (value == "Proud")
    {
        return difficulty() >= 0x2
    }
    else if (value == "Critical")
    {
        return difficulty() >= 0x3
    }
}

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

function WasInLocation(name)
{
    area = GetLocationByName(name)
    return Delta(areaId()) == area["areaId"] && Delta(worldId()) == area["worldId"]
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
function reactionCommandId() => word(fieldPointer() + 0xb48)
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
function BattleCheckpointReached(location, eventId, when = always_true())
{
    return never(!IsActiveInTheField()) && never(!IsInLocation(location)) && never(IsDead())
        && once(eventId() == eventId && IsActiveInTheField() && IsInLocation(location) && JustBecameActiveInTheField() && when)
}

achievement(title = "Doing Everything I Can", description = "Perform all three different aerial skateboard tricks before touching the ground.", points = 1,
    trigger = IsActiveInTheField() && tally(3, [ DidMethodGrab(), Did360DegreeSpin(), DidAirWalk() ])
        && never(LandedWithSkateboard()) && never(JustDidGrind()) && never(IdleWithSkateboard()) && IsInWorld("Twilight Town")
)

achievement(title = "We Tech Those [m]", description = "Finish off the Twilight Thorn with the Break Raid reaction command.", points = 10,
    trigger = BattleCheckpointReached(location = "StationOfAwakening", eventId = 0x9d)
        // Note that IDs used may be used elsewhere in the game for different purposes. However, this ID is used in this particular area for this purpose and not for anything else.
        && trigger_when(fieldActionId() == 0x102 && BonusObtained())
)

function potionIndex() => 1
function UsedItem(itemIndex)
{
    trigger = always_false()
    playerItemSlotBaseAddr = 0x32e054
    for i in range(0, 7)
    {
        slot = word(playerItemSlotBaseAddr + 2 * i)
        trigger = trigger || Delta(slot) == itemIndex && slot == 0
    }
    
    return trigger
}

function UsedAnyItem()
{
    trigger = always_false()
    playerItemSlotBaseAddr = 0x32e054
    for i in range(0, 7)
    {
        slot = word(playerItemSlotBaseAddr + 2 * i)
        trigger = trigger || Delta(slot) != 0 && slot == 0
    }
    
    return trigger
}

achievement(title = "Third-Degree Burns [m]", description = "Defeat Axel in the old mansion basement without using items or reaction commands (Proud Mode or higher; Level 4 or below).", points = 10,
    trigger = BattleCheckpointReached(location = "BasementHallAxel", eventId = 0x89, when = level() <= 4 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(UsedAnyItem())
        && never(fieldActionId() == 0xfe) // Overtaker when playing as dual-wielding Roxas
        && never(fieldActionId() == 0xfc) // Burst Frontier
)

function prologueComplete() => bit4(0x32d812)
achievement(title = "Summer's End", description = "Complete the prologue.", points = 3,
    trigger = WasBitflagSetInGame(prologueComplete())
)

function samuraiNobodiesDefeated() => word(0x32f40c)
achievement(title = "You're Already Dead", description = "Defeat a Samurai Nobody using the Duel Stance reaction command.", points = 3,
    trigger = once(reactionCommandId() == 0x12d && Delta(reactionCommandId()) != 0x12d) && trigger_when(once(fieldActionId() == 0xfd && Delta(fieldActionId()) == 0xfc))
        && trigger_when(Delta(samuraiNobodiesDefeated()) < samuraiNobodiesDefeated()) && never(fieldActionId() != 0xfd && Delta(fieldActionId()) == 0xfd)
        && never(!IsActiveInTheField())
)

function currentMedalLevel() => byte(0x1f803c0)
achievement(title = "Like Lady Godiva", description = "Reach Medal Level 30 in any Gummi Ship mission.", points = 3,
    trigger = never(!IsInLocation("WorldMap")) && Delta(currentMedalLevel()) < 30 && currentMedalLevel() == 30
)

function redMeteorId() => 0x8e
achievement(title = "Bursting in Air [m]", description = "Finish off Shan-Yu with the Red Meteor Limit finisher (Proud Mode or higher; Level 10 or below; no rescues).", points = 10,
    trigger = BattleCheckpointReached(location = "PalaceGate", eventId = 0x4b, when = level() <= 10 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(reactionCommandId() == redMeteorId() && BonusObtained())
)

function landOfDragonsFirstVisitComplete() => bit2(0x32d8c2)
achievement(title = "Unquestionable Honor", description = "Complete the first visit to the Land of Dragons.", points = 3,
    trigger = WasBitflagSetInGame(landOfDragonsFirstVisitComplete()) && IsInLocation("WorldMap")
)

function currentForm() => byte(0x32f054)
function JustEnteredValorForm() => currentForm() == 1 && Delta(currentForm()) != 1
achievement(title = "Pure of Mind [m]", description = "Defeat the Thresholder and Possessor without using items or Valor Form (Proud Mode or higher; Level 13 or below; no rescues).", points = 5,
    trigger = BattleCheckpointReached(location = "Undercroft", eventId = 0x48, when = level() <= 13 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(UsedAnyItem()) && never(JustEnteredValorForm())
)

function limitPointer() => dword(0x1d48cb0)
function LimitIsBeingUsed() => limitPointer() != 0
achievement(title = "Silence Is Golden [m]", description = "Defeat the Dark Thorn without using Limits (Proud Mode or higher; Level 16 or below; no rescues).", points = 25,
    trigger = BattleCheckpointReached(location = "BallroomBattle", eventId = 0x4f, when = level() <= 16 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(LimitIsBeingUsed())
)

function beastCastleFirstVisitComplete() => bit7(0x32d861)
achievement(title = "Tending the Garden", description = "Complete the first visit to Beast's Castle.", points = 3,
    trigger = WasBitflagSetInGame(beastCastleFirstVisitComplete()) && IsInLocation("WorldMap")
)