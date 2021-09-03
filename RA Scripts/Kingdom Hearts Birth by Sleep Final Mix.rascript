// Kingdom Hearts Birth by Sleep
// #ID = 3556

function True() => 1
function False() => 0

function Delta(mem) => prev(mem)

function SecondsToFormat(value)
{
    leadingZero = ""
    if (value % 60 < 10)
    {
        leadingZero = "0"
    }
    return value / 60 + ":" + leadingZero + value % 60
}

function SecondsToFrames(seconds) => seconds * 60

// $B47AC0: World ID
function worldId() => byte(0xB47AC0)

// $B47AC1: Room ID
function areaId() => byte(0xB47AC1)

// $1F2914A: First slot of the key item inventory (16-bit)
//           
//           Each value contains a key item ID. 0x0 when no item is in the slot.
//           
//           Every time the player views the inventory, the items in the buffer are "dumped" to the actual inventory, which appears to begin at another address.
function keyItemInventorySlot1Id() => word(0x1F2914A)

// $1F291AC: Last slot of the key item inventory (16-bit)
function keyItemInventoryLastSlotId() => word(0x1F291AC)

// $1F2927C: Bit 0: First chest in the Land of Departure
// $1F292A8: Bit 4: Earthshaker viewed in the inventory
// $1F29300: Bit 0: Wayfinder viewed in the inventory

// $1F29388: ID of the first command in the player's inventory (16-bit)
function slot1CommandID() => word(0x1F29388)

// $1F2938A: Level of the first command in the player's inventory (8-bit)
function slot1CommandLevel() => byte(0x1F2938A)

// $1F29392: ID of the second command in the player's inventory (16-bit)
function slot2CommandId() => word(0x1F29392)

// $1F2B91C: Index of the command equipped in Slot 1 (16-bit)
//           
//           Each index corresponds to a command instance in the player's inventory. 0xffff when there is no command installed in the slot.
function slot1CommandIndex() => word(0x1F2B91C)

// $1F2B922: Index of the command equipped in Slot 2 (16-bit)
function slot2CommandIndex() => word(0x1F2B922)

// $1F2B928: Index of the command equipped in Slot 3 (16-bit)
function slot3CommandIndex() => word(0x1F2B928)

// $1F2B92E: Index of the command equipped in Slot 4 (16-bit)
function slot4CommandIndex() => word(0x1F2B92E)

// $1F2B934: Index of the command equipped in Slot 5 (16-bit)
function slot5CommandIndex() => word(0x1F2B934)

function level() => byte(0x1f19b11)

function currentCharacter() => byte(0xb5a4bc)

// $1F35F80: Floods defeated (16-bit)
// $1F35F82: Scrappers defeated (16-bit)
// $1F35F84: Bruisers defeated (16-bit)
// $1F35F86: Red Hot Chilis defeated (16-bit)
// $1F35F88: Monotruckers defeated (16-bit)
// $1F35F8A: Thornbites defeated (16-bit)
// $1F35F8C: Shoegazers defeated (16-bit)
// $1F35F8E: Spiderchests defeated (16-bit)
// $1F35F90: Archravens defeated (16-bit)
// $1F35F92: Hareraisers defeated (16-bit)
// $1F35F94: Jellyshades defeated, part 1 (16-bit)
//           
//           The total is equal to the sum of this address and parts 2-4.
// $1F35F96: Jellyshades defeated, part 2 (16-bit)
//           
//           The total is equal to the sum of this address and parts 1, 3, and 4.
// $1F35F98: Jellyshades defeated, part 3 (16-bit)
//           
//           The total is equal to the sum of this address and parts 1, 2, and 4.
// $1F35F9A: Jellyshades defeated, part 4 (16-bit)
//           
//           The total is equal to the sum of this address and parts 1-3.
// $1F35F9C: Tank Topplers defeated (16-bit)
// $1F35F9E: Vile Phials defeated (16-bit)
// $1F35FA0: Sonic Blasters defeated, part 1 (16-bit)
//           
//           The total is equal to the sum of this address and 0x1f35fa2.
// $1F35FA2: Sonic Blasters defeated, part 2 (16-bit)
//           
//           The total is equal to the sum of this address and 0x1f35fa0.
// $1F35FA4: Triple Wreckers defeated, part 1 (16-bit)
//           
//           The total is equal to the sum of this and parts 2 and 3.
// $1F35FA6: Triple Wreckers defeated, part 2 (16-bit)
//           
//           The total is equal to the sum of this and parts 1 and 3.
// $1F35FA8: Triple Wreckers defeated, part 3 (16-bit)
//           
//           The total is equal to the sum of this and parts 1 and 2.
// $1F35FAA: Wild Bruisers defeated (16-bit)
// $1F35FAC: Blue Sea Salts defeated (16-bit)
// $1F35FAE: Yellow Mustards defeated (16-bit)
// $1F35FB0: Mandrakes defeated (16-bit)
// $1F35FB2: Buckle Bruisers defeated (16-bit)
// $1F35FB4: Chrono Twisters defeated (16-bit)
// $1F35FB6: Axe Flappers defeated (16-bit)
// $1F35FB8: Prize Pods defeated (16-bit)
// $1F35FBA: Glidewinders defeated, part 1 (16-bit)
//           
//           The total is the sum of the value of this address and parts 2 and 3.
// $1F35FBC: Glidewinders defeated, part 2 (16-bit)
//           
//           The total is the sum of the value of this address and parts 1 and 3.
// $1F35FBE: Glidewinders defeated, part 3 (16-bit)
//           
//           The total is the sum of the value of this address and parts 1 and 2.
// $1F35FC0: Blobmobs defeated (16-bit)
// $1F35FC4: Symphony Masters defeated (16-bit)
// $1F35FC8: Wheel Masters defeated (16-bit)
// $1F35FCA: Mimic Masters defeated (16-bit)
// $1F35FCC: Iron Imprisoner I's defeated (16-bit)
// $1F35FCE: Iron Imprisoner IIs defeated (16-bit)
// $1F35FD0: Iron Imprisoner IIIs defeated (16-bit)
// $1F35FD2: Iron Imprisoner IVs defeated (16-bit)


worlds = {
1: "The Land of Departure",
2: "Dwarf Woodlands",
3: "Castle of Dreams",
4: "Enchanted Dominion",
5: "The Mysterious Tower",
6: "Radiant Garden",
7: "Event",
8: "Olympus Coliseum",
9: "Deep Space",
10: "Destiny Islands",
11: "Neverland",
12: "Disney Town",
13: "Keyblade Graveyard",
14: "Event 2",
15: "Mirage Arena",
16: "Command Board",
17: "World Map",
19: "The 100-Acre Wood",
20: "The Badlands",
}

areas = {
0: { "worldId": 255, "name": "Title", "display": "On the title screen…", "areaId": 255, "hideWorld": 1, },1: { "worldId": 1, "name": "DepartureForecourtDay", "display": "Forecourt", "areaId": 1, "hideWorld": 0, },2: { "worldId": 1, "name": "DepartureGreatHall", "display": "Great Hall", "areaId": 2, "hideWorld": 0, },3: { "worldId": 1, "name": "VentusRoomDay", "display": "Ventus’s Room", "areaId": 3, "hideWorld": 0, },4: { "worldId": 1, "name": "VentusRoomNight", "display": "Ventus’s Room", "areaId": 4, "hideWorld": 0, },6: { "worldId": 1, "name": "DepartureMountainPath", "display": "Mountain Path", "areaId": 5, "hideWorld": 0, },7: { "worldId": 1, "name": "DepartureSummitNight", "display": "Summit", "areaId": 6, "hideWorld": 0, },8: { "worldId": 1, "name": "DepartureForecourtNight", "display": "Forecourt", "areaId": 7, "hideWorld": 0, },9: { "worldId": 1, "name": "DepartureForecourtRuins", "display": "Forecourt", "areaId": 8, "hideWorld": 0, },10: { "worldId": 1, "name": "DepartureGreatHallRuins", "display": "Great Hall", "areaId": 9, "hideWorld": 0, },11: { "worldId": 1, "name": "DepartureSummitRuins", "display": "Summit", "areaId": 10, "hideWorld": 0, },12: { "worldId": 1, "name": "ChamberOfWaking", "display": "Chamber of Waking", "areaId": 11, "hideWorld": 0, },13: { "worldId": 1, "name": "CastleOblivion", "display": "Castle Oblivion", "areaId": 12, "hideWorld": 0, },14: { "worldId": 1, "name": "CharacterSelect", "display": "Selecting a character…", "areaId": 13, "hideWorld": 1, },15: { "worldId": 1, "name": "DepartureForecourtRuins2", "display": "Forecourt", "areaId": 14, "hideWorld": 0, },16: { "worldId": 1, "name": "DepartureMountainPathRuins", "display": "Mountain Path", "areaId": 15, "hideWorld": 0, },17: { "worldId": 1, "name": "DepartureSummitRuins", "display": "Summit", "areaId": 16, "hideWorld": 0, },18: { "worldId": 2, "name": "DwarfMineEntrance", "display": "Mine Entrance", "areaId": 1, "hideWorld": 0, },19: { "worldId": 2, "name": "DwarfMine", "display": "The Mine", "areaId": 2, "hideWorld": 0, },20: { "worldId": 2, "name": "DwarfVault", "display": "Vault", "areaId": 3, "hideWorld": 0, },21: { "worldId": 2, "name": "DwarfMirrorChamber", "display": "Magic Mirror Chamber", "areaId": 4, "hideWorld": 0, },22: { "worldId": 2, "name": "DwarfWaterway", "display": "Underground Waterway", "areaId": 5, "hideWorld": 0, },23: { "worldId": 2, "name": "DwarfCourtyard", "display": "Courtyard", "areaId": 6, "hideWorld": 0, },24: { "worldId": 2, "name": "DwarfGlade", "display": "Flower Glade", "areaId": 7, "hideWorld": 0, },25: { "worldId": 2, "name": "DwarfWoods", "display": "Deep Woods", "areaId": 8, "hideWorld": 0, },26: { "worldId": 2, "name": "DwarfMirror", "display": "Inside the Magic Mirror", "areaId": 9, "hideWorld": 0, },27: { "worldId": 2, "name": "DwarfClearing", "display": "Cottage Clearing", "areaId": 10, "hideWorld": 0, },28: { "worldId": 2, "name": "DwarfCottage", "display": "The Cottage", "areaId": 11, "hideWorld": 0, },29: { "worldId": 2, "name": "DwarfMountainTrail", "display": "Mountain Trail", "areaId": 12, "hideWorld": 0, },30: { "worldId": 3, "name": "CastleHouse", "display": "Cinderella’s House", "areaId": 1, "hideWorld": 0, },31: { "worldId": 3, "name": "CastleMousehole", "display": "Mousehole", "areaId": 2, "hideWorld": 0, },32: { "worldId": 3, "name": "CastleWardrobe", "display": "Wardrobe Room", "areaId": 3, "hideWorld": 0, },33: { "worldId": 3, "name": "CastleEntrance", "display": "Entrance", "areaId": 4, "hideWorld": 0, },34: { "worldId": 3, "name": "CastleChateau", "display": "The Chateau", "areaId": 5, "hideWorld": 0, },35: { "worldId": 3, "name": "CastleForest", "display": "Forest", "areaId": 6, "hideWorld": 0, },36: { "worldId": 3, "name": "CastleCourtyard", "display": "Palace Courtyard", "areaId": 7, "hideWorld": 0, },37: { "worldId": 3, "name": "CastleCorridor", "display": "Corridor", "areaId": 8, "hideWorld": 0, },38: { "worldId": 3, "name": "CastleBallroom", "display": "Ballroom", "areaId": 9, "hideWorld": 0, },39: { "worldId": 3, "name": "CastleFoyer", "display": "Foyer", "areaId": 10, "hideWorld": 0, },40: { "worldId": 3, "name": "CastlePassage", "display": "Passage", "areaId": 11, "hideWorld": 0, },41: { "worldId": 3, "name": "CastleAntechamber", "display": "Antechamber", "areaId": 12, "hideWorld": 0, },42: { "worldId": 3, "name": "CastleWardrobe2", "display": "Wardrobe Room", "areaId": 13, "hideWorld": 0, },43: { "worldId": 3, "name": "CastleMousehole2", "display": "Mousehole", "areaId": 14, "hideWorld": 0, },44: { "worldId": 3, "name": "CastleWardrobe3", "display": "Wardrobe Room", "areaId": 15, "hideWorld": 0, },45: { "worldId": 4, "name": "EnchantedDungeonCell", "display": "Dungeon Cell", "areaId": 1, "hideWorld": 0, },46: { "worldId": 4, "name": "EnchantedGates", "display": "Gates", "areaId": 2, "hideWorld": 0, },47: { "worldId": 4, "name": "EnchantedThrone", "display": "Maleficent’s Throne", "areaId": 3, "hideWorld": 0, },48: { "worldId": 4, "name": "EnchantedDungeon", "display": "Dungeon", "areaId": 4, "hideWorld": 0, },49: { "worldId": 4, "name": "EnchantedHall1", "display": "Hall", "areaId": 5, "hideWorld": 0, },50: { "worldId": 4, "name": "EnchantedMountain", "display": "Forbidden Mountain", "areaId": 6, "hideWorld": 0, },51: { "worldId": 4, "name": "EnchantedWaterside", "display": "Waterside", "areaId": 7, "hideWorld": 0, },52: { "worldId": 4, "name": "EnchantedClearing", "display": "Forest Clearing", "areaId": 8, "hideWorld": 0, },53: { "worldId": 4, "name": "EnchantedBridge", "display": "Bridge", "areaId": 9, "hideWorld": 0, },54: { "worldId": 4, "name": "EnchantedBridgeThorns", "display": "Bridge", "areaId": 10, "hideWorld": 0, },55: { "worldId": 4, "name": "EnchantedAudience1", "display": "Audience Chamber", "areaId": 11, "hideWorld": 0, },56: { "worldId": 4, "name": "EnchantedAudience2", "display": "Audience Chamber", "areaId": 12, "hideWorld": 0, },57: { "worldId": 4, "name": "EnchantedReserved", "display": "Somewhere in the World…", "areaId": 13, "hideWorld": 1, },58: { "worldId": 4, "name": "EnchantedHallway", "display": "Hallway", "areaId": 14, "hideWorld": 0, },59: { "worldId": 4, "name": "EnchantedAurora", "display": "Aurora’s Chamber", "areaId": 15, "hideWorld": 0, },60: { "worldId": 4, "name": "EnchantedTower", "display": "Tower Room", "areaId": 16, "hideWorld": 0, },61: { "worldId": 4, "name": "EnchantedHall2", "display": "Hall", "areaId": 17, "hideWorld": 0, },62: { "worldId": 4, "name": "EnchantedAurora2", "display": "Aurora’s Chamber", "areaId": 18, "hideWorld": 0, },63: { "worldId": 4, "name": "EnchantedHall3", "display": "Hall", "areaId": 19, "hideWorld": 0, },64: { "worldId": 4, "name": "EnchantedHall4", "display": "Hall", "areaId": 20, "hideWorld": 0, },65: { "worldId": 4, "name": "EnchantedHall5", "display": "Hall", "areaId": 21, "hideWorld": 0, },66: { "worldId": 4, "name": "EnchantedHall6", "display": "Hall", "areaId": 22, "hideWorld": 0, },67: { "worldId": 4, "name": "EnchantedHall7", "display": "Hall", "areaId": 23, "hideWorld": 0, },68: { "worldId": 4, "name": "EnchantedHall8", "display": "Hall", "areaId": 24, "hideWorld": 0, },69: { "worldId": 4, "name": "EnchantedHall9", "display": "Hall", "areaId": 25, "hideWorld": 0, },70: { "worldId": 4, "name": "EnchantedHall10", "display": "Hall", "areaId": 26, "hideWorld": 0, },71: { "worldId": 4, "name": "EnchantedHall11", "display": "Hall", "areaId": 27, "hideWorld": 0, },72: { "worldId": 4, "name": "EnchantedHall12", "display": "Hall", "areaId": 28, "hideWorld": 0, },73: { "worldId": 4, "name": "EnchantedHall13", "display": "Hall", "areaId": 29, "hideWorld": 0, },74: { "worldId": 4, "name": "EnchantedHall14", "display": "Hall", "areaId": 30, "hideWorld": 0, },75: { "worldId": 4, "name": "EnchantedHall15", "display": "Hall", "areaId": 31, "hideWorld": 0, },76: { "worldId": 4, "name": "EnchantedHall16", "display": "Hall", "areaId": 32, "hideWorld": 0, },77: { "worldId": 4, "name": "EnchantedHall17", "display": "Hall", "areaId": 33, "hideWorld": 0, },78: { "worldId": 4, "name": "EnchantedHall18", "display": "Hall", "areaId": 34, "hideWorld": 0, },79: { "worldId": 4, "name": "EnchantedHall19", "display": "Hall", "areaId": 35, "hideWorld": 0, },80: { "worldId": 4, "name": "EnchantedHall20", "display": "Hall", "areaId": 36, "hideWorld": 0, },81: { "worldId": 4, "name": "EnchantedHall21", "display": "Hall", "areaId": 37, "hideWorld": 0, },82: { "worldId": 4, "name": "EnchantedHall22", "display": "Hall", "areaId": 38, "hideWorld": 0, },83: { "worldId": 4, "name": "EnchantedGates", "display": "Gates", "areaId": 39, "hideWorld": 0, },84: { "worldId": 5, "name": "MysteriousChamber", "display": "Sorcerer’s Chamber", "areaId": 1, "hideWorld": 0, },85: { "worldId": 5, "name": "MysteriousTower", "display": "Mysterious Tower", "areaId": 2, "hideWorld": 0, },86: { "worldId": 5, "name": "MysteriousEntrance", "display": "Tower Entrance", "areaId": 3, "hideWorld": 0, },87: { "worldId": 5, "name": "MysteriousChamber2", "display": "Sorcerer’s Chamber", "areaId": 4, "hideWorld": 0, },88: { "worldId": 6, "name": "RadiantOuterGardens", "display": "Outer Gardens", "areaId": 1, "hideWorld": 0, },89: { "worldId": 6, "name": "RadiantEntryway", "display": "Entryway", "areaId": 2, "hideWorld": 0, },90: { "worldId": 6, "name": "RadiantCentral", "display": "Central Square", "areaId": 3, "hideWorld": 0, },91: { "worldId": 6, "name": "RadiantAqueduct", "display": "Aqueduct", "areaId": 4, "hideWorld": 0, },92: { "worldId": 6, "name": "RadiantTown", "display": "Castle Town", "areaId": 5, "hideWorld": 0, },93: { "worldId": 6, "name": "RadiantReactor", "display": "Reactor", "areaId": 6, "hideWorld": 0, },94: { "worldId": 6, "name": "RadiantFountain", "display": "Fountain Court", "areaId": 7, "hideWorld": 0, },95: { "worldId": 6, "name": "RadiantMerlin", "display": "Merlin’s House", "areaId": 8, "hideWorld": 0, },96: { "worldId": 6, "name": "RadiantGardens", "display": "Gardens", "areaId": 9, "hideWorld": 0, },97: { "worldId": 6, "name": "RadiantDoors", "display": "Front Doors", "areaId": 10, "hideWorld": 0, },98: { "worldId": 6, "name": "RadiantPurification", "display": "Purification Facility", "areaId": 11, "hideWorld": 0, },99: { "worldId": 6, "name": "RadiantOuterGardens2", "display": "Outer Gardens", "areaId": 12, "hideWorld": 0, },100: { "worldId": 6, "name": "RadiantCentralDark", "display": "Central Square", "areaId": 13, "hideWorld": 0, },101: { "worldId": 6, "name": "RadiantCentralTerranort", "display": "Central Square", "areaId": 14, "hideWorld": 0, },102: { "worldId": 7, "name": "LouieCourt", "display": "Louie’s Ruins (Court)", "areaId": 1, "hideWorld": 0, },103: { "worldId": 7, "name": "LouiePath", "display": "Louie’s Ruins (Path)", "areaId": 2, "hideWorld": 0, },104: { "worldId": 7, "name": "Crossroad", "display": "Crossroad", "areaId": 3, "hideWorld": 0, },105: { "worldId": 7, "name": "UGRuinsEntrance", "display": "Underground Ruins (Entrance)", "areaId": 4, "hideWorld": 0, },106: { "worldId": 7, "name": "UGRuinsPassage1", "display": "Underground Ruins (Passage)", "areaId": 5, "hideWorld": 0, },107: { "worldId": 7, "name": "UGRuinsPassage2", "display": "Underground Ruins (Passage)", "areaId": 6, "hideWorld": 0, },108: { "worldId": 7, "name": "UGCourtyard", "display": "Underground Courtyard", "areaId": 7, "hideWorld": 0, },109: { "worldId": 7, "name": "JungleNearRuins", "display": "Jungle Near Ruins", "areaId": 8, "hideWorld": 0, },110: { "worldId": 7, "name": "Eminence", "display": "Eminence", "areaId": 9, "hideWorld": 0, },111: { "worldId": 7, "name": "Jungle", "display": "Jungle", "areaId": 10, "hideWorld": 0, },112: { "worldId": 7, "name": "River", "display": "Man-Village River", "areaId": 11, "hideWorld": 0, },113: { "worldId": 7, "name": "Bog", "display": "Bog", "areaId": 12, "hideWorld": 0, },114: { "worldId": 7, "name": "LanesBetween", "display": "The Lanes Between", "areaId": 50, "hideWorld": 0, },115: { "worldId": 7, "name": "Blank", "display": "Blank", "areaId": 51, "hideWorld": 0, },116: { "worldId": 7, "name": "Realm of Darkness", "display": "The Realm of Darkness", "areaId": 52, "hideWorld": 1, },117: { "worldId": 8, "name": "OlympusGates", "display": "Coliseum Gates", "areaId": 1, "hideWorld": 0, },118: { "worldId": 8, "name": "OlympusVestibule", "display": "Vestibule", "areaId": 2, "hideWorld": 0, },119: { "worldId": 8, "name": "OlympusWest", "display": "West Bracket", "areaId": 3, "hideWorld": 0, },120: { "worldId": 8, "name": "OlympusEast", "display": "East Bracket", "areaId": 4, "hideWorld": 0, },121: { "worldId": 8, "name": "OlympusTown", "display": "Town Near Thebes", "areaId": 5, "hideWorld": 0, },122: { "worldId": 8, "name": "OlympusEastNight", "display": "East Bracket", "areaId": 6, "hideWorld": 0, },123: { "worldId": 9, "name": "SpaceTuroBlock", "display": "Turo Prison Block", "areaId": 1, "hideWorld": 0, },124: { "worldId": 9, "name": "SpaceTuroTransporter", "display": "Turo Transporter", "areaId": 2, "hideWorld": 0, },125: { "worldId": 9, "name": "SpaceDurgonTransporter", "display": "Durgon Transporter", "areaId": 3, "hideWorld": 0, },126: { "worldId": 9, "name": "SpaceCorridor", "display": "Ship Corridor", "areaId": 4, "hideWorld": 0, },127: { "worldId": 9, "name": "SpaceControl", "display": "Control Room", "areaId": 5, "hideWorld": 0, },128: { "worldId": 9, "name": "SpacePod", "display": "Containment Pod", "areaId": 6, "hideWorld": 0, },129: { "worldId": 9, "name": "SpaceHub", "display": "Ship Hub", "areaId": 7, "hideWorld": 0, },130: { "worldId": 9, "name": "SpaceMachineryBay", "display": "Machinery Bay", "areaId": 8, "hideWorld": 0, },131: { "worldId": 9, "name": "SpaceLaunch", "display": "Launch Deck", "areaId": 9, "hideWorld": 0, },132: { "worldId": 9, "name": "SpaceExterior", "display": "Ship Exterior", "areaId": 10, "hideWorld": 0, },133: { "worldId": 9, "name": "SpaceOuter", "display": "Outer Space", "areaId": 11, "hideWorld": 0, },134: { "worldId": 9, "name": "SpaceCorridor2", "display": "Ship Corridor", "areaId": 12, "hideWorld": 0, },135: { "worldId": 9, "name": "SpaceLanesBetween", "display": "The Lanes Between", "areaId": 13, "hideWorld": 0, },136: { "worldId": 9, "name": "SpaceMachineryBayAccess", "display": "Machinery Bay Access", "areaId": 14, "hideWorld": 0, },137: { "worldId": 10, "name": "DestinyBeachDay", "display": "Island Beach", "areaId": 1, "hideWorld": 0, },138: { "worldId": 10, "name": "DestinyBeachSunset", "display": "Island Beach", "areaId": 2, "hideWorld": 0, },139: { "worldId": 10, "name": "DestinyBeachNight", "display": "Island Beach", "areaId": 3, "hideWorld": 0, },140: { "worldId": 10, "name": "DestinyMainIsland", "display": "Main Island Beach", "areaId": 4, "hideWorld": 0, },141: { "worldId": 11, "name": "NeverlandCove", "display": "Cove", "areaId": 1, "hideWorld": 0, },142: { "worldId": 11, "name": "NeverlandCliff", "display": "Cliff Path", "areaId": 2, "hideWorld": 0, },143: { "worldId": 11, "name": "NeverlandLagoon", "display": "Mermaid Lagoon", "areaId": 3, "hideWorld": 0, },144: { "worldId": 11, "name": "NeverlandSeacoast", "display": "Seacoast", "areaId": 4, "hideWorld": 0, },145: { "worldId": 11, "name": "NeverlandClearing", "display": "Jungle Clearing", "areaId": 5, "hideWorld": 0, },146: { "worldId": 11, "name": "NeverlandHideout", "display": "Peter’s Hideout", "areaId": 6, "hideWorld": 0, },147: { "worldId": 11, "name": "NeverlandGully", "display": "Gully", "areaId": 7, "hideWorld": 0, },148: { "worldId": 11, "name": "NeverlandCamp", "display": "Indian Camp", "areaId": 8, "hideWorld": 0, },149: { "worldId": 11, "name": "NeverlandBase", "display": "Rainbow Falls: Base", "areaId": 9, "hideWorld": 0, },150: { "worldId": 11, "name": "NeverlandAscent", "display": "Rainbow Falls: Ascent", "areaId": 10, "hideWorld": 0, },151: { "worldId": 11, "name": "NeverlandCrest", "display": "Rainbow Falls: Crest", "areaId": 11, "hideWorld": 0, },152: { "worldId": 11, "name": "NeverlandSkullEntrance", "display": "Skull Rock: Entrance", "areaId": 12, "hideWorld": 0, },153: { "worldId": 11, "name": "NeverlandSkullCavern", "display": "Skull Rock: Cavern", "areaId": 13, "hideWorld": 0, },154: { "worldId": 11, "name": "NeverlandSky", "display": "Night Sky", "areaId": 14, "hideWorld": 0, },155: { "worldId": 12, "name": "DisneyLibrary", "display": "Library", "areaId": 1, "hideWorld": 0, },156: { "worldId": 12, "name": "DisneyPlaza", "display": "Main Plaza", "areaId": 2, "hideWorld": 0, },157: { "worldId": 12, "name": "DisneyFruitballCourt", "display": "Fruitball Course", "areaId": 3, "hideWorld": 0, },158: { "worldId": 12, "name": "DisneyCourseA", "display": "Racecourse A", "areaId": 4, "hideWorld": 0, },159: { "worldId": 12, "name": "DisneyRaceway", "display": "Raceway", "areaId": 5, "hideWorld": 0, },160: { "worldId": 12, "name": "DisneyGizmo", "display": "Gizmo Gallery", "areaId": 6, "hideWorld": 0, },161: { "worldId": 12, "name": "DisneyRecRoom", "display": "Pete’s Rec Room", "areaId": 7, "hideWorld": 0, },162: { "worldId": 12, "name": "DisneyCourseB", "display": "Racecourse B", "areaId": 8, "hideWorld": 0, },163: { "worldId": 12, "name": "DisneyCourseC", "display": "Racecourse C", "areaId": 9, "hideWorld": 0, },164: { "worldId": 12, "name": "DisneyCourseD", "display": "Racecourse D", "areaId": 10, "hideWorld": 0, },165: { "worldId": 12, "name": "DisneyLanesBetween", "display": "The Lanes Between", "areaId": 11, "hideWorld": 0, },166: { "worldId": 12, "name": "DisneyRegistration", "display": "Raceway Registration", "areaId": 12, "hideWorld": 0, },167: { "worldId": 12, "name": "DisneyIceCream", "display": "Ice Cream", "areaId": 13, "hideWorld": 0, },168: { "worldId": 12, "name": "DisneyFruitball", "display": "Fruitball", "areaId": 14, "hideWorld": 0, },169: { "worldId": 12, "name": "DisneyCourseCastle", "display": "Race: Castle Course", "areaId": 15, "hideWorld": 0, },170: { "worldId": 13, "name": "GraveyardBadlands", "display": "Badlands", "areaId": 1, "hideWorld": 0, },171: { "worldId": 13, "name": "GraveyardWar", "display": "Seat of War", "areaId": 2, "hideWorld": 0, },172: { "worldId": 13, "name": "GraveyardTwister", "display": "Twister Trench", "areaId": 3, "hideWorld": 0, },173: { "worldId": 13, "name": "GraveyardEye1", "display": "Eye of the Storm", "areaId": 4, "hideWorld": 0, },174: { "worldId": 13, "name": "GraveyardEye2", "display": "Eye of the Storm", "areaId": 5, "hideWorld": 0, },175: { "worldId": 13, "name": "GraveyardEye3", "display": "Eye of the Storm", "areaId": 6, "hideWorld": 0, },176: { "worldId": 13, "name": "GraveyardFissure", "display": "Fissure", "areaId": 7, "hideWorld": 0, },177: { "worldId": 13, "name": "Graveyard1", "display": "Keyblade Graveyard", "areaId": 8, "hideWorld": 1, },178: { "worldId": 13, "name": "Graveyard2", "display": "Keyblade Graveyard", "areaId": 9, "hideWorld": 1, },179: { "worldId": 13, "name": "Graveyard3", "display": "Keyblade Graveyard", "areaId": 10, "hideWorld": 1, },180: { "worldId": 13, "name": "GraveyardCage", "display": "Will’s Cage", "areaId": 11, "hideWorld": 0, },181: { "worldId": 13, "name": "Graveyard4", "display": "Keyblade Graveyard", "areaId": 12, "hideWorld": 1, },182: { "worldId": 13, "name": "VentusHeart1", "display": "Ventus’s Heart", "areaId": 50, "hideWorld": 0, },183: { "worldId": 13, "name": "VentusHeart2", "display": "Ventus’s Heart", "areaId": 51, "hideWorld": 0, },184: { "worldId": 13, "name": "VentusHeart3", "display": "Ventus’s Heart", "areaId": 52, "hideWorld": 0, },185: { "worldId": 13, "name": "SoraHeart", "display": "Sora’s Heart", "areaId": 53, "hideWorld": 0, },186: { "worldId": 13, "name": "TerraHeart", "display": "Terra’s Heart", "areaId": 54, "hideWorld": 0, },187: { "worldId": 13, "name": "Graveyard5", "display": "Keyblade Graveyard", "areaId": 55, "hideWorld": 0, },188: { "worldId": 13, "name": "GraveyardBadlands2", "display": "Badlands", "areaId": 56, "hideWorld": 0, },189: { "worldId": 15, "name": "MirageHub", "display": "Hub", "areaId": 1, "hideWorld": 0, },190: { "worldId": 15, "name": "MirageColiseum", "display": "Coliseum", "areaId": 2, "hideWorld": 0, },191: { "worldId": 15, "name": "MirageArena1", "display": "Arena", "areaId": 3, "hideWorld": 0, },192: { "worldId": 15, "name": "MirageBadlands", "display": "Badlands", "areaId": 4, "hideWorld": 0, },193: { "worldId": 15, "name": "MiragePinball", "display": "Pinball", "areaId": 5, "hideWorld": 0, },194: { "worldId": 15, "name": "MirageShipHub", "display": "Ship Hub", "areaId": 6, "hideWorld": 0, },195: { "worldId": 15, "name": "MirageMousehole", "display": "Mousehole", "areaId": 7, "hideWorld": 0, },196: { "worldId": 15, "name": "MirageForest", "display": "Forest", "areaId": 8, "hideWorld": 0, },197: { "worldId": 15, "name": "MirageSkull", "display": "Skull Rock", "areaId": 9, "hideWorld": 0, },198: { "worldId": 15, "name": "MirageChamber", "display": "Audience Chamber", "areaId": 10, "hideWorld": 0, },199: { "worldId": 15, "name": "MirageForecourt", "display": "Forecourt", "areaId": 11, "hideWorld": 0, },200: { "worldId": 15, "name": "MirageSummit", "display": "Summit", "areaId": 12, "hideWorld": 0, },201: { "worldId": 15, "name": "MirageDeck", "display": "Launch Deck", "areaId": 13, "hideWorld": 0, },202: { "worldId": 15, "name": "MirageExterior", "display": "Ship Exterior", "areaId": 14, "hideWorld": 0, },203: { "worldId": 15, "name": "MirageArena2", "display": "Arena", "areaId": 15, "hideWorld": 0, },204: { "worldId": 16, "name": "CommandDeparture", "display": "The Land of Departure Command Board", "areaId": 1, "hideWorld": 1, },205: { "worldId": 16, "name": "CommandCinderella", "display": "Cinderella Command Board", "areaId": 3, "hideWorld": 1, },206: { "worldId": 16, "name": "CommandSitch", "display": "Lilo and Stitch Command Board", "areaId": 9, "hideWorld": 1, },207: { "worldId": 16, "name": "CommandPan", "display": "Peter Pan Command Board", "areaId": 11, "hideWorld": 1, },208: { "worldId": 16, "name": "CommandDisney", "display": "Disney Castle Command Board", "areaId": 12, "hideWorld": 1, },209: { "worldId": 16, "name": "CommandPooh", "display": "Winnie the Pooh Command Board", "areaId": 18, "hideWorld": 1, },210: { "worldId": 16, "name": "CommandPan2", "display": "Peter Pan Command Board", "areaId": 19, "hideWorld": 1, },211: { "worldId": 17, "name": "WorldMap", "display": "World Map", "areaId": 1, "hideWorld": 1, },

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

function Terra() => 3
function Ventus() => 1
function Aqua() => 2

function CharacterIdToNames()
{
    return {
        Terra(): "Terra",
        Aqua(): "Aqua",
        Ventus(): "Ventus"
    }
}

function GetAreaRPLookup(worldId)
{
    ret = {}
    for id in areas
    {
        area = areas[id]
        if (area["worldId"] == worldId)
        {
            ret[area["areaId"]] = area["display"]
        }
    }
    return ret
}

function playTime() => dword(0x1f19880)

for world in worlds
{
    rich_presence_conditional_display(worldId() == world, "{0}, Level {1} | " + worlds[world] + ": {2} | Play time: {3}",
        rich_presence_lookup("Characters", currentCharacter(), CharacterIdToNames()),
        rich_presence_value("Level", level(), "VALUE"),
        rich_presence_lookup("Areas" + world, areaId(), GetAreaRPLookup(world)),
        rich_presence_value("Play Time", playTime(), "SECS")
    )
}

rich_presence_display("Somewhere in the World...")

achievement(title = "The Final Stargaze", points = 1,
    description = "Complete the prologue.",
    trigger = WasInLocation("DepartureSummitNight") && IsInLocation("MysteriousChamber")
)

function characterFieldPointer() => tbyte(0xb5a4b0)
function hp() => word(characterFieldPointer() + 0xdc0 + 0x1000000)

function CheckpointPassedForCharacters(checkpointLogic, allowedCharacters, deferFor = 0)
{
    returnedLogic = checkpointLogic
    characterIsAllowed = always_false()
    
    for character in allowedCharacters
    {
        characterIsAllowed = characterIsAllowed || currentCharacter() == character
    }

    return repeated(deferFor, once(returnedLogic && characterIsAllowed))
}

// charactersToTrigger: a dictionary of character IDs to trigger logic; each logical statement will only apply if the player is controlling a specific character
function TriggerConditionsMetForCharacters(charactersToTriggerLogic, useTrigger = 0)
{
    triggerMet = always_false()
    for id in charactersToTriggerLogic
    {
        characterLogicIsMet = charactersToTriggerLogic[id]
        
        if (useTrigger == True())
        {
            characterLogicIsMet = trigger_when(characterLogicIsMet)
        }
        
        triggerMet = triggerMet || characterLogicIsMet && currentCharacter() == id
    }
    
    return triggerMet
}

function IsInBattle() => byte(0xb5a4b4) == 1
function HUDAndAttacksDisabled() => bit5(0xb5a4b5) == 1
function GameOverTriggered() => IsInBattle() && HUDAndAttacksDisabled() && hp() == 0 && characterFieldPointer() != 0
function IsPausing() => always_false()
function metronome() => byte(0xbb7b0c)
function FrameAdvanced() => Delta(metronome()) != metronome()

function informationBarState() => byte(0x1f3d760)
function InformationBarPoppedUpOnce() => once(Delta(informationBarState()) == 0 && informationBarState() == 1)
function criticalImpactState() => byte(0x1f2accc)
function LearnedCriticalImpact() => criticalImpactState() == 5 && Delta(criticalImpactState()) == 0

function HitBallToPassTestDeferment() => 491
function HitBallToPassTestTimeLimit() => 60
function HitBallToPassTestTotalTime() => HitBallToPassTestDeferment() + SecondsToFrames(HitBallToPassTestTimeLimit())
function HitBallToPassTestCheckpointReached() => CheckpointPassedForCharacters(InformationBarPoppedUpOnce()
    && IsInLocation("DepartureGreatHall"), [ Terra(), Ventus(), Aqua() ], HitBallToPassTestDeferment())

achievement(title = "Hit Ball to Pass Test [m]", points = 5,
    description = "Complete the first phase of the Mark of Mastery exam within " + SecondsToFormat(HitBallToPassTestTimeLimit()) + ".",
    trigger = HitBallToPassTestCheckpointReached() && never(repeated(HitBallToPassTestTotalTime(), HitBallToPassTestCheckpointReached()))
        && TriggerConditionsMetForCharacters({
            Terra(): LearnedCriticalImpact()
        }, True())
        && unless(IsPausing()) && never(GameOverTriggered())
)
