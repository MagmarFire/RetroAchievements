// Kingdom Hearts II: Final Mix
// #ID = 2781
// #subset-ID = 25083

function generateBonusAchievements() => false
function TRUE() => 1
function FALSE() => 0
function Delta(mem) => prev(mem)
function ToString(val) => val + ""

function xachievement(title, description, points, trigger, badge = "00000", id = 0)
{
    if (!generateBonusAchievements())
    {
        achievement(title = title, description = description, points = points, trigger = trigger, badge = badge, id = id)
    }
}

function xleaderboard(title, description, start, cancel, submit, value, format, lower_is_better = false, format = "VALUE", id = 0)
{
    if (!generateBonusAchievements())
    {
        leaderboard(title = title, description = description,
            start = start,
            cancel = cancel,
            submit = submit,
            value = value,
            format = format,
            id = id
        )
    }
}

function DictionaryKeyExists(dict, key)
{
    for i in dict
    {
        if (i == key)
        {
            return TRUE()
        }
    }
    
    return FALSE()
}

function CreateHitTargetedAndNextChain(permutation)
{
    trigger = always_true()
    
    for condition in permutation
    {
        trigger = once(trigger && once(condition))
    }
    
    return trigger
}

function LMeasured(condition) => measured(repeated(0, condition)) // Legacy `measured` polyfill. measured(A && B) is no longer supported as of v1.10.0.

areas = {
    65535: { "worldId": 255, "name": "Title", "display": "On the title screen…", "areaId": 255, "hideWorld": 1, },523: { "worldId": 2, "name": "SunsetStation", "display": "Sunset Station", "areaId": 11, "hideWorld": 0, },522: { "worldId": 2, "name": "SunsetTerrace", "display": "Sunset Terrace", "areaId": 10, "hideWorld": 0, },548: { "worldId": 2, "name": "Tunnelway", "display": "Tunnelway", "areaId": 36, "hideWorld": 0, },524: { "worldId": 2, "name": "SunsetHill", "display": "Sunset Hill", "areaId": 12, "hideWorld": 0, },520: { "worldId": 2, "name": "StationPlaza", "display": "Station Plaza", "areaId": 8, "hideWorld": 0, },518: { "worldId": 2, "name": "StationHeights", "display": "Market Street: Station Heights", "areaId": 6, "hideWorld": 0, },515: { "worldId": 2, "name": "BackAlley", "display": "Back Alley", "areaId": 3, "hideWorld": 0, },514: { "worldId": 2, "name": "UsualSpot", "display": "The Usual Spot", "areaId": 2, "hideWorld": 0, },516: { "worldId": 2, "name": "Sandlot", "display": "Sandlot", "areaId": 4, "hideWorld": 0, },519: { "worldId": 2, "name": "TramCommon", "display": "Market Street: Tram Common", "areaId": 7, "hideWorld": 0, },525: { "worldId": 2, "name": "Woods", "display": "The Woods", "areaId": 13, "hideWorld": 0, },513: { "worldId": 2, "name": "RoxasRoom", "display": "Roxas’s Room", "areaId": 1, "hideWorld": 0, },526: { "worldId": 2, "name": "Courtyard", "display": "The Old Mansion", "areaId": 14, "hideWorld": 0, },527: { "worldId": 2, "name": "Foyer", "display": "Mansion: Foyer", "areaId": 15, "hideWorld": 0, },530: { "worldId": 2, "name": "WhiteRoom", "display": "Mansion: The White Room", "areaId": 18, "hideWorld": 0, },529: { "worldId": 2, "name": "Library", "display": "Mansion: Library", "areaId": 17, "hideWorld": 0, },533: { "worldId": 2, "name": "ComputerRoom", "display": "Mansion: Computer Room", "areaId": 21, "hideWorld": 0, },531: { "worldId": 2, "name": "BasementHall", "display": "Mansion: Basement Hall", "areaId": 19, "hideWorld": 0, },532: { "worldId": 2, "name": "BasementHallAxel", "display": "Mansion: Basement Hall", "areaId": 20, "hideWorld": 0, },534: { "worldId": 2, "name": "BasementCorridor", "display": "Mansion: Basement Corridor", "areaId": 22, "hideWorld": 0, },535: { "worldId": 2, "name": "PodRoom", "display": "Mansion: Pod Room", "areaId": 23, "hideWorld": 0, },544: { "worldId": 2, "name": "StationOfSerenity", "display": "Station of Serenity", "areaId": 32, "hideWorld": 1, },545: { "worldId": 2, "name": "StationOfCalling", "display": "Station of Calling", "areaId": 33, "hideWorld": 1, },546: { "worldId": 2, "name": "StationOfAwakening", "display": "Station of Awakening", "areaId": 34, "hideWorld": 1, },517: { "worldId": 2, "name": "SandlotBattlefield", "display": "Sandlot", "areaId": 5, "hideWorld": 0, },521: { "worldId": 2, "name": "CentralStation", "display": "Central Station", "areaId": 9, "hideWorld": 0, },537: { "worldId": 2, "name": "Tower", "display": "The Tower", "areaId": 25, "hideWorld": 1, },541: { "worldId": 2, "name": "StarChamber", "display": "Tower: Star Chamber", "areaId": 29, "hideWorld": 1, },543: { "worldId": 2, "name": "WaywardStairs", "display": "Tower: Wayward Stairs", "areaId": 31, "hideWorld": 1, },550: { "worldId": 2, "name": "WaywardStairs2", "display": "Tower: Wayward Stairs", "areaId": 38, "hideWorld": 1, },542: { "worldId": 2, "name": "MoonChamber", "display": "Tower: Moon Chamber", "areaId": 30, "hideWorld": 1, },551: { "worldId": 2, "name": "WaywardStairs3", "display": "Tower: Wayward Stairs", "areaId": 39, "hideWorld": 1, },539: { "worldId": 2, "name": "SorcererLoft", "display": "Tower: Sorcerer’s Loft", "areaId": 27, "hideWorld": 1, },540: { "worldId": 2, "name": "Wardrobe", "display": "Tower: Wardrobe", "areaId": 28, "hideWorld": 1, },3840: { "worldId": 15, "name": "WorldMap", "display": "World Map", "areaId": 0, "hideWorld": 1, },1024: { "worldId": 4, "name": "VillainVale", "display": "Villain’s Vale", "areaId": 0, "hideWorld": 0, },1034: { "worldId": 4, "name": "Marketplace", "display": "Marketplace", "areaId": 10, "hideWorld": 0, },1033: { "worldId": 4, "name": "Borough", "display": "Borough", "areaId": 9, "hideWorld": 0, },1037: { "worldId": 4, "name": "Merlin", "display": "Merlin’s House", "areaId": 13, "hideWorld": 0, },2048: { "worldId": 8, "name": "BambooGrove", "display": "Bamboo Grove", "areaId": 0, "hideWorld": 0, },2049: { "worldId": 8, "name": "Encampment", "display": "Encampment", "areaId": 1, "hideWorld": 0, },2050: { "worldId": 8, "name": "Checkpoint", "display": "Checkpoint", "areaId": 2, "hideWorld": 0, },2052: { "worldId": 8, "name": "Village", "display": "Village", "areaId": 4, "hideWorld": 0, },2051: { "worldId": 8, "name": "MountainTrail", "display": "Mountain Trail", "areaId": 3, "hideWorld": 0, },2053: { "worldId": 8, "name": "VillageCave", "display": "Village Cave", "areaId": 5, "hideWorld": 0, },2060: { "worldId": 8, "name": "RuinedVillage", "display": "Village", "areaId": 12, "hideWorld": 0, },2054: { "worldId": 8, "name": "Ridge", "display": "Ridge", "areaId": 6, "hideWorld": 0, },2055: { "worldId": 8, "name": "Summit", "display": "Summit", "areaId": 7, "hideWorld": 0, },2056: { "worldId": 8, "name": "ImperialSquare", "display": "Imperial Square", "areaId": 8, "hideWorld": 0, },2057: { "worldId": 8, "name": "PalaceGate", "display": "Palace Gate", "areaId": 9, "hideWorld": 0, },1280: { "worldId": 5, "name": "EntranceHall", "display": "Entrance Hall", "areaId": 0, "hideWorld": 0, },1281: { "worldId": 5, "name": "Parlor", "display": "Parlor", "areaId": 1, "hideWorld": 0, },1286: { "worldId": 5, "name": "BeastCourtyard", "display": "Courtyard", "areaId": 6, "hideWorld": 0, },1282: { "worldId": 5, "name": "BelleRoom", "display": "Belle’s Room", "areaId": 2, "hideWorld": 0, },1287: { "worldId": 5, "name": "EastWing", "display": "The East Wing", "areaId": 7, "hideWorld": 0, },1284: { "worldId": 5, "name": "Ballroom", "display": "Ballroom", "areaId": 4, "hideWorld": 0, },1288: { "worldId": 5, "name": "WestHall", "display": "The West Hall", "areaId": 8, "hideWorld": 0, },1291: { "worldId": 5, "name": "Undercroft", "display": "Undercroft", "areaId": 11, "hideWorld": 0, },1290: { "worldId": 5, "name": "Dungeon", "display": "Dungeon", "areaId": 10, "hideWorld": 0, },1292: { "worldId": 5, "name": "SecretPassage", "display": "Secret Passage", "areaId": 12, "hideWorld": 0, },1289: { "worldId": 5, "name": "WestWing", "display": "The West Wing", "areaId": 9, "hideWorld": 0, },1283: { "worldId": 5, "name": "BeastRoom", "display": "The Beast’s Room", "areaId": 3, "hideWorld": 0, },1285: { "worldId": 5, "name": "BallroomBattle", "display": "Ballroom", "areaId": 5, "hideWorld": 0, },2304: { "worldId": 9, "name": "Book", "display": "The Hundred Acre Wood", "areaId": 0, "hideWorld": 1, },2306: { "worldId": 9, "name": "PoohHouse", "display": "Pooh Bear’s House", "areaId": 2, "hideWorld": 0, },1542: { "worldId": 6, "name": "HadesChamber", "display": "Hades’ Chamber", "areaId": 6, "hideWorld": 0, },1541: { "worldId": 6, "name": "ValleyOfTheDead", "display": "Valley of the Dead", "areaId": 5, "hideWorld": 0, },1546: { "worldId": 6, "name": "CaveOfTheDeadInnerChamber", "display": "Cave of the Dead: Inner Chamber", "areaId": 10, "hideWorld": 0, },1551: { "worldId": 6, "name": "CaveOfTheDeadPassage", "display": "Cave of the Dead: Passage", "areaId": 15, "hideWorld": 0, },1539: { "worldId": 6, "name": "UnderworldEntrance", "display": "Underworld Entrance", "areaId": 3, "hideWorld": 0, },1543: { "worldId": 6, "name": "CaveOfTheDeadEntrance", "display": "Cave of the Dead: Entrance", "areaId": 7, "hideWorld": 0, },1537: { "worldId": 6, "name": "ColiseumGates", "display": "Coliseum Gates", "areaId": 1, "hideWorld": 0, },1540: { "worldId": 6, "name": "ColiseumFoyer", "display": "Coliseum Foyer", "areaId": 4, "hideWorld": 0, },1536: { "worldId": 6, "name": "Coliseum", "display": "The Coliseum", "areaId": 0, "hideWorld": 0, },1547: { "worldId": 6, "name": "UnderworldCavernsEntrance", "display": "Underworld Caverns: Entrance", "areaId": 11, "hideWorld": 0, },1552: { "worldId": 6, "name": "UnderworldCavernsLostRoad", "display": "Underworld Caverns: The Lost Road", "areaId": 16, "hideWorld": 0, },1553: { "worldId": 6, "name": "UnderworldCavernsAtrium", "display": "Underworld Caverns: Atrium", "areaId": 17, "hideWorld": 0, },1548: { "worldId": 6, "name": "UnderworldLock", "display": "The Lock", "areaId": 12, "hideWorld": 0, },1544: { "worldId": 6, "name": "UnderworldLock2", "display": "The Lock", "areaId": 8, "hideWorld": 0, },1554: { "worldId": 6, "name": "ColiseumGatesRuined", "display": "Coliseum Gates", "areaId": 18, "hideWorld": 0, },3075: { "worldId": 12, "name": "CastleCourtyard", "display": "Courtyard", "areaId": 3, "hideWorld": 0, },3074: { "worldId": 12, "name": "CastleColonnade", "display": "Colonnade", "areaId": 2, "hideWorld": 0, },3073: { "worldId": 12, "name": "CastleLibrary", "display": "Library", "areaId": 1, "hideWorld": 0, },3072: { "worldId": 12, "name": "CastleAudienceChamber", "display": "Audience Chamber", "areaId": 0, "hideWorld": 0, },3076: { "worldId": 12, "name": "CastleCornerstone", "display": "The Hall of the Cornerstone", "areaId": 4, "hideWorld": 0, },3328: { "worldId": 13, "name": "RiverCornerstoneHill", "display": "Cornerstone Hill", "areaId": 0, "hideWorld": 0, },3329: { "worldId": 13, "name": "RiverPier", "display": "Pier", "areaId": 1, "hideWorld": 0, },3335: { "worldId": 13, "name": "MickeyHouse", "display": "Mickey’s House", "areaId": 7, "hideWorld": 0, },3334: { "worldId": 13, "name": "Fire", "display": "Scene of the Fire", "areaId": 6, "hideWorld": 0, },3332: { "worldId": 13, "name": "Lilliput", "display": "Lilliput", "areaId": 4, "hideWorld": 0, },3333: { "worldId": 13, "name": "BuildingSite", "display": "Building Site", "areaId": 5, "hideWorld": 0, },3336: { "worldId": 13, "name": "VillainFlashback", "display": "Villain’s Vale", "areaId": 8, "hideWorld": 1, },3331: { "worldId": 13, "name": "RiverWharf", "display": "Wharf", "areaId": 3, "hideWorld": 0, },3330: { "worldId": 13, "name": "RiverWaterway", "display": "Waterway", "areaId": 2, "hideWorld": 0, },4104: { "worldId": 16, "name": "PortRockFace", "display": "Isla de Muerta: Rock Face", "areaId": 8, "hideWorld": 0, },4105: { "worldId": 16, "name": "PortCaveMouth", "display": "Isla de Muerta: Cave Mouth", "areaId": 9, "hideWorld": 0, },4097: { "worldId": 16, "name": "PortHarbor", "display": "Harbor", "areaId": 1, "hideWorld": 0, },4098: { "worldId": 16, "name": "PortTown", "display": "Town", "areaId": 2, "hideWorld": 0, },4096: { "worldId": 16, "name": "PortRampart", "display": "Rampart", "areaId": 0, "hideWorld": 0, },4099: { "worldId": 16, "name": "PortInterceptor", "display": "The Interceptor", "areaId": 3, "hideWorld": 0, },4100: { "worldId": 16, "name": "PortInterceptorHold", "display": "The Interceptor: Ship’s Hold", "areaId": 4, "hideWorld": 0, },4117: { "worldId": 16, "name": "PortInterceptorBattle", "display": "The Interceptor", "areaId": 21, "hideWorld": 0, },4103: { "worldId": 16, "name": "PortInterceptorDualBattle", "display": "The Interceptor", "areaId": 7, "hideWorld": 0, },4108: { "worldId": 16, "name": "PortPowderStore", "display": "Isla de Muerta: Powder Store", "areaId": 12, "hideWorld": 0, },4109: { "worldId": 16, "name": "PortNook", "display": "Isla de Muerta: Moonlight Nook", "areaId": 13, "hideWorld": 0, },4106: { "worldId": 16, "name": "PortHeap", "display": "Isla de Muerta: Treasure Heap", "areaId": 10, "hideWorld": 0, },3586: { "worldId": 14, "name": "HalloweenGraveyard", "display": "Graveyard", "areaId": 2, "hideWorld": 0, },3585: { "worldId": 14, "name": "HalloweenLab", "display": "Dr. Finkelstein’s Lab", "areaId": 1, "hideWorld": 0, },3584: { "worldId": 14, "name": "HalloweenSquare", "display": "Halloween Town Square", "areaId": 0, "hideWorld": 1, },3588: { "worldId": 14, "name": "HalloweenHinterlands", "display": "Hinterlands", "areaId": 4, "hideWorld": 0, },3589: { "worldId": 14, "name": "HalloweenYuletide", "display": "Christmas Town: Yuletide Hill", "areaId": 5, "hideWorld": 1, },3590: { "worldId": 14, "name": "HalloweenCandyCane", "display": "Christmas Town: Candy Cane Lane", "areaId": 6, "hideWorld": 1, },3592: { "worldId": 14, "name": "HalloweenSanta", "display": "Christmas Town: Santa’s House", "areaId": 8, "hideWorld": 1, },3587: { "worldId": 14, "name": "HalloweenHill", "display": "Curly Hill", "areaId": 3, "hideWorld": 0, },3593: { "worldId": 14, "name": "HalloweenFactory", "display": "Christmas Town: Toy Factory: Shipping and Receiving", "areaId": 9, "hideWorld": 1, },1794: { "worldId": 7, "name": "AgrabahShop", "display": "The Peddler’s Shop", "areaId": 2, "hideWorld": 0, },1792: { "worldId": 7, "name": "Agrabah", "display": "Agrabah", "areaId": 0, "hideWorld": 1, },1793: { "worldId": 7, "name": "AgrabahBazaar", "display": "Bazaar", "areaId": 1, "hideWorld": 0, },1798: { "worldId": 7, "name": "AgrabahWalls", "display": "Palace Walls", "areaId": 6, "hideWorld": 0, },1799: { "worldId": 7, "name": "AgrabahCaveEntrance", "display": "The Cave of Wonders: Entrance", "areaId": 7, "hideWorld": 0, },1804: { "worldId": 7, "name": "AgrabahCaveValley", "display": "The Cave of Wonders: Valley of Stone", "areaId": 12, "hideWorld": 0, },1801: { "worldId": 7, "name": "AgrabahCaveGuardians", "display": "The Cave of Wonders: Stone Guardians", "areaId": 9, "hideWorld": 0, },1805: { "worldId": 7, "name": "AgrabahCaveChasm", "display": "The Cave of Wonders: Chasm of Challenges", "areaId": 13, "hideWorld": 0, },1802: { "worldId": 7, "name": "AgrabahCaveTreasure", "display": "The Cave of Wonders: Treasure Room", "areaId": 10, "hideWorld": 0, },1795: { "worldId": 7, "name": "AgrabahPalace", "display": "The Palace", "areaId": 3, "hideWorld": 0, },2566: { "worldId": 10, "name": "PrideGorge", "display": "Gorge", "areaId": 6, "hideWorld": 0, },2565: { "worldId": 10, "name": "PrideGraveyard", "display": "Elephant Graveyard", "areaId": 5, "hideWorld": 0, },2564: { "worldId": 10, "name": "PrideSavannah", "display": "The Savannah", "areaId": 4, "hideWorld": 0, },2560: { "worldId": 10, "name": "PrideRock", "display": "Pride Rock", "areaId": 0, "hideWorld": 0, },2561: { "worldId": 10, "name": "PrideHollow", "display": "Stone Hollow", "areaId": 1, "hideWorld": 0, },2563: { "worldId": 10, "name": "PrideValley", "display": "Wildebeest Valley", "areaId": 3, "hideWorld": 0, },2567: { "worldId": 10, "name": "PrideWastelands", "display": "Wastelands", "areaId": 7, "hideWorld": 0, },2568: { "worldId": 10, "name": "PrideJungle", "display": "Jungle", "areaId": 8, "hideWorld": 0, },2569: { "worldId": 10, "name": "PrideOasis", "display": "Oasis", "areaId": 9, "hideWorld": 0, },2562: { "worldId": 10, "name": "PrideDen", "display": "The King’s Den", "areaId": 2, "hideWorld": 0, },2573: { "worldId": 10, "name": "PridePeak", "display": "Peak", "areaId": 13, "hideWorld": 0, },2574: { "worldId": 10, "name": "PridePeakBattle", "display": "Peak", "areaId": 14, "hideWorld": 0, },1545: { "worldId": 6, "name": "ColiseumTourney1", "display": "The Underdrome", "areaId": 9, "hideWorld": 0, },1549: { "worldId": 6, "name": "ColiseumVictory", "display": "The Underdrome", "areaId": 13, "hideWorld": 0, },4112: { "worldId": 16, "name": "PortRockFace2", "display": "Isla de Muerta: Rock Face", "areaId": 16, "hideWorld": 0, },1032: { "worldId": 4, "name": "Bailey", "display": "Bailey", "areaId": 8, "hideWorld": 0, },1031: { "worldId": 4, "name": "RestorationSite", "display": "Restoration Site", "areaId": 7, "hideWorld": 0, },1030: { "worldId": 4, "name": "Postern", "display": "Postern", "areaId": 6, "hideWorld": 0, },1035: { "worldId": 4, "name": "Corridors", "display": "Corridors", "areaId": 11, "hideWorld": 0, },1029: { "worldId": 4, "name": "AnsemStudy", "display": "Ansem’s Study", "areaId": 5, "hideWorld": 0, },4352: { "worldId": 17, "name": "SpaceCell", "display": "Pit Cell", "areaId": 0, "hideWorld": 0, },4353: { "worldId": 17, "name": "SpaceCanyon", "display": "Canyon", "areaId": 1, "hideWorld": 0, },4354: { "worldId": 17, "name": "SpaceGrid", "display": "Game Grid", "areaId": 2, "hideWorld": 0, },4355: { "worldId": 17, "name": "SpaceDataspace", "display": "Dataspace", "areaId": 3, "hideWorld": 0, },4356: { "worldId": 17, "name": "SpaceIOTowerHallway", "display": "I/O Tower: Hallway", "areaId": 4, "hideWorld": 0, },4357: { "worldId": 17, "name": "SpaceIOCommunications", "display": "I/O Tower: Communications Room", "areaId": 5, "hideWorld": 0, },1043: { "worldId": 4, "name": "Bailey2", "display": "Bailey", "areaId": 19, "hideWorld": 0, },1044: { "worldId": 4, "name": "CorridorsBattle", "display": "Corridors", "areaId": 20, "hideWorld": 0, },1045: { "worldId": 4, "name": "CavernDepths", "display": "Cavern of Remembrance: Depths", "areaId": 21, "hideWorld": 1, },1042: { "worldId": 4, "name": "RestorationSiteCutscene2", "display": "Restoration Site", "areaId": 18, "hideWorld": 0, },1028: { "worldId": 4, "name": "CastleGate", "display": "Castle Gate", "areaId": 4, "hideWorld": 0, },1040: { "worldId": 4, "name": "RavineTrail", "display": "Ravine Trail", "areaId": 16, "hideWorld": 0, },1027: { "worldId": 4, "name": "CrystalFissure", "display": "Crystal Fissure", "areaId": 3, "hideWorld": 0, },1026: { "worldId": 4, "name": "GreatMawCutscene", "display": "The Great Maw", "areaId": 2, "hideWorld": 0, },1039: { "worldId": 4, "name": "AnsemStudyCutscene", "display": "Ansem’s Study", "areaId": 15, "hideWorld": 0, },1041: { "worldId": 4, "name": "GreatMaw", "display": "The Great Maw", "areaId": 17, "hideWorld": 0, },2058: { "worldId": 8, "name": "DragonAntechamber", "display": "Antechamber", "areaId": 10, "hideWorld": 0, },2059: { "worldId": 8, "name": "DragonThrone", "display": "Throne Room", "areaId": 11, "hideWorld": 0, },1295: { "worldId": 5, "name": "BeastBridge", "display": "Bridge", "areaId": 15, "hideWorld": 0, },1555: { "worldId": 6, "name": "ColiseumTourneyHades", "display": "The Underdrome", "areaId": 19, "hideWorld": 0, },4101: { "worldId": 16, "name": "PortPearl", "display": "The Black Pearl", "areaId": 5, "hideWorld": 0, },4102: { "worldId": 16, "name": "PortPearlCaptain", "display": "The Black Pearl: Captain’s Stateroom", "areaId": 6, "hideWorld": 0, },4115: { "worldId": 16, "name": "PortPearlBattle", "display": "The Black Pearl", "areaId": 19, "hideWorld": 0, },4107: { "worldId": 16, "name": "PortGraveyardInterceptor", "display": "Ship Graveyard: The Interceptor’s Hold", "areaId": 11, "hideWorld": 0, },4111: { "worldId": 16, "name": "PortGraveyardRow", "display": "Ship Graveyard: Seadrift Row", "areaId": 15, "hideWorld": 0, },4110: { "worldId": 16, "name": "PortGraveyardKeep", "display": "Ship Graveyard: Seadrift Keep", "areaId": 14, "hideWorld": 0, },4120: { "worldId": 16, "name": "PortHarborCutscene", "display": "Harbor", "areaId": 24, "hideWorld": 0, },3594: { "worldId": 14, "name": "HalloweenWrapping", "display": "Christmas Town: The Wrapping Room", "areaId": 10, "hideWorld": 1, },3591: { "worldId": 14, "name": "HalloweenPlaza", "display": "Christmas Town: Christmas Tree Plaza", "areaId": 7, "hideWorld": 1, },1807: { "worldId": 7, "name": "AgrabahShop2", "display": "The Peddler’s Shop", "areaId": 15, "hideWorld": 0, },1806: { "worldId": 7, "name": "AgrabahSand", "display": "Sandswept Ruins", "areaId": 14, "hideWorld": 0, },1803: { "worldId": 7, "name": "AgrabahRuin", "display": "Ruined Chamber", "areaId": 11, "hideWorld": 0, },1797: { "worldId": 7, "name": "AgrabahAbove", "display": "Above the City", "areaId": 5, "hideWorld": 0, },2575: { "worldId": 10, "name": "PrideSavannahBattle", "display": "The Savannah", "areaId": 15, "hideWorld": 0, },4116: { "worldId": 16, "name": "PortPearlBattle2", "display": "The Black Pearl", "areaId": 20, "hideWorld": 0, },4358: { "worldId": 17, "name": "SpaceSimulation", "display": "Simulation Hangar", "areaId": 6, "hideWorld": 0, },4362: { "worldId": 17, "name": "SpaceSailer", "display": "Solar Sailer Simulation", "areaId": 10, "hideWorld": 0, },4359: { "worldId": 17, "name": "SpaceSailerBattle", "display": "Solar Sailer Simulation", "areaId": 7, "hideWorld": 0, },4360: { "worldId": 17, "name": "SpaceMesa", "display": "Central Computer Mesa", "areaId": 8, "hideWorld": 0, },4361: { "worldId": 17, "name": "SpaceCore", "display": "Central Computer Core", "areaId": 9, "hideWorld": 0, },1025: { "worldId": 4, "name": "DarkDepths", "display": "The Dark Depths", "areaId": 1, "hideWorld": 0, },4609: { "worldId": 18, "name": "NeverAlley", "display": "Alley to Between", "areaId": 1, "hideWorld": 0, },552: { "worldId": 2, "name": "Betwixt", "display": "Betwixt and Between", "areaId": 40, "hideWorld": 0, },4610: { "worldId": 18, "name": "NeverCrossing", "display": "Fragment Crossing", "areaId": 2, "hideWorld": 0, },4629: { "worldId": 18, "name": "NeverStation", "display": "Station of Awakening", "areaId": 21, "hideWorld": 1, },4611: { "worldId": 18, "name": "NeverSkyscraper", "display": "Memory’s Skyscraper", "areaId": 3, "hideWorld": 0, },4612: { "worldId": 18, "name": "NeverBrink", "display": "The Brink of Despair", "areaId": 4, "hideWorld": 0, },4614: { "worldId": 18, "name": "NeverCall", "display": "Nothing’s Call", "areaId": 6, "hideWorld": 0, },4615: { "worldId": 18, "name": "NeverAscension", "display": "Crooked Ascension", "areaId": 7, "hideWorld": 0, },4617: { "worldId": 18, "name": "NeverView", "display": "Twilight’s View", "areaId": 9, "hideWorld": 0, },4618: { "worldId": 18, "name": "NeverHall", "display": "Hall of Empty Melodies", "areaId": 10, "hideWorld": 0, },4616: { "worldId": 18, "name": "NeverAscensionDesc", "display": "Crooked Ascension", "areaId": 8, "hideWorld": 0, },4620: { "worldId": 18, "name": "NeverSkyway", "display": "Naught’s Skyway", "areaId": 12, "hideWorld": 0, },4619: { "worldId": 18, "name": "NeverHallBalcony", "display": "Hall of Empty Melodies", "areaId": 11, "hideWorld": 0, },4621: { "worldId": 18, "name": "NeverProof", "display": "Proof of Existence", "areaId": 13, "hideWorld": 0, },4622: { "worldId": 18, "name": "NeverDivide", "display": "Havoc’s Divide", "areaId": 14, "hideWorld": 0, },4623: { "worldId": 18, "name": "NeverImpasse", "display": "Addled Impasse", "areaId": 15, "hideWorld": 0, },4624: { "worldId": 18, "name": "NeverApproach", "display": "Naught’s Approach", "areaId": 16, "hideWorld": 0, },4625: { "worldId": 18, "name": "NeverPassage", "display": "Ruin and Creation’s Passage", "areaId": 17, "hideWorld": 0, },4626: { "worldId": 18, "name": "NeverAltar", "display": "The Altar of Naught", "areaId": 18, "hideWorld": 0, },4627: { "worldId": 18, "name": "NeverContortion", "display": "Memory’s Contortion", "areaId": 19, "hideWorld": 0, },4635: { "worldId": 18, "name": "NeverBeginning", "display": "The World of Nothing: End’s Beginning", "areaId": 27, "hideWorld": 1, },4636: { "worldId": 18, "name": "NeverBeginning2", "display": "The World of Nothing: End’s Beginning", "areaId": 28, "hideWorld": 1, },4634: { "worldId": 18, "name": "NeverCannons", "display": "The World of Nothing: Twin Cannons", "areaId": 26, "hideWorld": 1, },4633: { "worldId": 18, "name": "NeverCore", "display": "The World of Nothing: Energy Core", "areaId": 25, "hideWorld": 1, },4637: { "worldId": 18, "name": "NeverThrone", "display": "The World of Nothing: Xemnas’s Throne Room", "areaId": 29, "hideWorld": 1, },4632: { "worldId": 18, "name": "NeverThrone2", "display": "The World of Nothing: Xemnas’s Throne Room", "areaId": 24, "hideWorld": 1, },4630: { "worldId": 18, "name": "NeverDragon", "display": "The World of Nothing", "areaId": 22, "hideWorld": 1, },4631: { "worldId": 18, "name": "NeverDragonThrone", "display": "The World of Nothing", "areaId": 23, "hideWorld": 1, },4628: { "worldId": 18, "name": "NeverFinal", "display": "The World of Nothing", "areaId": 20, "hideWorld": 1, },256: { "worldId": 1, "name": "DarkMargin", "display": "Dark Margin", "areaId": 0, "hideWorld": 0, },549: { "worldId": 2, "name": "UndergroundConcourse", "display": "Underground Concourse", "areaId": 37, "hideWorld": 0, },1036: { "worldId": 4, "name": "HeartlessManufactory", "display": "Heartless Manufactory", "areaId": 12, "hideWorld": 0, },1048: { "worldId": 4, "name": "CavernMineshaft", "display": "Cavern of Remembrance: Mineshaft", "areaId": 24, "hideWorld": 1, },1058: { "worldId": 4, "name": "DestinyStorm", "display": "Destiny Islands: Storm-Tossed Island", "areaId": 34, "hideWorld": 1, },1062: { "worldId": 4, "name": "StationOfOblivion", "display": "Station of Oblivion", "areaId": 38, "hideWorld": 1, },1046: { "worldId": 4, "name": "CavernMiningArea", "display": "Cavern of Remembrance: Mining Area", "areaId": 22, "hideWorld": 1, },1047: { "worldId": 4, "name": "CavernEngineChamber", "display": "Cavern of Remembrance: Engine Chamber", "areaId": 23, "hideWorld": 1, },1049: { "worldId": 4, "name": "CavernTransport", "display": "Cavern of Remembrance: Transport to Remembrance", "areaId": 25, "hideWorld": 1, },1050: { "worldId": 4, "name": "CavernAssemblage", "display": "Cavern of Remembrance: Garden of Assemblage", "areaId": 26, "hideWorld": 1, },1057: { "worldId": 4, "name": "StationOfOblivion2", "display": "Station of Oblivion", "areaId": 33, "hideWorld": 1, },1056: { "worldId": 4, "name": "StationOfOblivionMansion", "display": "Station of Oblivion", "areaId": 32, "hideWorld": 1, },1538: { "worldId": 6, "name": "ColiseumGatesRuined2", "display": "Coliseum Gates", "areaId": 2, "hideWorld": 0, },2308: { "worldId": 9, "name": "PigletHouse", "display": "Piglet’s House", "areaId": 4, "hideWorld": 0, },2310: { "worldId": 9, "name": "PigletRescue", "display": "Piglet’s House", "areaId": 6, "hideWorld": 0, },2307: { "worldId": 9, "name": "RabbitHouse", "display": "Rabbit’s House", "areaId": 3, "hideWorld": 0, },2311: { "worldId": 9, "name": "HunnySlider", "display": "Rabbit’s House", "areaId": 7, "hideWorld": 0, },2309: { "worldId": 9, "name": "KangaHouse", "display": "Kanga’s House", "areaId": 5, "hideWorld": 0, },2312: { "worldId": 9, "name": "BalloonBounce", "display": "Kanga’s House", "areaId": 8, "hideWorld": 0, },2305: { "worldId": 9, "name": "StarryHill", "display": "Starry Hill", "areaId": 1, "hideWorld": 0, },2313: { "worldId": 9, "name": "SpookyCave", "display": "The Spooky Cave", "areaId": 9, "hideWorld": 0, },2818: { "worldId": 11, "name": "AtlanticaCourtyard", "display": "Undersea Courtyard", "areaId": 2, "hideWorld": 0, },2820: { "worldId": 11, "name": "AtlanticaOrchestra", "display": "Orchestra Hall", "areaId": 4, "hideWorld": 0, },2821: { "worldId": 11, "name": "AtlanticaSunkenShip", "display": "Sunken Ship", "areaId": 5, "hideWorld": 0, },2817: { "worldId": 11, "name": "AtlanticaGrotto", "display": "Ariel’s Grotto", "areaId": 1, "hideWorld": 0, },2819: { "worldId": 11, "name": "AtlanticaCourtyardTwilight", "display": "Undersea Courtyard", "areaId": 3, "hideWorld": 0, },2822: { "worldId": 11, "name": "AtlanticaShore", "display": "The Shore", "areaId": 6, "hideWorld": 0, },2816: { "worldId": 11, "name": "AtlanticaThrone", "display": "Triton’s Throne", "areaId": 0, "hideWorld": 0, },2823: { "worldId": 11, "name": "AtlanticaShoreNight", "display": "The Shore", "areaId": 7, "hideWorld": 0, },2824: { "worldId": 11, "name": "AtlanticaShoreSunset", "display": "The Shore", "areaId": 8, "hideWorld": 0, },2825: { "worldId": 11, "name": "AtlanticaWrath", "display": "Wrath of the Sea", "areaId": 9, "hideWorld": 0, },1293: { "worldId": 5, "name": "BeastBridge2", "display": "Bridge", "areaId": 13, "hideWorld": 0, },3077: { "worldId": 12, "name": "CastleCornerstone2", "display": "The Hall of the Cornerstone", "areaId": 5, "hideWorld": 0, },538: { "worldId": 2, "name": "TowerEntryway", "display": "Tower: Entryway", "areaId": 26, "hideWorld": 1, },528: { "worldId": 2, "name": "MansionDiningRoom", "display": "Mansion: Dining Room", "areaId": 16, "hideWorld": 0, },4608: { "worldId": 18, "name": "NeverGathers", "display": "Where Nothing Gathers", "areaId": 0, "hideWorld": 0, },1051: { "worldId": 4, "name": "ChamberOfRepose", "display": "Chamber of Repose", "areaId": 27, "hideWorld": 0, },3079: { "worldId": 12, "name": "GraveyardBadlands", "display": "Keyblade Graveyard: Badlands", "areaId": 7, "hideWorld": 1, },
}

registeredEvents = {
2: { "eventKey": "Twilight Thorn", "locationCode": "StationOfAwakening", "eventId": 0x9d, "score": 1, "isBoss": 1, "lv1": 1, "isProper": 0 }, 3: { "eventKey": "Axel", "locationCode": "BasementHallAxel", "eventId": 0x89, "score": 5, "isBoss": 1, "lv1": 1, "isProper": 1 }, 4: { "eventKey": "Shan-Yu", "locationCode": "PalaceGate", "eventId": 0x4b, "score": 10, "isBoss": 1, "lv1": 1, "isProper": 1 }, 5: { "eventKey": "Thresholder", "locationCode": "Undercroft", "eventId": 0x48, "score": 10, "isBoss": 1, "lv1": 1, "isProper": 0 }, 6: { "eventKey": "Dark Thorn", "locationCode": "BallroomBattle", "eventId": 0x4f, "score": 10, "isBoss": 1, "lv1": 1, "isProper": 0 }, 7: { "eventKey": "Cerberus", "locationCode": "CaveOfTheDeadEntrance", "eventId": 0x72, "score": 10, "isBoss": 1, "lv1": 1, "isProper": 1 }, 8: { "eventKey": "Olympus Pete", "locationCode": "UnderworldLock2", "eventId": 0x74, "score": 5, "isBoss": 1, "lv1": 1, "isProper": 1 }, 9: { "eventKey": "Timeless Pete", "locationCode": "RiverWharf", "eventId": 0x35, "score": 10, "isBoss": 1, "lv1": 1, "isProper": 1 }, 10: { "eventKey": "Hydra", "locationCode": "ColiseumGatesRuined", "eventId": 0xab, "score": 10, "isBoss": 1, "lv1": 1, "isProper": 0 }, 11: { "eventKey": "Barbossa", "locationCode": "PortHeap", "eventId": 0x3c, "score": 25, "isBoss": 1, "lv1": 1, "isProper": 1 }, 12: { "eventKey": "Prison Keeper", "locationCode": "HalloweenHill", "eventId": 0x34, "score": 10, "isBoss": 1, "lv1": 1, "isProper": 0 }, 13: { "eventKey": "Oogie Boogie", "locationCode": "HalloweenFactory", "eventId": 0x37, "score": 10, "isBoss": 1, "lv1": 1, "isProper": 1 }, 14: { "eventKey": "Volcano and Blizzard Lords", "locationCode": "AgrabahPalace", "eventId": 0x3b, "score": 5, "isBoss": 1, "lv1": 1, "isProper": 0 }, 15: { "eventKey": "Scar", "locationCode": "PridePeakBattle", "eventId": 0x37, "score": 25, "isBoss": 1, "lv1": 1, "isProper": 1 }, 16: { "eventKey": "Pain and Panic Cup", "locationCode": "ColiseumTourney1", "eventId": 0xbd, "score": 10, "isBoss": 0, "lv1": 0, "isProper": 1 }, 17: { "eventKey": "Monitors", "locationCode": "SpaceDataspace", "eventId": 0x36, "score": 0, "isBoss": 0, "lv1": 0, "isProper": 1 }, 18: { "eventKey": "Hostile Program", "locationCode": "SpaceIOTowerHallway", "eventId": 0x37, "score": 10, "isBoss": 1, "lv1": 1, "isProper": 0 }, 19: { "eventKey": "Demyx", "locationCode": "CastleGate", "eventId": 0x37, "score": 25, "isBoss": 1, "lv1": 1, "isProper": 1 }, 20: { "eventKey": "Battle of 1000 Heartless", "locationCode": "GreatMaw", "eventId": 0x42, "score": 10, "isBoss": 0, "lv1": 1, "isProper": 1 }, 21: { "eventKey": "Storm Rider", "locationCode": "ImperialSquare", "eventId": 0x4f, "score": 10, "isBoss": 1, "lv1": 1, "isProper": 0 }, 22: { "eventKey": "Xaldin", "locationCode": "BeastBridge", "eventId": 0x52, "score": 25, "isBoss": 1, "lv1": 1, "isProper": 1 }, 23: { "eventKey": "Hades", "locationCode": "ColiseumTourneyHades", "eventId": 0xca, "score": 10, "isBoss": 1, "lv1": 1, "isProper": 1 }, 24: { "eventKey": "Grim Reaper II", "locationCode": "PortHarbor", "eventId": 0x36, "score": 5, "isBoss": 1, "lv1": 1, "isProper": 0 }, 25: { "eventKey": "Experiment", "locationCode": "HalloweenPlaza", "eventId": 0x40, "score": 25, "isBoss": 1, "lv1": 1, "isProper": 0 }, 26: { "eventKey": "Sandswept Ruins Escape", "locationCode": "AgrabahSand", "eventId": 0x3d, "score": 0, "isBoss": 0, "lv1": 0, "isProper": 1 }, 27: { "eventKey": "Jafar", "locationCode": "AgrabahAbove", "eventId": 0x3e, "score": 10, "isBoss": 1, "lv1": 1, "isProper": 1 }, 28: { "eventKey": "Groundshaker", "locationCode": "PrideSavannahBattle", "eventId": 0x3b, "score": 10, "isBoss": 1, "lv1": 1, "isProper": 0 }, 29: { "eventKey": "Solar Sailer", "locationCode": "SpaceSailerBattle", "eventId": 0x39, "score": 0, "isBoss": 0, "lv1": 0, "isProper": 1 }, 30: { "eventKey": "MCP", "locationCode": "SpaceCore", "eventId": 0x3b, "score": 10, "isBoss": 1, "lv1": 1, "isProper": 0 }, 31: { "eventKey": "Sephiroth", "locationCode": "DarkDepths", "eventId": 0x4b, "score": 50, "isBoss": 1, "lv1": 1, "isProper": 1 }, 32: { "eventKey": "Roxas", "locationCode": "NeverStation", "eventId": 0x41, "score": 25, "isBoss": 1, "lv1": 1, "isProper": 1 }, 33: { "eventKey": "Xigbar", "locationCode": "NeverHall", "eventId": 0x39, "score": 10, "isBoss": 1, "lv1": 1, "isProper": 1 }, 34: { "eventKey": "Luxord", "locationCode": "NeverDivide", "eventId": 0x3a, "score": 5, "isBoss": 1, "lv1": 1, "isProper": 1 }, 35: { "eventKey": "Saïx", "locationCode": "NeverImpasse", "eventId": 0x38, "score": 10, "isBoss": 1, "lv1": 1, "isProper": 1 }, 36: { "eventKey": "Xemnas I", "locationCode": "NeverContortion", "eventId": 0x3b, "score": 10, "isBoss": 1, "lv1": 1, "isProper": 1 }, 37: { "eventKey": "Xemnas Cannons", "locationCode": "NeverCannons", "eventId": 0x45, "score": 0, "isBoss": 0, "lv1": 0, "isProper": 0 }, 38: { "eventKey": "Ending Sequence", "locationCode": "DarkMargin", "eventId": 0x3a, "score": 0, "isBoss": 0, "lv1": 0, "isProper": 1 }, 39: { "eventKey": "Final Xemnas", "locationCode": "NeverFinal", "eventId": 0x4a, "score": 50, "isBoss": 1, "lv1": 1, "isProper": 1 }, 40: { "eventKey": "Mail Delivery", "locationCode": "StationHeights", "eventId": 0xc3, "score": 0, "isBoss": 0, "lv1": 0, "isProper": 0 }, 41: { "eventKey": "Cargo Climb", "locationCode": "StationHeights", "eventId": 0xc1, "score": 0, "isBoss": 0, "lv1": 0, "isProper": 0 }, 42: { "eventKey": "Grandstander", "locationCode": "StationHeights", "eventId": 0xc2, "score": 0, "isBoss": 0, "lv1": 0, "isProper": 0 }, 43: { "eventKey": "Poster Duty", "locationCode": "TramCommon", "eventId": 0xc9, "score": 0, "isBoss": 0, "lv1": 0, "isProper": 0 }, 44: { "eventKey": "Bumble-Buster", "locationCode": "TramCommon", "eventId": 0xc8, "score": 0, "isBoss": 0, "lv1": 0, "isProper": 0 }, 45: { "eventKey": "Junk Sweep", "locationCode": "TramCommon", "eventId": 0xc7, "score": 0, "isBoss": 0, "lv1": 0, "isProper": 0 }, 46: { "eventKey": "Struggle: Hayner", "locationCode": "Sandlot", "eventId": 0xb6, "score": 0, "isBoss": 0, "lv1": 0, "isProper": 0 }, 47: { "eventKey": "Struggle: Setzer", "locationCode": "Sandlot", "eventId": 0xb7, "score": 0, "isBoss": 0, "lv1": 0, "isProper": 0 }, 48: { "eventKey": "Struggle: Seifer", "locationCode": "Sandlot", "eventId": 0xb8, "score": 0, "isBoss": 0, "lv1": 0, "isProper": 0 }, 49: { "eventKey": "Skateboard Street Rave", "locationCode": "TramCommon", "eventId": 0xbb, "score": 0, "isBoss": 0, "lv1": 0, "isProper": 0 }, 50: { "eventKey": "Zexion’s Absent Silhouette", "locationCode": "DestinyStorm", "eventId": 0x97, "score": 10, "isBoss": 1, "lv1": 1, "isProper": 1 }, 51: { "eventKey": "Marluxia’s Absent Silhouette", "locationCode": "StationOfOblivion", "eventId": 0x91, "score": 10, "isBoss": 1, "lv1": 1, "isProper": 1 }, 52: { "eventKey": "Larxene’s Absent Silhouette", "locationCode": "StationOfOblivion2", "eventId": 0x9b, "score": 10, "isBoss": 1, "lv1": 1, "isProper": 1 }, 53: { "eventKey": "Lexaeus’s Absent Silhouette", "locationCode": "StationOfOblivion2", "eventId": 0x8e, "score": 10, "isBoss": 1, "lv1": 1, "isProper": 1 }, 54: { "eventKey": "Vexen’s Absent Silhouette", "locationCode": "StationOfOblivionMansion", "eventId": 0x73, "score": 10, "isBoss": 1, "lv1": 1, "isProper": 1 }, 55: { "eventKey": "Phil’s Training – Maniac Mode", "locationCode": "ColiseumGatesRuined2", "eventId": 0x8f, "score": 0, "isBoss": 0, "lv1": 0, "isProper": 0 }, 56: { "eventKey": "Skateboard Freestyle", "locationCode": "Borough", "eventId": 0x64, "score": 0, "isBoss": 0, "lv1": 0, "isProper": 0 }, 57: { "eventKey": "Skateboard Time Attack", "locationCode": "PortTown", "eventId": 0x58, "score": 0, "isBoss": 0, "lv1": 0, "isProper": 0 }, 58: { "eventKey": "Skateboard Sand Slider", "locationCode": "Agrabah", "eventId": 0x6e, "score": 0, "isBoss": 0, "lv1": 0, "isProper": 0 }, 59: { "eventKey": "Skateboard Workshop Rave", "locationCode": "HalloweenFactory", "eventId": 0x4b, "score": 0, "isBoss": 0, "lv1": 0, "isProper": 0 }, 60: { "eventKey": "Light Cycle", "locationCode": "SpaceGrid", "eventId": 0x3f, "score": 0, "isBoss": 0, "lv1": 0, "isProper": 0 }, 61: { "eventKey": "A Blustery Rescue", "locationCode": "PigletRescue", "eventId": 0x45, "score": 0, "isBoss": 0, "lv1": 0, "isProper": 0 }, 62: { "eventKey": "Hunny Slider", "locationCode": "HunnySlider", "eventId": 0x46, "score": 0, "isBoss": 0, "lv1": 0, "isProper": 0 }, 63: { "eventKey": "Balloon Bounce", "locationCode": "BalloonBounce", "eventId": 0x47, "score": 0, "isBoss": 0, "lv1": 0, "isProper": 0 }, 64: { "eventKey": "The Expotition", "locationCode": "SpookyCave", "eventId": 0x48, "score": 0, "isBoss": 0, "lv1": 0, "isProper": 0 }, 65: { "eventKey": "The Hunny Pot", "locationCode": "StarryHill", "eventId": 0x49, "score": 0, "isBoss": 0, "lv1": 0, "isProper": 0 }, 66: { "eventKey": "Swim This Way", "locationCode": "AtlanticaOrchestra", "eventId": 0x42, "score": 0, "isBoss": 0, "lv1": 0, "isProper": 0 }, 67: { "eventKey": "Part of Your World", "locationCode": "AtlanticaGrotto", "eventId": 0x43, "score": 0, "isBoss": 0, "lv1": 0, "isProper": 0 }, 68: { "eventKey": "Under the Sea", "locationCode": "AtlanticaCourtyard", "eventId": 0x44, "score": 0, "isBoss": 0, "lv1": 0, "isProper": 0 }, 69: { "eventKey": "Ursula’s Revenge", "locationCode": "AtlanticaWrath", "eventId": 0x45, "score": 0, "isBoss": 0, "lv1": 0, "isProper": 0 }, 70: { "eventKey": "A New Day Is Dawning", "locationCode": "AtlanticaOrchestra", "eventId": 0x46, "score": 0, "isBoss": 0, "lv1": 0, "isProper": 0 }, 71: { "eventKey": "Gift Wrapping", "locationCode": "HalloweenWrapping", "eventId": 0x48, "score": 0, "isBoss": 0, "lv1": 0, "isProper": 0 }, 72: { "eventKey": "Xemnas Dragon", "locationCode": "NeverDragon", "eventId": 0x48, "score": 0, "isBoss": 0, "lv1": 0, "isProper": 0 }, 73: { "eventKey": "Magic Carpet", "locationCode": "AgrabahSand", "eventId": 0x6f, "score": 0, "isBoss": 0, "lv1": 0, "isProper": 0 }, 74: { "eventKey": "Data Luxord", "locationCode": "NeverDivide", "eventId": 0x65, "score": 25, "isBoss": 1, "lv1": 1, "isProper": 1 }, 75: { "eventKey": "Data Xemnas 1", "locationCode": "NeverContortion", "eventId": 0x61, "score": 50, "isBoss": 1, "lv1": 1, "isProper": 1 }, 76: { "eventKey": "Data Xemnas 2", "locationCode": "NeverFinal", "eventId": 0x62, "score": 100, "isBoss": 1, "lv1": 1, "isProper": 1 }, 77: { "eventKey": "Data Xigbar", "locationCode": "NeverHall", "eventId": 0x64, "score": 50, "isBoss": 1, "lv1": 1, "isProper": 1 }, 78: { "eventKey": "Data Xaldin", "locationCode": "BeastBridge", "eventId": 0x61, "score": 50, "isBoss": 1, "lv1": 1, "isProper": 1 }, 79: { "eventKey": "Data Vexen", "locationCode": "StationOfOblivionMansion", "eventId": 0x92, "score": 50, "isBoss": 1, "lv1": 1, "isProper": 1 }, 80: { "eventKey": "Data Lexaeus", "locationCode": "StationOfOblivion2", "eventId": 0x93, "score": 25, "isBoss": 1, "lv1": 1, "isProper": 1 }, 81: { "eventKey": "Data Zexion", "locationCode": "DestinyStorm", "eventId": 0x98, "score": 50, "isBoss": 1, "lv1": 1, "isProper": 1 }, 82: { "eventKey": "Data Saïx", "locationCode": "NeverImpasse", "eventId": 0x66, "score": 50, "isBoss": 1, "lv1": 1, "isProper": 1 }, 83: { "eventKey": "Data Axel", "locationCode": "BasementHallAxel", "eventId": 0xd5, "score": 50, "isBoss": 1, "lv1": 1, "isProper": 1 }, 84: { "eventKey": "Data Demyx", "locationCode": "CastleGate", "eventId": 0x72, "score": 50, "isBoss": 1, "lv1": 1, "isProper": 1 }, 85: { "eventKey": "Data Marluxia", "locationCode": "StationOfOblivion", "eventId": 0x96, "score": 100, "isBoss": 1, "lv1": 1, "isProper": 1 }, 86: { "eventKey": "Data Larxene", "locationCode": "StationOfOblivion2", "eventId": 0x94, "score": 50, "isBoss": 1, "lv1": 1, "isProper": 1 }, 87: { "eventKey": "Data Roxas", "locationCode": "NeverStation", "eventId": 0x63, "score": 50, "isBoss": 1, "lv1": 1, "isProper": 1 }, 88: { "eventKey": "Lingering Will", "locationCode": "GraveyardBadlands", "eventId": 0x43, "score": 100, "isBoss": 1, "lv1": 0, "isProper": 0 }, 89: { "eventKey": "Lingering Will 2", "locationCode": "GraveyardBadlands", "eventId": 0x49, "score": 100, "isBoss": 1, "lv1": 0, "isProper": 0 }, 
}

abilities = {
    0x52: { "name": "Guard", "type": "Action", "ap": 2, "id": 0x52, "owner": "Sora" },0x53: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x53, "owner": "N/A" },0x54: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x54, "owner": "N/A" },0x55: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x55, "owner": "N/A" },0x56: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x56, "owner": "N/A" },0x57: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x57, "owner": "N/A" },0x58: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x58, "owner": "N/A" },0x59: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x59, "owner": "N/A" },0x5a: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x5a, "owner": "N/A" },0x5b: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x5b, "owner": "N/A" },0x5c: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x5c, "owner": "N/A" },0x5d: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x5d, "owner": "N/A" },0x5e: { "name": "High Jump LV1", "type": "Growth", "ap": 2, "id": 0x5e, "owner": "Sora" },0x5f: { "name": "High Jump LV2", "type": "Growth", "ap": 2, "id": 0x5f, "owner": "Sora" },0x60: { "name": "High Jump LV3", "type": "Growth", "ap": 2, "id": 0x60, "owner": "Sora" },0x61: { "name": "High Jump MAX", "type": "Growth", "ap": 2, "id": 0x61, "owner": "Sora" },0x62: { "name": "Quick Run LV1", "type": "Growth", "ap": 2, "id": 0x62, "owner": "Sora" },0x63: { "name": "Quick Run LV2", "type": "Growth", "ap": 2, "id": 0x63, "owner": "Sora" },0x64: { "name": "Quick Run LV3", "type": "Growth", "ap": 2, "id": 0x64, "owner": "Sora" },0x65: { "name": "Quick Run MAX", "type": "Growth", "ap": 2, "id": 0x65, "owner": "Sora" },0x66: { "name": "Aerial Dodge LV1", "type": "Growth", "ap": 3, "id": 0x66, "owner": "Sora" },0x67: { "name": "Aerial Dodge LV2", "type": "Growth", "ap": 3, "id": 0x67, "owner": "Sora" },0x68: { "name": "Aerial Dodge LV3", "type": "Growth", "ap": 3, "id": 0x68, "owner": "Sora" },0x69: { "name": "Aerial Dodge MAX", "type": "Growth", "ap": 3, "id": 0x69, "owner": "Sora" },0x6a: { "name": "Glide LV1", "type": "Growth", "ap": 3, "id": 0x6a, "owner": "Sora" },0x6b: { "name": "Glide LV2", "type": "Growth", "ap": 3, "id": 0x6b, "owner": "Sora" },0x6c: { "name": "Glide LV3", "type": "Growth", "ap": 3, "id": 0x6c, "owner": "Sora" },0x6d: { "name": "Glide MAX", "type": "Growth", "ap": 3, "id": 0x6d, "owner": "Sora" },0x6e: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x6e, "owner": "N/A" },0x6f: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x6f, "owner": "N/A" },0x70: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x70, "owner": "N/A" },0x71: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x71, "owner": "N/A" },0x72: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x72, "owner": "N/A" },0x73: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x73, "owner": "N/A" },0x74: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x74, "owner": "N/A" },0x75: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x75, "owner": "N/A" },0x76: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x76, "owner": "N/A" },0x77: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x77, "owner": "N/A" },0x78: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x78, "owner": "N/A" },0x79: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x79, "owner": "N/A" },0x7a: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x7a, "owner": "N/A" },0x7b: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x7b, "owner": "N/A" },0x7c: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x7c, "owner": "N/A" },0x7d: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x7d, "owner": "N/A" },0x7e: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x7e, "owner": "N/A" },0x7f: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x7f, "owner": "N/A" },0x80: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x80, "owner": "N/A" },0x81: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x81, "owner": "N/A" },0x82: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x82, "owner": "N/A" },0x83: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x83, "owner": "N/A" },0x84: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x84, "owner": "N/A" },0x85: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x85, "owner": "N/A" },0x86: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x86, "owner": "N/A" },0x87: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x87, "owner": "N/A" },0x88: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x88, "owner": "N/A" },0x89: { "name": "Upper Slash", "type": "Action", "ap": 4, "id": 0x89, "owner": "Sora" },0x8a: { "name": "Scan", "type": "Support", "ap": 2, "id": 0x8a, "owner": "Sora" },0x8b: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x8b, "owner": "N/A" },0x8c: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x8c, "owner": "N/A" },0x8d: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x8d, "owner": "N/A" },0x8e: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x8e, "owner": "N/A" },0x8f: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x8f, "owner": "N/A" },0x90: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x90, "owner": "N/A" },0x91: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x91, "owner": "N/A" },0x92: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x92, "owner": "N/A" },0x93: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x93, "owner": "N/A" },0x94: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x94, "owner": "N/A" },0x95: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x95, "owner": "N/A" },0x96: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x96, "owner": "N/A" },0x97: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x97, "owner": "N/A" },0x98: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x98, "owner": "N/A" },0x99: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x99, "owner": "N/A" },0x9a: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x9a, "owner": "N/A" },0x9b: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x9b, "owner": "N/A" },0x9c: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x9c, "owner": "N/A" },0x9d: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x9d, "owner": "N/A" },0x9e: { "name": "Aerial Recovery", "type": "Support", "ap": 2, "id": 0x9e, "owner": "Sora" },0x9f: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x9f, "owner": "N/A" },0xa0: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xa0, "owner": "N/A" },0xa1: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xa1, "owner": "N/A" },0xa2: { "name": "Combo Plus", "type": "Support", "ap": 1, "id": 0xa2, "owner": "Sora" },0xa3: { "name": "Air Combo Plus", "type": "Support", "ap": 1, "id": 0xa3, "owner": "Sora" },0xa4: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xa4, "owner": "N/A" },0xa5: { "name": "Donald Fire", "type": "Action", "ap": 2, "id": 0xa5, "owner": "Donald" },0xa6: { "name": "Donald Blizzard", "type": "Action", "ap": 2, "id": 0xa6, "owner": "Donald" },0xa7: { "name": "Donald Thunder", "type": "Action", "ap": 2, "id": 0xa7, "owner": "Donald" },0xa8: { "name": "Donald Cure", "type": "Action", "ap": 3, "id": 0xa8, "owner": "Donald" },0xa9: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xa9, "owner": "N/A" },0xaa: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xaa, "owner": "N/A" },0xab: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xab, "owner": "N/A" },0xac: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xac, "owner": "N/A" },0xad: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xad, "owner": "N/A" },0xae: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xae, "owner": "N/A" },0xaf: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xaf, "owner": "N/A" },0xb0: { "name": "Healing Water", "type": "Action", "ap": 3, "id": 0xb0, "owner": "Auron" },0xb1: { "name": "Furious Shout", "type": "Action", "ap": 2, "id": 0xb1, "owner": "Beast" },0xb2: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xb2, "owner": "N/A" },0xb3: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xb3, "owner": "N/A" },0xb4: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xb4, "owner": "N/A" },0xb5: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xb5, "owner": "N/A" },0xb6: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xb6, "owner": "N/A" },0xb7: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xb7, "owner": "N/A" },0xb8: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xb8, "owner": "N/A" },0xb9: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xb9, "owner": "N/A" },0xba: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xba, "owner": "N/A" },0xbb: { "name": "Cure Potion", "type": "Action", "ap": 3, "id": 0xbb, "owner": "Riku" },0xbe: { "name": "Healing Herb", "type": "Action", "ap": 3, "id": 0xbe, "owner": "Simba" },0xbf: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xbf, "owner": "N/A" },0xc0: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xc0, "owner": "N/A" },0xc1: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xc1, "owner": "N/A" },0xc2: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xc2, "owner": "N/A" },0xc3: { "name": "Slow 3", "type": "Action", "ap": 2, "id": 0xc3, "owner": "N/A" },0xc4: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xc4, "owner": "N/A" },0xc5: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xc5, "owner": "N/A" },0xc6: { "name": "Trinity Limit", "type": "Action", "ap": 5, "id": 0xc6, "owner": "Sora" },0xc7: { "name": "Fantasia", "type": "Action", "ap": 3, "id": 0xc7, "owner": "Donald" },0xc8: { "name": "Flare Force", "type": "Action", "ap": 3, "id": 0xc8, "owner": "Donald" },0xc9: { "name": "Tornado Fusion", "type": "Action", "ap": 3, "id": 0xc9, "owner": "Goofy" },0xca: { "name": "Teamwork", "type": "Action", "ap": 3, "id": 0xca, "owner": "Goofy" },0xcb: { "name": "Trick Fantasy", "type": "Action", "ap": 3, "id": 0xcb, "owner": "Aladdin" },0xcc: { "name": "Overdrive", "type": "Action", "ap": 3, "id": 0xcc, "owner": "Auron" },0xcd: { "name": "Howling Moon", "type": "Action", "ap": 3, "id": 0xcd, "owner": "Beast" },0xce: { "name": "Applause, Applause", "type": "Action", "ap": 3, "id": 0xce, "owner": "Jack" },0xcf: { "name": "Dragonblaze", "type": "Action", "ap": 3, "id": 0xcf, "owner": "Mulan" },0xd0: { "name": "Eternal Session", "type": "Action", "ap": 3, "id": 0xd0, "owner": "Riku" },0xd1: { "name": "King’s Pride", "type": "Action", "ap": 3, "id": 0xd1, "owner": "Simba" },0xd2: { "name": "Treasure Isle", "type": "Action", "ap": 3, "id": 0xd2, "owner": "Jack Sparrow" },0xd3: { "name": "Complete Compilement", "type": "Action", "ap": 3, "id": 0xd3, "owner": "Tron" },0xd4: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xd4, "owner": "N/A" },0xd5: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xd5, "owner": "N/A" },0xd6: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xd6, "owner": "N/A" },0xd7: { "name": "Pulsing Thunder", "type": "Action", "ap": 2, "id": 0xd7, "owner": "Tron" },0xd8: { "name": "Brave Shot", "type": "Action", "ap": 0, "id": 0xd8, "owner": "Valor Form" },0xd9: { "name": "Brave Beat", "type": "Action", "ap": 0, "id": 0xd9, "owner": "Valor Form" },0xda: { "name": "Sonic Strike", "type": "Action", "ap": 0, "id": 0xda, "owner": "Valor Form" },0xdb: { "name": "Sonic End", "type": "Action", "ap": 0, "id": 0xdb, "owner": "Valor Form" },0xdc: { "name": "Wisdom Shot", "type": "Action", "ap": 0, "id": 0xdc, "owner": "Wisdom Form" },0xdd: { "name": "Mobile Action", "type": "Action", "ap": 0, "id": 0xdd, "owner": "Wisdom Form" },0xde: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xde, "owner": "N/A" },0xdf: { "name": "Synch Blade", "type": "Support", "ap": 0, "id": 0xdf, "owner": "Forms" },0xe0: { "name": "Magic Haste", "type": "Support", "ap": 0, "id": 0xe0, "owner": "Wisdom Form" },0xe1: { "name": "Magic Spice", "type": "Action", "ap": 0, "id": 0xe1, "owner": "Wisdom Form" },0xe2: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xe2, "owner": "N/A" },0xe3: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xe3, "owner": "N/A" },0xe4: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xe4, "owner": "N/A" },0xe5: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xe5, "owner": "N/A" },0xe6: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xe6, "owner": "N/A" },0xe7: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xe7, "owner": "N/A" },0xe8: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xe8, "owner": "N/A" },0xe9: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xe9, "owner": "N/A" },0xea: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xea, "owner": "N/A" },0xeb: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xeb, "owner": "N/A" },0xec: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xec, "owner": "N/A" },0xed: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xed, "owner": "N/A" },0xee: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xee, "owner": "N/A" },0xef: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xef, "owner": "N/A" },0xf0: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xf0, "owner": "N/A" },0xf1: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xf1, "owner": "N/A" },0xf2: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xf2, "owner": "N/A" },0xf3: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xf3, "owner": "N/A" },0xf4: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xf4, "owner": "N/A" },0xf5: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xf5, "owner": "N/A" },0xf6: { "name": "Over the Horizon", "type": "Action", "ap": 0, "id": 0xf6, "owner": "Valor Form" },0xf7: { "name": "Omega Finale", "type": "Action", "ap": 0, "id": 0xf7, "owner": "Valor Form" },0xf8: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xf8, "owner": "N/A" },0xf9: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xf9, "owner": "N/A" },0xfa: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xfa, "owner": "N/A" },0xfb: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xfb, "owner": "N/A" },0xfc: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xfc, "owner": "N/A" },0xfd: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xfd, "owner": "N/A" },0xfe: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xfe, "owner": "N/A" },0xff: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0xff, "owner": "N/A" },0x100: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x100, "owner": "N/A" },0x101: { "name": "Master Strike", "type": "Action", "ap": 0, "id": 0x101, "owner": "Master Form" },0x102: { "name": "Disaster", "type": "Action", "ap": 0, "id": 0x102, "owner": "Master Form" },0x103: { "name": "Endless Magic", "type": "Action", "ap": 0, "id": 0x103, "owner": "Master Form" },0x104: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x104, "owner": "N/A" },0x105: { "name": "Master Magic", "type": "Action", "ap": 0, "id": 0x105, "owner": "Master Form" },0x106: { "name": "Slapshot", "type": "Action", "ap": 2, "id": 0x106, "owner": "Sora" },0x107: { "name": "Dodge Slash", "type": "Action", "ap": 2, "id": 0x107, "owner": "Sora" },0x108: { "name": "Slide Dash", "type": "Action", "ap": 2, "id": 0x108, "owner": "Sora" },0x109: { "name": "Guard Break", "type": "Action", "ap": 3, "id": 0x109, "owner": "Sora" },0x10a: { "name": "Explosion", "type": "Action", "ap": 3, "id": 0x10a, "owner": "Sora" },0x10b: { "name": "Finishing Leap", "type": "Action", "ap": 5, "id": 0x10b, "owner": "Sora" },0x10c: { "name": "Counterguard", "type": "Action", "ap": 4, "id": 0x10c, "owner": "Sora" },0x10d: { "name": "Aerial Sweep", "type": "Action", "ap": 2, "id": 0x10d, "owner": "Sora" },0x10e: { "name": "Aerial Spiral", "type": "Action", "ap": 2, "id": 0x10e, "owner": "Sora" },0x10f: { "name": "Horizontal Slash", "type": "Action", "ap": 2, "id": 0x10f, "owner": "Sora" },0x110: { "name": "Aerial Finish", "type": "Action", "ap": 3, "id": 0x110, "owner": "Sora" },0x111: { "name": "Retaliating Slash", "type": "Action", "ap": 3, "id": 0x111, "owner": "Sora" },0x181: { "name": "Auto Valor", "type": "Action", "ap": 1, "id": 0x181, "owner": "Sora" },0x182: { "name": "Auto Wisdom", "type": "Action", "ap": 1, "id": 0x182, "owner": "Sora" },0x183: { "name": "Auto Master", "type": "Action", "ap": 1, "id": 0x183, "owner": "Sora" },0x184: { "name": "Auto Final", "type": "Action", "ap": 1, "id": 0x184, "owner": "Sora" },0x185: { "name": "Auto Summon", "type": "Action", "ap": 1, "id": 0x185, "owner": "Sora" },0x186: { "name": "Combo Boost", "type": "Support", "ap": 5, "id": 0x186, "owner": "Sora" },0x187: { "name": "Air Combo Boost", "type": "Support", "ap": 4, "id": 0x187, "owner": "Sora" },0x188: { "name": "Reaction Boost", "type": "Support", "ap": 2, "id": 0x188, "owner": "Sora" },0x189: { "name": "Finishing Plus", "type": "Support", "ap": 5, "id": 0x189, "owner": "Sora" },0x18a: { "name": "Negative Combo", "type": "Support", "ap": 2, "id": 0x18a, "owner": "Sora" },0x18b: { "name": "Berserk Charge", "type": "Support", "ap": 5, "id": 0x18b, "owner": "Sora" },0x18c: { "name": "Damage Drive", "type": "Support", "ap": 3, "id": 0x18c, "owner": "Sora" },0x18d: { "name": "Drive Boost", "type": "Support", "ap": 3, "id": 0x18d, "owner": "Sora" },0x18e: { "name": "Form Boost", "type": "Support", "ap": 5, "id": 0x18e, "owner": "Sora" },0x18f: { "name": "Summon Boost", "type": "Support", "ap": 5, "id": 0x18f, "owner": "Sora" },0x190: { "name": "Combination Boost", "type": "Support", "ap": 4, "id": 0x190, "owner": "Sora" },0x191: { "name": "Experience Boost", "type": "Support", "ap": 4, "id": 0x191, "owner": "Sora" },0x192: { "name": "Leaf Bracer", "type": "Support", "ap": 1, "id": 0x192, "owner": "Sora" },0x193: { "name": "Magic Lock-On", "type": "Support", "ap": 2, "id": 0x193, "owner": "Sora" },0x194: { "name": "No Experience", "type": "Support", "ap": 1, "id": 0x194, "owner": "Sora" },0x195: { "name": "Draw", "type": "Support", "ap": 3, "id": 0x195, "owner": "Sora" },0x196: { "name": "Jackpot", "type": "Support", "ap": 4, "id": 0x196, "owner": "Sora" },0x197: { "name": "Lucky Lucky", "type": "Support", "ap": 5, "id": 0x197, "owner": "Sora" },0x198: { "name": "Fire Boost", "type": "Support", "ap": 3, "id": 0x198, "owner": "Sora" },0x199: { "name": "Blizzard Boost", "type": "Support", "ap": 4, "id": 0x199, "owner": "Sora" },0x19a: { "name": "Thunder Boost", "type": "Support", "ap": 5, "id": 0x19a, "owner": "Sora" },0x19b: { "name": "Item Boost", "type": "Support", "ap": 2, "id": 0x19b, "owner": "Sora" },0x19c: { "name": "MP Rage", "type": "Support", "ap": 3, "id": 0x19c, "owner": "Sora" },0x19d: { "name": "MP Haste", "type": "Support", "ap": 3, "id": 0x19d, "owner": "Sora" },0x19e: { "name": "Defender", "type": "Support", "ap": 3, "id": 0x19e, "owner": "Sora" },0x19f: { "name": "Second Chance", "type": "Support", "ap": 4, "id": 0x19f, "owner": "Sora" },0x1a0: { "name": "Once More", "type": "Support", "ap": 4, "id": 0x1a0, "owner": "Sora" },0x1a1: { "name": "Auto Limit", "type": "Support", "ap": 1, "id": 0x1a1, "owner": "Party" },0x1a2: { "name": "Auto Change", "type": "Support", "ap": 5, "id": 0x1a2, "owner": "Party" },0x1a3: { "name": "Hyper Healing", "type": "Support", "ap": 3, "id": 0x1a3, "owner": "Party" },0x1a4: { "name": "Auto Healing", "type": "Support", "ap": 3, "id": 0x1a4, "owner": "Party" },0x1a5: { "name": "MP Hastera", "type": "Support", "ap": 4, "id": 0x1a5, "owner": "Sora" },0x1a6: { "name": "MP Hastega", "type": "Support", "ap": 5, "id": 0x1a6, "owner": "Sora" },0x1a7: { "name": "Goofy Tornado", "type": "Action", "ap": 2, "id": 0x1a7, "owner": "Goofy" },0x1a8: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x1a8, "owner": "N/A" },0x1a9: { "name": "Goofy Turbo", "type": "Action", "ap": 2, "id": 0x1a9, "owner": "Goofy" },0x1aa: { "name": "Slash Frenzy", "type": "Action", "ap": 2, "id": 0x1aa, "owner": "Aladdin" },0x1ab: { "name": "Quickplay", "type": "Action", "ap": 2, "id": 0x1ab, "owner": "Aladdin" },0x1ac: { "name": "Divider", "type": "Action", "ap": 2, "id": 0x1ac, "owner": "Auron" },0x1ad: { "name": "Goofy Bash", "type": "Action", "ap": 2, "id": 0x1ad, "owner": "Goofy" },0x1ae: { "name": "Ferocious Lunge", "type": "Action", "ap": 2, "id": 0x1ae, "owner": "Beast" },0x1af: { "name": "Blazing Fury", "type": "Action", "ap": 2, "id": 0x1af, "owner": "Jack" },0x1b0: { "name": "Icy Terror", "type": "Action", "ap": 2, "id": 0x1b0, "owner": "Jack" },0x1b1: { "name": "Bolts of Sorrow", "type": "Action", "ap": 2, "id": 0x1b1, "owner": "Jack" },0x1b2: { "name": "Mushu Fire", "type": "Action", "ap": 2, "id": 0x1b2, "owner": "Mulan" },0x1b3: { "name": "Flametongue", "type": "Action", "ap": 2, "id": 0x1b3, "owner": "Mulan" },0x1b4: { "name": "Dark Shield", "type": "Action", "ap": 2, "id": 0x1b4, "owner": "Riku" },0x1b5: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x1b5, "owner": "N/A" },0x1b6: { "name": "Dark Aura", "type": "Action", "ap": 2, "id": 0x1b6, "owner": "Riku" },0x1b7: { "name": "Fierce Claw", "type": "Action", "ap": 2, "id": 0x1b7, "owner": "Simba" },0x1b8: { "name": "Groundshaker", "type": "Action", "ap": 2, "id": 0x1b8, "owner": "Simba" },0x1b9: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x1b9, "owner": "N/A" },0x1ba: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x1ba, "owner": "N/A" },0x1bb: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x1bb, "owner": "N/A" },0x1bc: { "name": "Scouting Disk", "type": "Action", "ap": 2, "id": 0x1bc, "owner": "Tron" },0x1bd: { "name": "Slow 2", "type": "Action", "ap": 2, "id": 0x1bd, "owner": "N/A" },0x1be: { "name": "No Mercy", "type": "Action", "ap": 2, "id": 0x1be, "owner": "N/A" },0x1bf: { "name": "Rain Storm", "type": "Action", "ap": 2, "id": 0x1bf, "owner": "Jack Sparrow" },0x1c0: { "name": "Bone Smash", "type": "Action", "ap": 2, "id": 0x1c0, "owner": "Jack Sparrow" },0x207: { "name": "Auto Assault", "type": "Action", "ap": 0, "id": 0x207, "owner": "Final Form" },0x208: { "name": "Finishing Blast", "type": "Action", "ap": 0, "id": 0x208, "owner": "Final Form" },0x209: { "name": "Combo Upper", "type": "Action", "ap": 0, "id": 0x209, "owner": "Lion Form" },0x20a: { "name": "Aerial Impulse", "type": "Action", "ap": 0, "id": 0x20a, "owner": "Lion Form" },0x20b: { "name": "Retaliating Slash", "type": "Action", "ap": 0, "id": 0x20b, "owner": "Lion Form" },0x20d: { "name": "Running Tackle", "type": "Action", "ap": 0, "id": 0x20d, "owner": "Lion Form" },0x20e: { "name": "Dash", "type": "Action", "ap": 0, "id": 0x20e, "owner": "Lion Form" },0x20f: { "name": "Final Arcana", "type": "Action", "ap": 0, "id": 0x20f, "owner": "Final Form" },0x210: { "name": "Final Strike", "type": "Action", "ap": 0, "id": 0x210, "owner": "Final Form" },0x211: { "name": "Final Arts", "type": "Action", "ap": 0, "id": 0x211, "owner": "Final Form" },0x212: { "name": "Crime & Punishment", "type": "Action", "ap": 0, "id": 0x212, "owner": "Final Form" },0x213: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x213, "owner": "N/A" },0x214: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x214, "owner": "N/A" },0x215: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x215, "owner": "N/A" },0x216: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x216, "owner": "N/A" },0x217: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x217, "owner": "N/A" },0x218: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x218, "owner": "N/A" },0x219: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x219, "owner": "N/A" },0x21a: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x21a, "owner": "N/A" },0x21b: { "name": "Combo Master", "type": "Support", "ap": 4, "id": 0x21b, "owner": "Sora" },0x21c: { "name": "Drive Converter", "type": "Support", "ap": 5, "id": 0x21c, "owner": "Sora" },0x21d: { "name": "Light & Darkness", "type": "Support", "ap": 1, "id": 0x21d, "owner": "Sora" },0x21e: { "name": "Damage Control", "type": "Support", "ap": 5, "id": 0x21e, "owner": "Sora" },0x22f: { "name": "Flash Step", "type": "Action", "ap": 2, "id": 0x22f, "owner": "Sora" },0x230: { "name": "Aerial Dive", "type": "Action", "ap": 2, "id": 0x230, "owner": "Sora" },0x231: { "name": "Magnet Burst", "type": "Action", "ap": 3, "id": 0x231, "owner": "Sora" },0x232: { "name": "Vicinity Break", "type": "Action", "ap": 2, "id": 0x232, "owner": "Sora" },0x233: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x233, "owner": "N/A" },0x234: { "name": "Dodge Roll LV1", "type": "Growth", "ap": 3, "id": 0x234, "owner": "Sora" },0x235: { "name": "Dodge Roll LV2", "type": "Growth", "ap": 3, "id": 0x235, "owner": "Sora" },0x236: { "name": "Dodge Roll LV3", "type": "Growth", "ap": 3, "id": 0x236, "owner": "Sora" },0x237: { "name": "Dodge Roll MAX", "type": "Growth", "ap": 3, "id": 0x237, "owner": "Sora" },0x238: { "name": "Auto Limit", "type": "Action", "ap": 1, "id": 0x238, "owner": "Sora" },0x239: { "name": "Sonic Blade", "type": "Action", "ap": 0, "id": 0x239, "owner": "Limit Form" },0x23a: { "name": "Ars Arcanum", "type": "Action", "ap": 0, "id": 0x23a, "owner": "Limit Form" },0x23b: { "name": "Strike Raid", "type": "Action", "ap": 0, "id": 0x23b, "owner": "Limit Form" },0x23c: { "name": "Ragnarok", "type": "Action", "ap": 0, "id": 0x23c, "owner": "Limit Form" },0x23d: { "name": "Zantetsuken", "type": "Action", "ap": 0, "id": 0x23d, "owner": "Limit Form" },0x23e: { "name": "Ripple Drive", "type": "Action", "ap": 0, "id": 0x23e, "owner": "Limit Form" },0x23f: { "name": "Hurricane Period", "type": "Action", "ap": 0, "id": 0x23f, "owner": "Limit Form" },0x240: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x240, "owner": "N/A" },0x241: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x241, "owner": "N/A" },0x242: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x242, "owner": "N/A" },0x243: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x243, "owner": "N/A" },0x244: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x244, "owner": "N/A" },0x245: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x245, "owner": "N/A" },0x246: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x246, "owner": "N/A" },0x247: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x247, "owner": "N/A" },0x248: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x248, "owner": "N/A" },0x249: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x249, "owner": "N/A" },0x24a: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x24a, "owner": "N/A" },0x24b: { "name": "Zantetsu Counter", "type": "Action", "ap": 0, "id": 0x24b, "owner": "Limit Form" },0x24c: { "name": "Reflect Combo", "type": "Action", "ap": 0, "id": 0x24c, "owner": "Limit Form" },0x24d: { "name": "HP Gain", "type": "Support", "ap": 0, "id": 0x24d, "owner": "Limit Form" },0x24e: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x24e, "owner": "N/A" },0x24f: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x24f, "owner": "N/A" },0x250: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x250, "owner": "N/A" },0x251: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x251, "owner": "N/A" },0x252: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x252, "owner": "N/A" },0x253: { "name": "N/A", "type": "N/A", "ap": 0, "id": 0x253, "owner": "N/A" },0x254: { "name": "Protect", "type": "Support", "ap": 0, "id": 0x254, "owner": "N/A" },0x255: { "name": "Protera", "type": "Support", "ap": 0, "id": 0x255, "owner": "N/A" },0x256: { "name": "Protega", "type": "Support", "ap": 0, "id": 0x256, "owner": "N/A" },
}

minigames = {
    2: { "basicName": "Overachieving Courier", "basicTarget": 14, "basicScore": 3, "advancedName": "Professional Courier", "advancedTarget": 10, "advancedScore": 5, "lowerIsBetter": 1, "description": "Complete the Mail Delivery minigame in {0} seconds or less.", "eventKey": "Mail Delivery", "leaderboardDesc": "Deliver mail as quickly as you can!", "generate": 1, "struggle": 0, "struggleDesc": "", "useScore": 0, },3: { "basicName": "Overachieving Packmule", "basicTarget": 15, "basicScore": 3, "advancedName": "Professional Packmule", "advancedTarget": 7.5, "advancedScore": 5, "lowerIsBetter": 1, "description": "Complete the Cargo Climb minigame in {0} seconds or less.", "eventKey": "Cargo Climb", "leaderboardDesc": "Push the cargo to the garage as quickly as you can!", "generate": 1, "struggle": 0, "struggleDesc": "", "useScore": 0, },4: { "basicName": "Overachieving Showoff", "basicTarget": 70, "basicScore": 3, "advancedName": "Professional Showoff", "advancedTarget": 100, "advancedScore": 5, "lowerIsBetter": 0, "description": "Complete the Grandstander minigame with a score of {0} or more points.", "eventKey": "Grandstander", "leaderboardDesc": "Hit the ball as many times as you can before it touches the ground!", "generate": 0, "struggle": 0, "struggleDesc": "", "useScore": 0, },5: { "basicName": "Overachieving Mounter", "basicTarget": 50, "basicScore": 5, "advancedName": "Professional Mounter", "advancedTarget": 30, "advancedScore": 10, "lowerIsBetter": 1, "description": "Complete the Poster Duty minigame in {0} seconds or less.", "eventKey": "Poster Duty", "leaderboardDesc": "Put up 20 posters as quickly as you can!", "generate": 1, "struggle": 0, "struggleDesc": "", "useScore": 0, },6: { "basicName": "Overachieving Exterminator", "basicTarget": 15, "basicScore": 5, "advancedName": "Professional Exterminator", "advancedTarget": 10, "advancedScore": 10, "lowerIsBetter": 1, "description": "Complete the Bumble-Buster minigame in {0} seconds or less.", "eventKey": "Bumble-Buster", "leaderboardDesc": "Get rid of all the bees as quickly as you can!", "generate": 1, "struggle": 0, "struggleDesc": "", "useScore": 0, },7: { "basicName": "Overachieving Garbageman", "basicTarget": 10, "basicScore": 3, "advancedName": "Professional Garbageman", "advancedTarget": 6, "advancedScore": 5, "lowerIsBetter": 1, "description": "Complete the Junk Sweep minigame in {0} swings or fewer.", "eventKey": "Junk Sweep", "leaderboardDesc": "Get rid of all the junk in as few swings as possible!", "generate": 0, "struggle": 0, "struggleDesc": "", "useScore": 0, },8: { "basicName": "Overseeded – Hayner", "basicTarget": 0, "basicScore": 3, "advancedName": "Struggle Semifinalist", "advancedTarget": 30, "advancedScore": 5, "lowerIsBetter": 1, "description": "Win a Struggle match against Hayner with a margin of 100 or more points as Sora.", "eventKey": "Struggle: Hayner", "leaderboardDesc": "Win a Struggle match against Hayner by knockout as quickly as possible!", "generate": 1, "struggle": 1, "struggleDesc": "Win a Struggle match against Hayner by knockout within {0} as Sora.", "useScore": 0, },9: { "basicName": "Overseeded – Setzer", "basicTarget": 0, "basicScore": 3, "advancedName": "Struggle Finalist", "advancedTarget": 30, "advancedScore": 5, "lowerIsBetter": 1, "description": "Win a Struggle match against Setzer with a margin of 100 or more points as Sora.", "eventKey": "Struggle: Setzer", "leaderboardDesc": "Win a Struggle match against Setzer by knockout as quickly as possible!", "generate": 1, "struggle": 1, "struggleDesc": "Win a Struggle match against Setzer by knockout within {0} as Sora.", "useScore": 0, },10: { "basicName": "Overseeded – Seifer", "basicTarget": 0, "basicScore": 3, "advancedName": "Struggle Champion", "advancedTarget": 30, "advancedScore": 5, "lowerIsBetter": 1, "description": "Win a Struggle match against Seifer with a margin of 100 or more points as Sora.", "eventKey": "Struggle: Seifer", "leaderboardDesc": "Win a Struggle match against Seifer by knockout as quickly as possible!", "generate": 1, "struggle": 1, "struggleDesc": "Win a Struggle match against Seifer by knockout within {0} as Sora.", "useScore": 0, },11: { "basicName": "Overachieving Street Raver", "basicTarget": 1000, "basicScore": 3, "advancedName": "Professional Street Raver", "advancedTarget": 2000, "advancedScore": 5, "lowerIsBetter": 0, "description": "Complete the Skateboard Street Rave minigame with a score of {0} or more points.", "eventKey": "Skateboard Street Rave", "leaderboardDesc": "Get as many points as you can in the Skateboard Street Rave minigame!", "generate": 0, "struggle": 0, "struggleDesc": "", "useScore": 0, },12: { "basicName": "Overachieving Trainee", "basicTarget": 1000, "basicScore": 3, "advancedName": "Professional Trainee", "advancedTarget": 2000, "advancedScore": 5, "lowerIsBetter": 0, "description": "Complete Phil's Training on Maniac Mode with a score of {0} or more points.", "eventKey": "Phil’s Training – Maniac Mode", "leaderboardDesc": "Get as many points as you can in Phil’s Training on Maniac Mode!", "generate": 0, "struggle": 0, "struggleDesc": "", "useScore": 0, },13: { "basicName": "Overachieving Freestyler", "basicTarget": 200, "basicScore": 3, "advancedName": "Professional Freestyler", "advancedTarget": 500, "advancedScore": 5, "lowerIsBetter": 0, "description": "Complete the Skateboard Freestyle minigame with a score of {0} or more points.", "eventKey": "Skateboard Freestyle", "leaderboardDesc": "Get as many points as you can in the Skateboard Freestyle minigame!", "generate": 0, "struggle": 0, "struggleDesc": "", "useScore": 0, },14: { "basicName": "Overachieving Speedrunner", "basicTarget": 40, "basicScore": 3, "advancedName": "Professional Speedrunner", "advancedTarget": 16.5, "advancedScore": 25, "lowerIsBetter": 1, "description": "Complete the Skateboard Time Attack minigame in {0} seconds or less.", "eventKey": "Skateboard Time Attack", "leaderboardDesc": "Ride through all the checkpoints as fast as possible!", "generate": 1, "struggle": 0, "struggleDesc": "", "useScore": 0, },15: { "basicName": "Overachieving Slider", "basicTarget": 10, "basicScore": 3, "advancedName": "Professional Slider", "advancedTarget": 35, "advancedScore": 10, "lowerIsBetter": 0, "description": "Complete the Skateboard Sand Slider minigame with a score of {0} or more.", "eventKey": "Skateboard Sand Slider", "leaderboardDesc": "Ride through as many checkpoints as you can before time runs out!", "generate": 1, "struggle": 0, "struggleDesc": "", "useScore": 1, },16: { "basicName": "Overachieving Workshop Raver", "basicTarget": 1000, "basicScore": 3, "advancedName": "Professional Workshop Raver", "advancedTarget": 1500, "advancedScore": 5, "lowerIsBetter": 0, "description": "Complete the Skateboard Workshop Rave minigame with a score of {0} or more.", "eventKey": "Skateboard Workshop Rave", "leaderboardDesc": "Get as many points as you can in the Skateboard Workshop Rave minigame!", "generate": 1, "struggle": 0, "struggleDesc": "", "useScore": 1, },17: { "basicName": "Overachieving Cyclist", "basicTarget": 20, "basicScore": 3, "advancedName": "Professional Cyclist", "advancedTarget": 30, "advancedScore": 10, "lowerIsBetter": 0, "description": "Complete the Light Cycle minigame with a score of {0} or more.", "eventKey": "Light Cycle", "leaderboardDesc": "Get as many points as you can in the Light Cycle minigame!", "generate": 1, "struggle": 0, "struggleDesc": "", "useScore": 1, },18: { "basicName": "Overachieving Rescuer", "basicTarget": 18000, "basicScore": 3, "advancedName": "Professional Rescuer", "advancedTarget": 19900, "advancedScore": 25, "lowerIsBetter": 0, "description": "Complete the Blustery Rescue minigame with a score of {0} or more.", "eventKey": "A Blustery Rescue", "leaderboardDesc": "Get as many points as you can in the Blustery Rescue minigame!", "generate": 1, "struggle": 0, "struggleDesc": "", "useScore": 1, },19: { "basicName": "Overachieving Gatherer", "basicTarget": 8000, "basicScore": 3, "advancedName": "Professional Gatherer", "advancedTarget": 9850, "advancedScore": 25, "lowerIsBetter": 0, "description": "Complete the Hunny Slider minigame with a score of {0} or more.", "eventKey": "Hunny Slider", "leaderboardDesc": "Get as many points as you can in the Hunny Slider minigame!", "generate": 1, "struggle": 0, "struggleDesc": "", "useScore": 1, },20: { "basicName": "Overachieving Bouncer", "basicTarget": 2000, "basicScore": 3, "advancedName": "Professional Bouncer", "advancedTarget": 10000, "advancedScore": 50, "lowerIsBetter": 0, "description": "Complete the Balloon Bounce minigame with a score of {0} or more.", "eventKey": "Balloon Bounce", "leaderboardDesc": "Get as many points as you can in the Balloon Bounce minigame!", "generate": 1, "struggle": 0, "struggleDesc": "", "useScore": 1, },21: { "basicName": "Overachieving Explorer", "basicTarget": 90, "basicScore": 3, "advancedName": "Professional Explorer", "advancedTarget": 80, "advancedScore": 5, "lowerIsBetter": 1, "description": "Complete the Expotition minigame in {0} seconds or less.", "eventKey": "The Expotition", "leaderboardDesc": "Finish the Expotition minigame as quickly as you can!", "generate": 1, "struggle": 0, "struggleDesc": "", "useScore": 0, },22: { "basicName": "Overachieving Thrower", "basicTarget": 8000, "basicScore": 3, "advancedName": "Professional Thrower", "advancedTarget": 9500, "advancedScore": 25, "lowerIsBetter": 0, "description": "Complete the Hunny Pot minigame with a score of {0} or more.", "eventKey": "The Hunny Pot", "leaderboardDesc": "Get as many points as you can in the Hunny Pot minigame!", "generate": 1, "struggle": 0, "struggleDesc": "", "useScore": 1, },23: { "basicName": "Overachieving Wrapper", "basicTarget": 150, "basicScore": 3, "advancedName": "Professional Wrapper", "advancedTarget": 175, "advancedScore": 25, "lowerIsBetter": 0, "description": "Complete the Gift Wrapping minigame with a score of {0} or more.", "eventKey": "Gift Wrapping", "leaderboardDesc": "Get as many points as you can in the Gift Wrapping minigame!", "generate": 1, "struggle": 0, "struggleDesc": "", "useScore": 1, },24: { "basicName": "Overachieving Flier", "basicTarget": 65, "basicScore": 3, "advancedName": "Professional Flier", "advancedTarget": 67, "advancedScore": 5, "lowerIsBetter": 0, "description": "Complete the Magic Carpet minigame with a score of {0} or more.", "eventKey": "Magic Carpet", "leaderboardDesc": "DO NOT EXPORT", "generate": 1, "struggle": 0, "struggleDesc": "", "useScore": 1, },
}

worlds = {
1: "Realm of Darkness",
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
14: "Halloween Town",
15: "World Map",
16: "Port Royal",
17: "Space Paranoids",
18: "The World That Never Was",
19: "The World That Never Was",
}

function areaId() => byte(0x32bae1)
function worldId() => byte(0x32bae0)
function currentRound() => byte(0x0032bae2)
function level() => byte(0x32e02f)

function difficulty() => byte(0x32dfc8)

function GetIdsFromObjects(objects)
{
    ret = []
    
    for object in objects
    {
        array_push(ret, object["id"])
    }
    
    return ret
}

// A cluster is defined as an array whose elements all differ by a single quantum value with at least one element.
// For instance, an array containing the values [ 1, 2, 3, 4, 6, 7, 9 ] has three clusters:
// [ 1, 2, 3, 4 ], [ 6, 7 ], and [ 9 ]
function GenerateClustersFromList(data)
{
    clusters = []
    currentElement = -1
    currentCluster = []
    for i in data
    {
        if (i == currentElement + 1 || currentElement == -1)
        {
            currentElement = i
            array_push(currentCluster, currentElement)
        }
        else
        {
            array_push(clusters, currentCluster)
            currentElement = i
            currentCluster = [ currentElement ]
        }
    }
    
    // Get the range we were just working on if it has elements.
    if (length(currentCluster) > 0)
    {
        array_push(clusters, currentCluster)
    }
    
    return clusters
}

function ConvertClustersToRanges(clusters)
{
    ranges = []
    
    for cluster in clusters
    {
        min = cluster[0]
        max = cluster[length(cluster) - 1]
        array_push(ranges, { "min": min, "max": max })
    }
    
    return ranges
}

function GetRangesFromList(list)
{
    return ConvertClustersToRanges(GenerateClustersFromList(list))
}

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

// This function allows the creation of achievements with built-in save protection that deal with a collection of values being set
// throughout the game. The schemas for both parameters are as follows:
//
// cheevo: "name": title
//         "description": self-explanatory
//         "points": self-explanatory
//         "threshold": how many values in the "addresses" dictionary must be set before this achievement is triggered
//
// conditions: "countsWhen": the condition that must be true in order for it to be counted in the total
//             "recalculateWhen": the condition that indicates that relevant values in the condition have changed,
//                                and so everything must be recalculated
//
// onlyAvailableWhen: A condition that must be true in all conditions for the achievement to trigger.
function GenerateCheevoFromConditions(cheevo, conditions, onlyAvailableWhen)
{
    loadedCounts = []
    totalCounts = []
    resetAlt = always_false()

    for i in conditions
    {
        condition = conditions[i]

        // This is the score when the game is loaded. If the loaded score is greater than or equal to the threshold--that is,
        // if the save file would satisfy enough conditions to trigger the achievement on load--this should trigger a
        // permanant pauselock to serve as save protection.
        array_push(loadedCounts, once(condition["countsWhen"] && IsLoadingSaveFile()))

        // We want both loaded and session counts here (that is, we don't care if we're loading a save file when these are tallied).
        // This way, loading a save doesn't invalidate the achievement outright if a player hasn't actually earned it yet.
        array_push(totalCounts, once(condition["countsWhen"]))

        resetAlt = resetAlt || condition["recalculateWhen"]
    }

    xachievement(title = cheevo["name"], description = cheevo["description"], points = cheevo["points"], badge = cheevo["badge"],
        trigger = IsAlwaysInGame() &&
            measured(tally(cheevo["threshold"], totalCounts)) && unless(tally(cheevo["threshold"], loadedCounts))
            && never(resetAlt) && onlyAvailableWhen && (always_false() || never(MenuIsActive()))
    )
}

function SecondsToFormat(value)
{
    leadingZero = ""
    if (value % 60 < 10)
    {
        leadingZero = "0"
    }
    return value / 60 + ":" + leadingZero + value % 60
}

function menuPointer() => dword(0x35f0c0)
function maximumMenuIndex() => byte(menuPointer() - 0xf3a)
function MenuIsActive() => menuPointer() != 0
function gameStarted() => bit0(0x32d803)
function IsAlwaysInGame() => never(Delta(gameStarted()) == 0) && never(MenuIsActive())
function IsLoadingSaveFile() => MenuIsActive() && maximumMenuIndex() == 99

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

function GetRPWorldLookup(override = "")
{
    groups = {}
    
    for hash in areas
    {
        area = areas[hash]
        
        if (area["hideWorld"] == 1)
        {
            groups[hash] = ""
        }
        else if (override != "")
        {
            groups[hash] = override + ": "
        }
        else
        {
            groups[hash] = GetWorldById(area["worldId"]) + ": "
        }
    }
    
    return groups
}

function GetAbilitiesByCallback(callback)
{
    ret = []
    for id in abilities
    {
        ability = abilities[id]
        
        if (callback(ability) == true)
        {
            array_push(ret, ability)
        }
    }
    
    return ret
}

function IsOnTitleScreen() => IsInLocation("Title")
function GetAreaHash(areaId, worldId) => areaId + worldId * 256
function difficultyLookup() => {
    0: "Beginner",
    1: "Standard",
    2: "Proud",
    3: "Critical"
}

function hollowBastionIIIComplete() => bit7(0x0032d84e)
rich_presence_conditional_display(!IsOnTitleScreen() && hollowBastionIIIComplete() == 1 && IsInWorld("Hollow Bastion"), "Level {0}, {1} Mode | {2}{3} | Play time: {4}",
    rich_presence_value("Level", level(), "VALUE"),
    rich_presence_lookup("Difficulty", difficulty(), difficultyLookup()),
    rich_presence_lookup("RadiantDisplay", GetAreaHash(areaId(), worldId()), GetRPWorldLookup("Radiant Garden")),
    rich_presence_lookup("Areas", GetAreaHash(areaId(), worldId()), GetAreaRPLookup()),
    rich_presence_value("Play Time", playTime() / 60, "SECS")
)

rich_presence_conditional_display(!IsOnTitleScreen(), "Level {0}, {1} Mode | {2}{3} | Play time: {4}",
    rich_presence_value("Level", level(), "VALUE"),
    rich_presence_lookup("Difficulty", difficulty(), difficultyLookup()),
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

function GetEventByKey(eventKey)
{
    for i in registeredEvents
    {
        event = registeredEvents[i]
        if (event["eventKey"] == eventKey)
        {
            return event
        }
    }
}

function GivenEventIsHappening(eventKey)
{
    event = GetEventByKey(eventKey)
    return eventId() == event["eventId"] && IsInLocation(event["locationCode"])
}

function BattleCheckpointReached(location, eventId, when = always_true(), overrideNever = false, neverOverride = always_false())
{
    neverClause = never(!IsActiveInTheField()) && never(!IsInLocation(location)) && never(IsDead())
    
    if (overrideNever == true)
    {
        neverClause = neverOverride
    }
    
    return neverClause
        && once(eventId() == eventId && IsActiveInTheField() && IsInLocation(location) && JustBecameActiveInTheField() && when)
}

function GetCheckpointForRegisteredEvent(eventKey, when = always_true(), overrideNever = false, neverOverride = always_false())
{
    event = GetEventByKey(eventKey)
    return BattleCheckpointReached(location = event["locationCode"], eventId = event["eventId"], when = when, overrideNever = overrideNever, neverOverride = neverOverride)
}

function AnyItemWasJustUsedForBaseAddr(baseAddr)
{
    trigger = always_false()
    for i in range(0, 7)
    {
        item = word(baseAddr + i * 2)
        trigger = trigger || Delta(item) > 0 && item == 0
    }
    
    return trigger
}

function AnyItemWasJustUsed()
{
    soraSlot1Addr = 0x32e054
    donaldSlot1Addr = 0x32e168
    goofySlot1Addr = 0x32e27c
    jackSlot1Addr = 0x32ea08
    trigger = AnyItemWasJustUsedForBaseAddr(soraSlot1Addr) || AnyItemWasJustUsedForBaseAddr(donaldSlot1Addr) || AnyItemWasJustUsedForBaseAddr(goofySlot1Addr)
        || AnyItemWasJustUsedForBaseAddr(jackSlot1Addr)
    
    return trigger
}

xachievement(title = "Doing Everything I Can", description = "Perform all three different aerial skateboard tricks before touching the ground.", points = 1,
    trigger = IsActiveInTheField() && tally(3, [ DidMethodGrab(), Did360DegreeSpin(), DidAirWalk() ])
        && never(LandedWithSkateboard()) && never(JustDidGrind()) && never(IdleWithSkateboard())
)

xachievement(title = "We Tech Those [m]", description = "Finish off the Twilight Thorn with the Break Raid reaction command.", points = 10,
    trigger = GetCheckpointForRegisteredEvent("Twilight Thorn")
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

xachievement(title = "Third-Degree Burns [m]", description = "Defeat Axel in the old mansion basement without using items or reaction commands (Proud Mode or higher; Level 4 or below).",
    points = 10, id = 356847, badge = "402041",
    trigger = GetCheckpointForRegisteredEvent("Axel", when = level() <= 4 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(AnyItemWasJustUsed())
        && never(fieldActionId() == 0xfe) // Overtaker when playing as dual-wielding Roxas
        && never(fieldActionId() == 0xfc) // Burst Frontier
)

function prologueComplete() => bit4(0x32d812)
xachievement(title = "Summer Sets", description = "Complete the prologue.", points = 3,
    trigger = WasBitflagSetInGame(prologueComplete())
)

function samuraiNobodiesDefeated() => word(0x32f40c)
xachievement(title = "You're Already Dead", description = "Defeat a Samurai Nobody using the Duel Stance reaction command.", points = 3,
    trigger = once(reactionCommandId() == 0x12d && Delta(reactionCommandId()) != 0x12d) && trigger_when(once(fieldActionId() == 0xfd && Delta(fieldActionId()) == 0xfc))
        && trigger_when(Delta(samuraiNobodiesDefeated()) < samuraiNobodiesDefeated()) && never(fieldActionId() != 0xfd && Delta(fieldActionId()) == 0xfd)
        && never(!IsActiveInTheField())
)

function redMeteorId() => 0x8e
xachievement(title = "Bursting in Air [m]", description = "Finish off Shan-Yu with the Red Meteor Limit finisher (Proud Mode or higher; Level 10 or below; no rescues).", points = 10,
    trigger = GetCheckpointForRegisteredEvent("Shan-Yu", when = level() <= 10 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(reactionCommandId() == redMeteorId() && BonusObtained())
)

function landOfDragonsFirstVisitComplete() => bit2(0x32d8c2)
xachievement(title = "Unquestionable Honor", description = "Complete the first visit to the Land of Dragons.", points = 3,
    trigger = WasBitflagSetInGame(landOfDragonsFirstVisitComplete()) && IsInLocation("WorldMap")
)

function currentForm() => byte(0x32f054)
function JustEnteredValorForm() => currentForm() == 1 && Delta(currentForm()) != 1
xachievement(title = "Pure of Mind [m]", description = "Defeat the Thresholder and Possessor without using items or Valor Form (Proud Mode or higher; Level 13 or below; no rescues).", points = 5,
    id = 356852, badge = "402046",
    trigger = GetCheckpointForRegisteredEvent("Thresholder", when = level() <= 13 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(AnyItemWasJustUsed()) && never(JustEnteredValorForm())
)

function limitPointer() => dword(0x1d48cb0)
function LimitIsBeingUsed() => limitPointer() != 0
xachievement(title = "Silence Is Golden [m]", description = "Defeat the Dark Thorn without using Limits (Proud Mode or higher; Level 16 or below; no rescues).", points = 25,
    trigger = GetCheckpointForRegisteredEvent("Dark Thorn", when = level() <= 16 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(LimitIsBeingUsed())
)

function beastCastleFirstVisitComplete() => bit7(0x32d861)
xachievement(title = "Tending the Garden", description = "Complete the first visit to Beast's Castle.", points = 3,
    trigger = WasBitflagSetInGame(beastCastleFirstVisitComplete()) && IsInLocation("WorldMap")
)

function hadesEscapeTimeLimit() => 150
function gameState() => byte(0x32b984)
function TimeIsFlowingNormally() => gameState() == 1
function FrameAdvanced() => Delta(playTime()) != playTime() && TimeIsFlowingNormally()
function hadesEscapeEventId() => 0x6f
function escapedFromHadesEventId() => 0x3
function EscapeFromHadesTimeLimitReached() => repeated(hadesEscapeTimeLimit() * 60, FrameAdvanced())
function EscapedFromHades() => trigger_when(Delta(eventId()) == hadesEscapeEventId() && eventId() == escapedFromHadesEventId())
function hadesEscapeBitflag() => bit3(0x32d889)
function HadesEscapeBitflagFlipped() => Delta(hadesEscapeBitflag()) != hadesEscapeBitflag()
xachievement(title = "Tight Deadline [m]", description = "Escape from the Valley of the Dead with Auron within " + SecondsToFormat(hadesEscapeTimeLimit())
    + " (Proud Mode or higher; Level 18 or below).",
    points = 5,
    trigger = BattleCheckpointReached(location = "ValleyOfTheDead", eventId = 0x6f, when = level() <= 18 && IsAtLeastOnDifficulty("Proud"),
        overrideNever = true,
        neverOverride = never(!IsActiveInTheField() && unless(HadesEscapeBitflagFlipped())) && never(!IsInLocation("ValleyOfTheDead") && unless(HadesEscapeBitflagFlipped())) && never(IsDead()))
        && never(EscapeFromHadesTimeLimitReached())
        && EscapedFromHades()
)

xleaderboard(title = "Tight Deadline", description = "Escape from the Valley of the Dead with Auron as quickly as possible.",
    start = BattleCheckpointReached(location = "ValleyOfTheDead", eventId = 0x6f, when = level() <= 18 && IsAtLeastOnDifficulty("Proud")),
    cancel = IsDead(),
    submit = EscapedFromHades(),
    value = LMeasured(FrameAdvanced()),
    format = "FRAMES",
    lower_is_better = true,
    id = 77689
)

xachievement(title = "Way of the Pacifist [m]", description = "Defeat Cerberus without using Bushido (Proud Mode or higher; Level 18 or below; no rescues).", points = 5,
    trigger = GetCheckpointForRegisteredEvent("Cerberus", when = level() <= 18 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(LimitIsBeingUsed())
)

function SecondsToFrames(seconds) => seconds * 60
function timeRemaining() => dword(0x349df8)
function breakneckBreakdanceTimeLimit() => 50
function demyxITimeLimit() => 80
xachievement(title = "Breakneck Breakdance [m]", description = "Defeat 100 of Demyx's water forms within " + breakneckBreakdanceTimeLimit() + " seconds.", points = 5,
    id = 356857, badge = "402051",
    trigger = BattleCheckpointReached(location = "UnderworldCavernsAtrium", eventId = 0x7b)
        && trigger_when(BonusObtained())
        && never(timeRemaining() < SecondsToFrames(demyxITimeLimit() - breakneckBreakdanceTimeLimit()) && Delta(timeRemaining()) > timeRemaining())
)

function petePinballTimeLimit() => 40
function peteHerculesOverallTimeLimit() => 90
xachievement(title = "Skill Shot [m]", description = "Help Hercules defeat Pete at the Lock within " + petePinballTimeLimit() + " seconds (Proud Mode or higher; Level 18 or below; no rescues).",
    points = 5,
    trigger = GetCheckpointForRegisteredEvent("Olympus Pete", when = level() <= 18 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(timeRemaining() < SecondsToFrames(peteHerculesOverallTimeLimit() - petePinballTimeLimit()))
)

xachievement(title = "Aerophobia [m]", description = "Defeat the Hydra without using the Pegasus Run reaction command (Proud Mode or higher; Level 18 or below; no rescues).",
    points = 5,
    trigger = GetCheckpointForRegisteredEvent("Hydra", when = level() <= 18 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(reactionCommandId() == 0x14f)
)

function olympusColiseumFirstVisitComplete() => bit2(0x32d884)
xachievement(title = "Strength of Guilt", description = "Complete the first visit to Olympus Coliseum.", points = 3,
    trigger = WasBitflagSetInGame(olympusColiseumFirstVisitComplete()) && IsInLocation("WorldMap")
)

function faithLimit() => 3
xachievement(title = "O Ye of Little Faith [m]", description = "Escort Queen Minnie through the audience chamber without using the Faith reaction command more than " + faithLimit() + " times "
    + "(Proud Mode or higher; Level 20 or below).",
    points = 5,
    trigger = BattleCheckpointReached(location = "CastleAudienceChamber", eventId = 0x33, when = level() <= 20 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(repeated(faithLimit() + 1, reactionCommandId() == 0x17d && Delta(reactionCommandId()) == 0))
)
        
function healBlockerLimit() => 50
function peteEnemySlotHP() => dword(0x1c6bdb0)
xachievement(title = "Heal Blocker [m]", description = "Defeat Pete for the second time in Timeless River without letting him restore more than " + healBlockerLimit()
    + " HP (Proud Mode or higher; Level 21 or below).", points = 5,
    trigger = GetCheckpointForRegisteredEvent("Timeless Pete", when = level() <= 21 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(repeated(healBlockerLimit() + 1, Delta(peteEnemySlotHP()) < peteEnemySlotHP()))
)

function disneyCastleComplete() => bit2(0x32d942)
xachievement(title = "Historic Preservation", description = "Complete Disney Castle.", points = 3,
    trigger = WasBitflagSetInGame(disneyCastleComplete()) && IsInLocation("WorldMap")
)

// todo: duplicated code here...
function HasAbilityWithGivenIdEquipped(id)
{
    slot1Addr = 0x32e074
    totalSlots = 80
    trigger = always_false()
    
    for i in range(0, totalSlots - 1)
    {
        abilityId = byte(slot1Addr + i * 2) + low4(slot1Addr + i * 2 + 1) * 256
        abilityIsEquipped = high4(slot1Addr + i * 2 + 1) == 8
        trigger = trigger || abilityId == id && abilityIsEquipped
    }
    
    return trigger
}

function HasAbilityWithinGivenRangeEquipped(range)
{
    slot1Addr = 0x32e074
    totalSlots = 80
    trigger = always_false()
    
    for i in range(0, totalSlots - 1)
    {
        abilityId = byte(slot1Addr + i * 2) + low4(slot1Addr + i * 2 + 1) * 256
        abilityIsEquipped = high4(slot1Addr + i * 2 + 1) == 8
        trigger = trigger || abilityId >= range["min"] && abilityId <= range["max"] && abilityIsEquipped
    }
    
    return trigger
}
// end of todo

function exp() => dword(0x32f210)
function IsInAntiForm() => currentForm() == 6
xachievement(title = "Pacifism [m]", description = "Survive the one-minute pirate attack at the Isla de Muerta without defeating any enemies, without items, and without entering Antiform"
    + " (Proud Mode or higher; Level 23 or below; No Experience must not be equipped).",
    points = 5, id = 356866, badge = "402060",
    trigger = BattleCheckpointReached(location = "PortCaveMouth", eventId = 0x3b, when = level() <= 23 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(timeRemaining() <= 0 && Delta(timeRemaining()) > 0)
        && never(Delta(exp()) < exp())
        && never(HasAbilityWithGivenIdEquipped(0x194))
        && never(AnyItemWasJustUsed())
        && never(IsInAntiForm())
)

xachievement(title = "Sticky Fingers [m]", description = "Protect the cursed medallion from the pirates without it getting stolen (Proud Mode or higher; Level 23 or below).", points = 10,
    trigger = BattleCheckpointReached(location = "PortInterceptorDualBattle", eventId = 0x3a, when = level() <= 23 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(timeRemaining() < Delta(timeRemaining()))
)

function fieldMp() => dword(0x1c6c8d0)
function JustUsedMagicWithId(id) => fieldActionId() == id && Delta(fieldMp()) > fieldMp()
function JustUsedFire() => JustUsedMagicWithId(0x38)
function IsUsingFire() => fieldActionId() == 0x38
function JustUsedFireFinisher() => JustUsedMagicWithId(0x39)
function JustUsedBlizzard() => JustUsedMagicWithId(0x3b)
function JustUsedBlizzardFinisher() => JustUsedMagicWithId(0x3c)
function JustUsedThunder() => JustUsedMagicWithId(0x3e)
function JustUsedThunderFinisher() => JustUsedMagicWithId(0x3f)
function JustUsedReflect() => JustUsedMagicWithId(0x47)
function JustUsedReflectFinisher() => JustUsedMagicWithId(0x48)
function JustUsedMagnet() => JustUsedMagicWithId(0x44)
function JustUsedCure() => JustUsedMagicWithId(0x41)

function UsedAnyMagic()
{
    trigger = always_false()
    for magic in [
        JustUsedFire(),
        JustUsedFireFinisher(),
        JustUsedBlizzard(),
        JustUsedBlizzardFinisher(),
        JustUsedThunder(),
        JustUsedThunderFinisher(),
        JustUsedReflect(),
        JustUsedReflectFinisher(),
        JustUsedMagnet(),
        JustUsedCure()
    ]
    {
        trigger = trigger || magic
    }
    
    return trigger
}

// Drive Forms, especially Wisdom Form, are still allowed and can be used to projectile camp. Afterwards, liberal use of reaction commands can help turn the tides.
xachievement(title = "Swashbuckler [m]", description = "Defeat Barbossa without using magic (Proud Mode or higher; Level 23 or below).", points = 25,
    trigger = GetCheckpointForRegisteredEvent("Barbossa", when = level() <= 23 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(UsedAnyMagic())
)

function portRoyalIComplete() => bit5(0x32d9c9)
xachievement(title = "A Curse Lifted", description = "Complete the first visit to Port Royal.", points = 3,
    trigger = WasBitflagSetInGame(portRoyalIComplete()) && IsInLocation("WorldMap")
)

function prisonKeeperTimeLimit() => 123
function PrisonKeeperTimeLimitReached() => repeated(prisonKeeperTimeLimit() * 60, FrameAdvanced())
xachievement(title = "Escape Artist [m]", description = "Defeat the Prison Keeper within " + SecondsToFormat(prisonKeeperTimeLimit()) + " (Proud Mode or higher; Level 24 or below).", points = 10,
    trigger = GetCheckpointForRegisteredEvent("Prison Keeper", when = level() <= 24 && IsAtLeastOnDifficulty("Proud"))
        && never(PrisonKeeperTimeLimitReached())
        && trigger_when(BonusObtained())
)

xleaderboard(title = "Escape Artist", description = "Defeat the Prison Keeper as quickly as possible.",
    start = GetCheckpointForRegisteredEvent("Prison Keeper", when = level() <= 24 && IsAtLeastOnDifficulty("Proud")),
    cancel = IsDead(),
    submit = BonusObtained(),
    value = LMeasured(FrameAdvanced()),
    format = "FRAMES"
)

function currentDrivePoints() => byte(0x1c6c901)
xachievement(title = "Sandbagging Clause [m]", description = "Defeat Oogie Boogie without using items or Drive Points (Proud Mode or higher; Level 24 or below).", points = 10,
    trigger = GetCheckpointForRegisteredEvent("Oogie Boogie", when = level() <= 24 && IsAtLeastOnDifficulty("Proud"))
        && never(AnyItemWasJustUsed())
        && never(Delta(currentDrivePoints()) > currentDrivePoints())
        && trigger_when(BonusObtained())
)

function halloweenTownIComplete() => bit4(0x32d986)
xachievement(title = "A Day in One's Shoes", description = "Complete the first visit to Halloween Town.", points = 3,
    trigger = WasBitflagSetInGame(halloweenTownIComplete()) && IsInLocation("WorldMap")
)

function chasmTimeLimit() => 85
function timerState() => byte(0x349dec)
function TimedEventEnded() => timerState() == 4 && Delta(timerState()) == 0
function TimerAdvanced() => Delta(timeRemaining()) > timeRemaining()
function SpeedfallerCheckpointReached() => BattleCheckpointReached(location = "AgrabahCaveChasm", eventId = 0x4f, when = level() <= 25 && IsAtLeastOnDifficulty("Proud"))
        || BattleCheckpointReached(location = "AgrabahCaveChasm", eventId = 0x50, when = level() <= 25 && IsAtLeastOnDifficulty("Proud"))
function SpeedfallerTriggered() => TimedEventEnded() && TimerAdvanced()
xachievement(title = "Speedfaller [m]", description = "Complete the Chasm of Challenges in " + SecondsToFormat(chasmTimeLimit()) + " (Proud Mode or higher; Level 25 or below; no Limits).",
    points = 5, id = 356873, badge = "402067",
    trigger = SpeedfallerCheckpointReached()
        && never(timeRemaining() < SecondsToFrames(120 - chasmTimeLimit()) && TimerAdvanced())
        && trigger_when(SpeedfallerTriggered())
        && never(LimitIsBeingUsed())
)

function GlobalTimerCanceled() => IsDead() || timeRemaining() == 0 && TimerAdvanced()
xleaderboard(title = "Speedfaller", description = "Complete the Chasm of Challenges as quickly as you can without using Limits.",
    start = SpeedfallerCheckpointReached() && never(GlobalTimerCanceled()), // Adding the cancelation code here to ensure all hit targets are cleared on subsequent retries.
    cancel = (GlobalTimerCanceled() || LimitIsBeingUsed()),
    submit = SpeedfallerTriggered(),
    value = SecondsToFrames(120) - timeRemaining(),
    format = "FRAMES",
    lower_is_better = true,
    id = 77691
)

function JustEnteredValorForm() => currentForm() == 1 && Delta(currentForm()) != 1
function JustEnteredWisdomForm() => currentForm() == 2 && Delta(currentForm()) != 2
function JustEnteredLimitForm() => currentForm() == 3 && Delta(currentForm()) != 3
function JustEnteredMasterForm() => currentForm() == 4 && Delta(currentForm()) != 4
function JustEnteredFinalForm() => currentForm() == 5 && Delta(currentForm()) != 5
function JustEnteredAntiForm() => currentForm() == 6 && Delta(currentForm()) != 6
function JustUsedDriveForm() => JustEnteredValorForm() && JustEnteredWisdomForm() && JustEnteredMasterForm() && JustEnteredLimitForm() && JustEnteredFinalForm() && JustEnteredAntiForm()
xachievement(title = "Solo Heist [m]", description = "Defeat the Heartless ambush in the Cave of Wonders Treasure Room without using Drive Points or Limits (Proud Mode or higher; Level 25 or below).",
    points = 25,
    trigger = BattleCheckpointReached(location = "AgrabahCaveTreasure", eventId = 0x3a, when = level() <= 25 && IsAtLeastOnDifficulty("Proud"))
        && never(LimitIsBeingUsed())
        && never(Delta(currentDrivePoints()) > currentDrivePoints())
        && trigger_when(BonusObtained())
)

xachievement(title = "Too Hot Inside, Too Cold Outside [m]", description = "Defeat the Volcano and Blizzard Lords without using MP or the Firagun or Blizzagun reaction commands "
    + "(Proud Mode or higher; Level 25 or below).", points = 5, id = 356875, badge = "402069",
    trigger = GetCheckpointForRegisteredEvent("Volcano and Blizzard Lords", when = level() <= 25 && IsAtLeastOnDifficulty("Proud"))
        && never(UsedAnyMagic())
        // Checking the field action ID is needed because the reaction command ID doesn't actually update until after the second part of the combo is active.
        && never(reactionCommandId() == 0x295 || fieldActionId() == 0xfc) // Firagun
        && never(reactionCommandId() == 0x296 || fieldActionId() == 0xfc) // Blizzagun
        && never(fieldMp() < Delta(fieldMp()))
        && trigger_when(BonusObtained())
)

function agrabahIComplete() => bit4(0x32d8a3)
xachievement(title = "Forever Sealed?", description = "Complete the first visit to Agrabah.", points = 3,
    trigger = WasBitflagSetInGame(agrabahIComplete())
)

xachievement(title = "One-Trick Lion [m]", description = "Protect Timon and Pumbaa using only one type of non-Cure magic spell and no items (Proud Mode or higher; Level 27 or below).",
    points = 5,
    trigger = BattleCheckpointReached(location = "PrideDen", eventId = 0x33, when = level() <= 27 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(JustUsedCure())
        && never(AnyItemWasJustUsed())
        // We don't have to check for finishers here because Lion Form doesn't use them.
        && never(tally(2, [ once(JustUsedFire()), once(JustUsedBlizzard()), once(JustUsedThunder()), once(JustUsedReflect()), once(JustUsedMagnet()) ]))
)

// This fight sucks, and no number of challenges will make this any more fun or less frustrating, so I'm throwing players a bone here.
xachievement(title = "Dull Claws [m]", description = "Defeat Scar on Proud Mode or higher at Level 27 or below.", points = 10,
    trigger = GetCheckpointForRegisteredEvent("Scar", when = level() <= 27 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
)

function prideLandsIComplete() => bit5(0x32d905)
xachievement(title = "Return of the King", description = "Complete the first visit to the Pride Lands.", points = 3,
    trigger = WasBitflagSetInGame(prideLandsIComplete())
)

function forkBomberTimeLimit() => 60
function ForkBomberCheckpointReached() => GetCheckpointForRegisteredEvent("Monitors", when = level() <= 29 && IsAtLeastOnDifficulty("Proud"))
xachievement(title = "Fork Bomber [m]", description = "Freeze all the security monitors in Space Paranoids within " + forkBomberTimeLimit() + " seconds (Proud Mode or higher; Level 29 or below).",
    points = 10,
    trigger = ForkBomberCheckpointReached()
        && never(timeRemaining() < SecondsToFrames(120 - forkBomberTimeLimit()) && TimerAdvanced())
        && trigger_when(BonusObtained())
)

xachievement(title = "Resource Hog [m]", description = "Defeat the Hostile Program without using the Freeze reaction command more than once (Proud Mode or higher; Level 29 or below).",
    points = 10,
    trigger = GetCheckpointForRegisteredEvent("Hostile Program", when = level() <= 29 && IsAtLeastOnDifficulty("Proud"))
        && never(repeated(2, reactionCommandId() == 0x267 && Delta(reactionCommandId()) == 0))
        && trigger_when(BonusObtained())
)

xleaderboard(title = "Fork Bomber", description = "Freeze all the security monitors in the Space Paranoids Dataspace as quickly as you can.",
    start = ForkBomberCheckpointReached(),
    cancel = GlobalTimerCanceled(),
    submit = BonusObtained(),
    value = SecondsToFrames(120) - timeRemaining(),
    format = "FRAMES",
    lower_is_better = true
)

function BaseSoraHasAnyGivenAbilityEquipped(subset)
{
    trigger = always_false()
    abilityIds = GetIdsFromObjects(subset)
    abilityIdRanges = GetRangesFromList(abilityIds)
    for range in abilityIdRanges
    {
        trigger = trigger || HasAbilityWithinGivenRangeEquipped(range)
    }
    
    return trigger
}

growthAbilities = GetAbilitiesByCallback(ability => ability["type"] == "Growth")
xachievement(title = "Two Left Feet [m]", description = "Defeat Demyx without any Growth Abilities equipped (Proud Mode or higher; Level 31 or below).", points = 25,
    trigger = GetCheckpointForRegisteredEvent("Demyx", when = level() <= 31 && IsAtLeastOnDifficulty("Proud"))
        && never(BaseSoraHasAnyGivenAbilityEquipped(growthAbilities))
        && trigger_when(BonusObtained())
)

function mpChargeTimeRemaining() => float(0x01c6c90c)
xachievement(title = "Vampiricism [m]", description = "Survive the Battle of 1000 Heartless without ever using items or entering MP Charge (Proud Mode or higher; Level 32 or below).", points = 10,
    trigger = GetCheckpointForRegisteredEvent("Battle of 1000 Heartless", when = level() <= 32 && IsAtLeastOnDifficulty("Proud"))
        && never(Delta(mpChargeTimeRemaining()) == 0.0 && mpChargeTimeRemaining() > 0.0)
        && never(AnyItemWasJustUsed())
        && trigger_when(BonusObtained())
)

function hollowBastionIIComplete() => bit6(0x0032d84e)
xachievement(title = "Three Pawns", description = "Complete the second visit to Hollow Bastion.", points = 3,
    trigger = WasBitflagSetInGame(hollowBastionIIComplete())
)

function IsInWisdomForm() => currentForm() == 2
xachievement(title = "Spellblade [m]", description = "Defeat the Storm Rider while Wisdom Form or Antiform is active (Proud Mode or higher; Level 34 or below).", points = 10,
    trigger = GetCheckpointForRegisteredEvent("Storm Rider", when = level() <= 34 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && trigger_when(IsInWisdomForm() || IsInAntiForm())
)

function landOfDragonsIIComplete() => bit7(0x0032d8c1)
xachievement(title = "Hand Clenched in Hand", description = "Complete the second visit to the Land of Dragons.", points = 3,
    trigger = WasBitflagSetInGame(landOfDragonsIIComplete())
)

function numberOfJumpsStored() => byte(0x01c5fdf8)
function StoredAJump() => Delta(numberOfJumpsStored()) + 1 == numberOfJumpsStored()
function jumpLimit() => 10
xachievement(title = "Truancy [m]", description = "Defeat Xaldin without charging up more than " + jumpLimit() + " Jump commands (Proud Mode or higher; Level 37 or below; no rescues).", points = 50,
    trigger = GetCheckpointForRegisteredEvent("Xaldin", when = level() <= 37 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(repeated(jumpLimit() + 1, StoredAJump()))
)

// todo: WTF do I even name this achievement???
function beastCastleIIComplete() => bit2(0x0032d862)
xachievement(title = "Blooming Love", description = "Complete the second visit to Beast's Castle.", points = 3,
    trigger = WasBitflagSetInGame(beastCastleIIComplete())
)

xachievement(title = "Short of Godhood [m]", description = "Defeat Hades without using Aura Sphere or Aura Guard (Proud Mode or higher; Level 38 or below).", points = 5,
    trigger = GetCheckpointForRegisteredEvent("Hades", when = level() <= 38 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(reactionCommandId() == 0x13b) // Aura Guard
        && never(reactionCommandId() == 0x1cf) // Aura Sphere
)

function olympusColiseumIIComplete() => bit6(0x0032d884)
xachievement(title = "Phil's Boys", description = "Complete the second visit to Olympus Coliseum.", points = 3,
    trigger = WasBitflagSetInGame(olympusColiseumIIComplete())
)

function ToxicGreedCheckpointReached() => GetCheckpointForRegisteredEvent("Grim Reaper II", when = level() <= 40 && IsAtLeastOnDifficulty("Proud"))
function medallionsBeingHeld() => dword(0x01d48efc) // Note that this is the same address as the one that holds the player's Underdrome score!
function SoraIsHoldingAMedallion() => medallionsBeingHeld() > 0
function toxicGreedTimeLimit() => 90
function FrameAdvancedWhileHoldingMedallion() => FrameAdvanced() && SoraIsHoldingAMedallion()

xachievement(title = "Creeping Curse [m]", description = "Defeat the Grim Reaper before spending a total of " + SecondsToFormat(toxicGreedTimeLimit()) + " holding a medallion "
    + "(Proud Mode or higher; Level 40 or below).", points = 10,
    trigger = ToxicGreedCheckpointReached()
        && trigger_when(BonusObtained())
        && never(repeated(SecondsToFrames(toxicGreedTimeLimit()), FrameAdvancedWhileHoldingMedallion()))
)

xleaderboard(title = "Creeping Curse", description = "Defeat the Grim Reaper while holding medallions for as little time as possible.",
    start = ToxicGreedCheckpointReached(),
    cancel = IsDead(),
    submit = BonusObtained(),
    value = LMeasured(FrameAdvancedWhileHoldingMedallion()),
    format = "FRAMES",
    lower_is_better = true
)

function portRoyalIIComplete() => bit0(0x0032d9ca)
xachievement(title = "As Free as the Winds", description = "Complete the second visit to Port Royal.", points = 3,
    trigger = WasBitflagSetInGame(portRoyalIIComplete())
)

function currentSummon() => byte(0x0032f055)
function JustUsedAnySummon() => Delta(currentSummon()) == 0 && currentSummon() != 0
xachievement(title = "Out of Harm's Way [m]", description = "Defeat the Experiment without using Summons (Proud Mode or higher; Level 41 or below).",
    points = 10,
    trigger = GetCheckpointForRegisteredEvent("Experiment", when = level() <= 41 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(JustUsedAnySummon())
)

function halloweenTownIIComplete() => bit7(0x0032d986)
xachievement(title = "Presence Is the Best Gift", description = "Complete the second visit to Halloween Town.", points = 3,
    trigger = WasBitflagSetInGame(halloweenTownIIComplete())
)

function IsAttackingOnCarpet() => fieldActionId() == 0x97 || fieldActionId() == 0x98 || fieldActionId() == 0x9b
xachievement(title = "Merciful Escapist [m]", description = "Escape from the Sandswept Ruins without attacking once (Proud Mode or higher; Level 42 or below).", points = 5,
    trigger = GetCheckpointForRegisteredEvent("Sandswept Ruins Escape", when = level() <= 42 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(TimedEventEnded())
        && never(IsAttackingOnCarpet())
)

xachievement(title = "Fragile Rotor [m]", description = "Defeat Jafar without using the Spin Burst reaction command more than twice (Proud Mode or higher; Level 42 or below).", points = 10,
    trigger = GetCheckpointForRegisteredEvent("Jafar", when = level() <= 42 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(repeated(3, reactionCommandId() == 0x281 && Delta(reactionCommandId()) == 0))
)

function agrabahIIComplete() => bit0(0x0032d8a4)
xachievement(title = "Measure of a Friend", description = "Complete the second visit to Agrabah.", points = 3,
    trigger = WasBitflagSetInGame(agrabahIIComplete())
)

xachievement(title = "Drills Are Not a Weapon [m]", description = "Defeat the Groundshaker without spamming Aerial Impulse (Proud Mode or higher; Level 43 or below).", points = 10,
    trigger = GetCheckpointForRegisteredEvent("Groundshaker", when = level() <= 43 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        // 80 frames allows for a player to use Aerial Impulse two times in succession for the maximum duration without triggering a reset.
        // It'll also allow for only three in a row if they cancel it at the right time at the end with a finisher, but if they linger too long, it'll reset.
        && never(repeated(80, fieldActionId() == 0xbf && never(fieldActionId() != 0xbf) && TimeIsFlowingNormally()))
)

function prideLandsIIComplete() => bit0(0x0032d906)
xachievement(title = "No Rest for the Weary", description = "Complete the second visit to the Pride Lands.", points = 3,
    trigger = WasBitflagSetInGame(prideLandsIIComplete()) && IsInLocation("WorldMap")
)

function weightLimit() => float(0x01d48fa4)
xachievement(title = "All Hands on Deck! [m]", description = "Successfully repel the enemies from the solar sailer without it reaching 66% of its weight limit (Proud Mode or higher; Level 44 or below).",
    points = 10,
    trigger = GetCheckpointForRegisteredEvent("Solar Sailer", when = level() <= 44 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(weightLimit() >= 66.0)
)

nonBeneficialSoraAbilities = GetAbilitiesByCallback(x => x["name"] != "No Experience")
xachievement(title = "Factory Reset [m]", description = "Defeat the MCP without equipping any beneficial learned abilities on Sora (Proud Mode or higher; Level 44 or below).",
    points = 10,
    trigger = GetCheckpointForRegisteredEvent("MCP", when = level() <= 44 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(BaseSoraHasAnyGivenAbilityEquipped(nonBeneficialSoraAbilities))
)

xachievement(title = "Glowing Nostalgia", description = "Complete the second visit to Space Paranoids.", points = 3,
    trigger = WasBitflagSetInGame(hollowBastionIIIComplete())
)

function hundredAcreWoodComplete() => bit5(0x0032d8e5)
xachievement(title = "Together Apart", description = "Complete the 100-Acre Wood.", points = 3,
    trigger = WasBitflagSetInGame(hundredAcreWoodComplete()) && IsInLocation("Merlin")
)

// Can't use the checkpoint system for any of the Maestro achievements, since the field pointer is nullified during these sequences...
function cameraState() => byte(0x0033cc38)
function currentExcellentComboChain() => dword(0x0035dacc)
function maxExcellentComboChain() => dword(0x0035dac8)
function currentSongScore() => dword(0x0035dac4)
function currentSongTime() => dword(0x0035de20)
function SongAdvancedOneFrame() => Delta(currentSongTime()) < currentSongTime()
swimThisWayEvent = GetEventByKey("Swim This Way")
xachievement(title = "Maestro - \"Swim This Way\"", description = "Complete \"Swim This Way\" with a max Excellent chain of at least 20.", points = 5,
    trigger = eventId() == swimThisWayEvent["eventId"] && trigger_when(currentSongTime() == 5230 && SongAdvancedOneFrame() && maxExcellentComboChain() >= 20)
        && IsInWorld("Atlantica")
)

partOfYourWorldEvent = GetEventByKey("Part of Your World")
xachievement(title = "Maestro - \"Part of Your World\"", description = "Complete \"Part of Your World\" with all Excellents.", points = 10,
    trigger = eventId() == partOfYourWorldEvent["eventId"] && trigger_when(currentSongTime() == 3977 && SongAdvancedOneFrame() && currentExcellentComboChain() >= 25)
        && IsInWorld("Atlantica")
)

underTheSeaEvent = GetEventByKey("Under the Sea")
xachievement(title = "Maestro - \"Under the Sea\"", description = "Complete \"Under the Sea\" with Ariel's mood maxed out.", points = 3,
    trigger = eventId() == underTheSeaEvent["eventId"] && trigger_when(currentSongTime() == 5000 && SongAdvancedOneFrame() && currentSongScore() >= 10000)
        && IsInWorld("Atlantica")
)

function circleIsPressed() => bit5(0x0034d3c1)
function TurboIsBeingUsed(buttonBit) => repeated(10, Delta(buttonBit) != buttonBit && never(Delta(buttonBit) == buttonBit))
ursulaRevengeEvent = GetEventByKey("Ursula’s Revenge")
xachievement(title = "Maestro - \"Ursula's Revenge\"", description = "Empty Ursula's health bar in \"Ursula's revenge\" before the start of the second verse.", points = 25,
    trigger = once(eventId() == ursulaRevengeEvent["eventId"] && currentSongTime() == 0) && trigger_when(currentSongTime() <= 2400 && SongAdvancedOneFrame() && currentSongScore() >= 10000)
        && never(currentSongScore() < 10000 && currentSongTime() > 2400 && SongAdvancedOneFrame())
        && never(TurboIsBeingUsed(circleIsPressed()))
        && never(eventId() != ursulaRevengeEvent["eventId"])
        && IsInWorld("Atlantica")
)

newDayIsDawningEvent = GetEventByKey("A New Day Is Dawning")
xachievement(title = "Maestro - \"A New Day Is Dawning\"", description = "Complete \"A New Day Is Dawning\" with a score of 100000 points or more.", points = 10,
    trigger = eventId() == newDayIsDawningEvent["eventId"] && trigger_when(currentSongTime() == 6300 && SongAdvancedOneFrame() && currentSongScore() >= 100000)
        && IsInWorld("Atlantica")
)

function atlanticaComplete() => bit5(0x0032d927)
xachievement(title = "Bridged Worlds", description = "Complete Atlantica.", points = 3,
    trigger = WasBitflagSetInGame(atlanticaComplete()) && IsInLocation("WorldMap")
)

xachievement(title = "I Am Not Roxas!", description = "Defeat Roxas.",
    points = 10,
    trigger = GetCheckpointForRegisteredEvent("Roxas")
        && trigger_when(BonusObtained())
)

quickRunAbilities = GetAbilitiesByCallback(x => x["name"] == "Quick Run LV1" || x["name"] == "Quick Run LV2" || x["name"] == "Quick Run LV3" || x["name"] == "Quick Run MAX")
xachievement(title = "The Way of Sloth [m]", description = "Defeat Roxas without Quick Run equipped (Proud Mode or higher; Level 45 or below).",
    points = 25,
    trigger = GetCheckpointForRegisteredEvent("Roxas", when = level() <= 45 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(BaseSoraHasAnyGivenAbilityEquipped(quickRunAbilities))
)

xachievement(title = "Field of Honor [m]", description = "Defeat Xigbar without using Limits (Proud Mode or higher; Level 47 or below).",
    points = 10,
    trigger = GetCheckpointForRegisteredEvent("Xigbar", when = level() <= 47 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(LimitIsBeingUsed())
)

function timeBattleTimeRemaining() => float(0x01d48fa4)
xachievement(title = "Distance over Speed [m]", description = "Defeat Luxord with at least 40% of your time remaining (Proud Mode or higher; Level 47 or below).",
    points = 25,
    trigger = GetCheckpointForRegisteredEvent("Luxord", when = level() <= 47 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(timeBattleTimeRemaining() < 40.0)
)

function saixBerserkRemaining() => float(0x01d48fa4)
function IsUsingPeterPan() => currentSummon() == 4
xachievement(title = "Lunar Assault [m]", description = "Defeat Saïx without Guard equipped and without summoning Peter Pan (Proud Mode or higher; Level 47 or below).", points = 10,
    trigger = GetCheckpointForRegisteredEvent("Saïx", when = level() <= 47 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(BaseSoraHasAnyGivenAbilityEquipped(GetAbilitiesByCallback(x => x["name"] == "Guard")))
        && never(IsUsingPeterPan())
)

function TriangleIsBeingPressed() => bit4(0x0034d3c1) == 1
function displayReactionCommandId() => word(0x01c5ff4e) 
// The reaction command ID doesn't appear in the address we've used up to this point, so we need to infer that if Triangle is pressed when the display appears, they've *probably* used it.
// todo: consider restricting pause buffering
function IsProbablyUsingReactionCommandWithId(id) => displayReactionCommandId() == id && TriangleIsBeingPressed()
xachievement(title = "Superior Reflexes [m]", description = "While Second Chance and Once More are unequipped, win the first fight against Xemnas without using the Clash and Break Through "
    + "reaction commands (Proud Mode or higher; Level 48 or below).", points = 10,
    trigger = GetCheckpointForRegisteredEvent("Xemnas I", when = level() <= 48 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(BaseSoraHasAnyGivenAbilityEquipped(GetAbilitiesByCallback(x => x["name"] == "Second Chance" || x["name"] == "Once More")))
        && never(IsProbablyUsingReactionCommandWithId(0x232)) // Clash
        && never(IsProbablyUsingReactionCommandWithId(0x233)) // Break Through
        && unless(!TimeIsFlowingNormally()) // We don't want to invalidate the achievement while the game is paused.
)

function cannonCharge() => float(0x01d4900c)
function rightUnitHp() => float(0x01d48fa4)
function leftUnitHp() => float(0x01d48fd8)
function rightStuntDodgeId() => 0x264
function leftStuntDodgeId() => 0x26b
xachievement(title = "Swift Saboteur", description = "Destroy both cannon cylinders of Xemnas's ship in a single cycle.",
    points = 5,
    trigger = GetCheckpointForRegisteredEvent("Xemnas Cannons")
        && trigger_when(reactionCommandId() == leftStuntDodgeId()) // It can only be triggered when the player uses the left-side Stunt Dodge.
        // Using either side's Stunt Dodge while that side's cannon has more than 0 HP means that player could not do it in a single cycle.
        && never(reactionCommandId() == rightStuntDodgeId() && Delta(reactionCommandId()) == 0 && rightUnitHp() > 0.0)
        && never(reactionCommandId() == leftStuntDodgeId() && Delta(reactionCommandId()) == 0 && leftUnitHp() > 0.0)
)

function battleState() => byte(0x00351ec8)
function JustWonBattle() => Delta(battleState()) == 0 && battleState() == 1
function DragonSegmentJustStarted() => Delta(cameraState()) == 1 && cameraState() == 0
function gliderEnergy() => float(0x01d48fa4)
function JustUsedMegalaser() => Delta(gliderEnergy()) == 100.0 && gliderEnergy() == 0.0
dragonXemnasEvent = GetEventByKey("Xemnas Dragon")
xachievement(title = "With Great Power... [m]", description = "Defeat Xemnas's Dragon Form without using Megalaser (Proud Mode or higher; Level 48 or below).", points = 10,
    trigger = once(eventId() == dragonXemnasEvent["eventId"] && level() <= 48 && IsAtLeastOnDifficulty("Proud") && DragonSegmentJustStarted() && IsInLocation(dragonXemnasEvent["locationCode"]))
        && trigger_when(JustWonBattle())
        && never(JustUsedMegalaser())
        && never(IsDead())
        && never(!IsInLocation(dragonXemnasEvent["locationCode"]))
)

function HasArmorEquipped()
{
    baseArmorAddr = 0x0032e034
    trigger = always_false()
    for i in range(0, 7)
    {
        trigger = trigger || word(baseArmorAddr + i * 2) > 0
    }
    
    return trigger
}

function HasAccessoriesEquipped()
{
    baseAccessoryAddr = 0x0032e044
    trigger = always_false()
    for i in range(0, 7)
    {
        trigger = trigger || word(baseAccessoryAddr + i * 2) > 0
    }
    
    return trigger
}

xachievement(title = "Embrace Nothing [m]", description = "Clear the final boss gauntlet without any armor or accessories equipped on Sora (Proud Mode or higher; Level 48 or below).",
    points = 10,
    trigger = GetCheckpointForRegisteredEvent("Final Xemnas", when = level() <= 48 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(JustWonBattle())
        && never(HasArmorEquipped())
        && never(HasAccessoriesEquipped())
)

function IsFinalEvent() => eventId() == 0x3a || eventId() == 0x3c || eventId() == 0x3d
function TransitionedToBattleReport() => timerState() == 3 && Delta(timerState()) == 2
xachievement(title = "Where the Heart Is", description = "Complete the story.", points = 10,
    trigger = IsFinalEvent() && IsInLocation("DarkMargin")
        && TransitionedToBattleReport()
)

xachievement(title = "Proudheart", description = "Complete the story on Proud Mode or higher.", points = 10,
    trigger = IsFinalEvent() && IsInLocation("DarkMargin")
        && TransitionedToBattleReport() && IsAtLeastOnDifficulty("Proud")
)

xachievement(title = "Grimheart", description = "Complete the story on Critical Mode.", points = 25,
    trigger = IsFinalEvent() && IsInLocation("DarkMargin")
        && TransitionedToBattleReport() && IsAtLeastOnDifficulty("Critical")
)

function BeatTargetTime(mem, value) => IsAlwaysInGame() && mem <= value && mem != 0 && (Delta(mem) > value || Delta(mem) == 0)
function timerStateAlpha() => dword(0x00349dec)
function timerStateBeta() => dword(0x00349dfc)
function junkRemaining() => dword(0x01d48f34)
function ShouldSubmitMinigameScore() => timerStateAlpha() == timerStateBeta() && timerStateBeta() == 2
function MinigameCanceled(minigame) => !GivenEventIsHappening(minigame["eventKey"])
function enemyStruggleScore() => junkRemaining()
function LostByKnockout() => currentScore() == 0 && enemyStruggleScore() == 200
function WonByKnockout() => currentScore() == 200 && enemyStruggleScore() == 0
function StruggleIsOver() => WonByKnockout() || LostByKnockout() || timeRemaining() <= 0
function currentScore() => dword(0x01d48efc)
function targetScore() => dword(0x01d48ee8)
function hitsInACombo() => dword(0x01d49074)
function maxHits() => dword(0x01d49080)
function TimedEventIsStarting() => Delta(timerStateAlpha()) + 4 == timerStateAlpha()
function ShouldSubmitStruggleTime() => Delta(timerStateBeta()) == 2 && timerStateBeta() == 0 && TimedEventIsStarting()
function currentHp() => dword(0x01c6c750)
function IsTransitioningToOrFromMinigame() => battleState() == 4 || battleState() == 5

for i in minigames
{
    minigame = minigames[i]
    
    if (minigame["generate"] == 1)
    {
        if (minigame["struggle"] == 1)
        {
            xachievement(title = minigame["basicName"], description = minigame["description"], points = minigame["basicScore"],
                trigger = trigger_when(currentScore() - enemyStruggleScore() >= 100 && timeRemaining() <= 0 || WonByKnockout()) && GivenEventIsHappening(minigame["eventKey"])
                    // This is to prevent false triggers if score data was set in another, completely unrelated area in such a way as to meet the conditions as soon as the minigame starts.
                    && IsActiveInTheField()
            )

            xachievement(title = minigame["advancedName"],
                description = format(minigame["struggleDesc"], SecondsToFormat(minigame["advancedTarget"])), points = minigame["advancedScore"],
                trigger = trigger_when(currentScore() == 200 && enemyStruggleScore() == 0) && GivenEventIsHappening(minigame["eventKey"])
                    && timeRemaining() >= SecondsToFrames(60 - minigame["advancedTarget"])
                    && IsActiveInTheField()
            )

            xleaderboard(title = minigame["eventKey"],
                description = minigame["leaderboardDesc"],
                start = GivenEventIsHappening(minigame["eventKey"]) && TimedEventIsStarting(),
                cancel = !GivenEventIsHappening(minigame["eventKey"]) || currentHp() == 0,
                submit = ShouldSubmitStruggleTime(),
                value = 3600 - timeRemaining(),
                format = "FRAMES",
                lower_is_better = true
            )
        }
        else if (minigame["useScore"] == 1)
        {
            xachievement(title = minigame["basicName"], description = format(minigame["description"], minigame["basicTarget"]), points = minigame["basicScore"],
                trigger = trigger_when(currentScore() >= minigame["basicTarget"] && JustWonBattle()) && GivenEventIsHappening(minigame["eventKey"])
            )

            xachievement(title = minigame["advancedName"], description = format(minigame["description"], minigame["advancedTarget"]), points = minigame["advancedScore"],
                trigger = trigger_when(currentScore() >= minigame["advancedTarget"] && JustWonBattle()) && GivenEventIsHappening(minigame["eventKey"])
            )

            xleaderboard(title = minigame["eventKey"],
                description = minigame["leaderboardDesc"],
                start = GivenEventIsHappening(minigame["eventKey"]) && IsTransitioningToOrFromMinigame(),
                cancel = !GivenEventIsHappening(minigame["eventKey"]),
                submit = JustWonBattle(),
                value = currentScore(),
                format = "VALUE",
                lower_is_better = false
            )
        }
        else
        {
            xachievement(title = minigame["basicName"], description = format(minigame["description"], minigame["basicTarget"]), points = minigame["basicScore"],
            trigger = trigger_when(ShouldSubmitMinigameScore()) && GivenEventIsHappening(minigame["eventKey"])
                && timeRemaining() <= SecondsToFrames(minigame["basicTarget"])
            )
    
            xachievement(title = minigame["advancedName"], description = format(minigame["description"], minigame["advancedTarget"]), points = minigame["advancedScore"],
                trigger = trigger_when(ShouldSubmitMinigameScore()) && GivenEventIsHappening(minigame["eventKey"])
                    && timeRemaining() <= SecondsToFrames(minigame["advancedTarget"])
            )
    
            xleaderboard(title = minigame["eventKey"],
                description = minigame["leaderboardDesc"],
                start = GivenEventIsHappening(minigame["eventKey"]) && !ShouldSubmitMinigameScore(),
                cancel = MinigameCanceled(minigame),
                submit = ShouldSubmitMinigameScore(),
                value = timeRemaining(),
                format = "FRAMES",
                lower_is_better = (minigame["lowerIsBetter"] == 1)
            )
        }
    }
}

//**** This section of achievements and leaderboards have rules and stipulations that don't make them easy to autogen from the spreadsheet. ****//
xachievement(title = "Overachieving Showoff", description = format("Complete the Grandstander minigame with a score of {0} or more.", 100), points = 5,
    trigger = trigger_when(maxHits() >= 100) && GivenEventIsHappening("Grandstander")
)

xachievement(title = "Professional Showoff", description = format("Complete the Grandstander minigame with a score of {0} or more.", 150), points = 10,
    trigger = trigger_when(maxHits() >= 150) && GivenEventIsHappening("Grandstander")
)

xleaderboard(title = "Grandstander",
    description = "Hit the ball as many times as you can before it touches the ground!",
    start = GivenEventIsHappening("Grandstander") && hitsInACombo() == 1,
    cancel = !GivenEventIsHappening("Grandstander") || Delta(currentScore()) < currentScore(),
    submit = Delta(currentScore()) > currentScore(),
    value = maxHits(),
    format = "VALUE",
    lower_is_better = false
)

function JunkSweepIsDone() => junkRemaining() == 0 && Delta(junkRemaining()) > 0
xachievement(title = "Overachieving Garbageman", description = format("Complete the Junk Sweep minigame in {0} swings or fewer.", 10), points = 3,
    trigger = trigger_when(currentScore() <= 10 && JunkSweepIsDone()) && GivenEventIsHappening("Junk Sweep")
)

xachievement(title = "Professional Garbageman", description = format("Complete the Junk Sweep minigame in {0} swings or fewer.", 6), points = 5,
    trigger = trigger_when(currentScore() <= 6 && JunkSweepIsDone()) && GivenEventIsHappening("Junk Sweep")
)

xleaderboard(title = "Junk Sweep",
    description = "Get rid of all the junk in as few swings as possible!",
    start = GivenEventIsHappening("Junk Sweep") && currentScore() == 1,
    cancel = !GivenEventIsHappening("Junk Sweep"),
    submit = JunkSweepIsDone(),
    value = currentScore(),
    format = "VALUE",
    lower_is_better = true
)

function triesRemaining() => dword(0x01d48f6c)
function SBStreetRaveIsDone() => triesRemaining() == 0 && Delta(triesRemaining()) > 0
function SBSreetRaveIsStarting() => timerStateAlpha() == 4 && timerStateBeta() == 0
xachievement(title = "Overachieving Street Raver", description = format("Complete the Skateboard Street Rave minigame with a score of {0} or more.", 1000), points = 3,
    trigger = trigger_when(currentScore() >= 1000 && SBStreetRaveIsDone()) && GivenEventIsHappening("Skateboard Street Rave")
)

xachievement(title = "Professional Street Raver", description = format("Complete the Skateboard Street Rave minigame with a score of {0} or more.", 2000), points = 5,
    trigger = trigger_when(currentScore() >= 2000 && SBStreetRaveIsDone()) && GivenEventIsHappening("Skateboard Street Rave")
)

xleaderboard(title = "Skateboard Street Rave",
    description = "Get as many points as you can in the Skateboard Street Rave minigame!",
    start = GivenEventIsHappening("Skateboard Street Rave") && SBSreetRaveIsStarting(),
    cancel = !GivenEventIsHappening("Skateboard Street Rave"),
    submit = SBStreetRaveIsDone(),
    value = currentScore(),
    format = "VALUE",
    lower_is_better = true
)

xachievement(title = "Overachieving Freestyler", description = format("Complete the Skateboard Freestyle minigame with a score of {0} or more.", 200), points = 3,
    trigger = trigger_when(maxHits() >= 200) && GivenEventIsHappening("Skateboard Freestyle")
)

xachievement(title = "Professional Freestyler", description = format("Complete the Skateboard Freestyle minigame with a score of {0} or more.", 1000), points = 10,
    id = 356977, badge = "402174",
    trigger = trigger_when(maxHits() >= 1000) && GivenEventIsHappening("Skateboard Freestyle")
)

xleaderboard(title = "Skateboard Freestyle",
    description = "Get as many points as you can in the Skateboard Freestyle minigame!",
    start = GivenEventIsHappening("Skateboard Freestyle") && hitsInACombo() > 0,
    cancel = !GivenEventIsHappening("Skateboard Freestyle"),
    submit = Delta(hitsInACombo()) > hitsInACombo(),
    value = maxHits(),
    format = "VALUE",
    lower_is_better = false
)

function PhilTrainingIsDone() => timeRemaining() <= 0 && Delta(timeRemaining()) > 0
function PhilTrainingIsStarting() => timerStateAlpha() == 4 && timerStateBeta() == 0
xachievement(title = "Overachieving Trainee", description = format("Complete Phil's Training on Maniac Mode with a score of {0} or more.", 1000), points = 3,
    trigger = trigger_when(currentScore() >= 1000 && PhilTrainingIsDone()) && GivenEventIsHappening("Phil’s Training – Maniac Mode")
)

xachievement(title = "Professional Trainee", description = format("Complete Phil's Training on Maniac Mode with a score of {0} or more.", 2000), points = 5,
    trigger = trigger_when(currentScore() >= 2000 && PhilTrainingIsDone()) && GivenEventIsHappening("Phil’s Training – Maniac Mode")
)

xleaderboard(title = "Phil’s Training – Maniac Mode",
    description = "Get as many points as you can in Phil’s Training on Maniac Mode!",
    start = GivenEventIsHappening("Phil’s Training – Maniac Mode") && PhilTrainingIsStarting(),
    cancel = !GivenEventIsHappening("Phil’s Training – Maniac Mode"),
    submit = PhilTrainingIsDone(),
    value = currentScore(),
    format = "VALUE",
    lower_is_better = false
)

function readyGoReactionCommandId() => 0x29c
function MushroomXIIIAchievements(title1, title2, title3, descriptionFormat, target1, target2, target3, points1, points2, points3, location, trigger)
{
    xachievement(title = title1, description = format(descriptionFormat, target1), points = points1,
        trigger = once(IsInLocation(location) && reactionCommandId() == readyGoReactionCommandId())
            && trigger_when(trigger(target1))
            && never(!IsInLocation(location))
    )
    
    xachievement(title = title2, description = format(descriptionFormat, target2), points = points2,
        trigger = once(IsInLocation(location) && reactionCommandId() == readyGoReactionCommandId())
            && trigger_when(trigger(target2))
            && never(!IsInLocation(location))
    )
    
    xachievement(title = title3, description = format(descriptionFormat, target3), points = points3,
        trigger = once(IsInLocation(location) && reactionCommandId() == readyGoReactionCommandId())
            && trigger_when(trigger(target3))
            && never(!IsInLocation(location))
    )
}

MushroomXIIIAchievements(
    title1 = "I.1 - Basic",
    title2 = "I.2 - Ace",
    title3 = "I.3 - Supreme",
    descriptionFormat = "Get a total of {0} hits or more against No. 1 of Mushroom XIII.",
    target1 = 70, target2 = 90, target3 = 99, points1 = 3, points2 = 10, points3 = 25, location = "NeverSkyscraper",
    trigger = (target) => Delta(timeRemaining()) > timeRemaining() && timeRemaining() == 0 && currentScore() >= target
)

function battleStateFlag() => byte(0x01c61958)
MushroomXIIIAchievements(
    title1 = "II.1 - Basic",
    title2 = "II.2 - Ace",
    title3 = "II.3 - Supreme",
    descriptionFormat = "Get a score of {0} or more against No. 2 of Mushroom XIII without leaving the room.",
    target1 = 80, target2 = 95, target3 = 99, points1 = 3, points2 = 10, points3 = 25, location = "HalloweenPlaza",
    trigger = (target) => Delta(battleStateFlag()) == 1 && battleStateFlag() == 0 && currentScore() >= target
)

MushroomXIIIAchievements(
    title1 = "III.1 - Basic",
    title2 = "III.2 - Ace",
    title3 = "III.3 - Supreme",
    descriptionFormat = "Collect {0} or more orbs from No. 3 of Mushroom XIII without leaving the room.",
    target1 = 450, target2 = 490, target3 = 500, points1 = 3, points2 = 25, points3 = 50, location = "BeastBridge2",
    trigger = (target) => Delta(battleStateFlag()) == 1 && battleStateFlag() == 0 && currentScore() >= target
)

MushroomXIIIAchievements(
    title1 = "IV.1 - Basic",
    title2 = "IV.2 - Ace",
    title3 = "IV.3 - Supreme",
    descriptionFormat = "Defeat {0} or more clones of No. 4 of Mushroom XIII without leaving the room.",
    target1 = 85, target2 = 95, target3 = 100, points1 = 3, points2 = 4, points3 = 5, location = "PalaceGate",
    trigger = (target) => Delta(battleStateFlag()) == 1 && battleStateFlag() == 0 && currentScore() >= target
)

MushroomXIIIAchievements(
    title1 = "V.1 - Basic",
    title2 = "V.2 - Ace",
    title3 = "V.3 - Supreme",
    descriptionFormat = "Defeat No. 5 of Mushroom XIII within {0} seconds without leaving the room.",
    target1 = 10, target2 = 5, target3 = 3, points1 = 3, points2 = 10, points3 = 25, location = "AgrabahCaveTreasure",
    trigger = (target) => Delta(battleStateFlag()) == 1 && battleStateFlag() == 0 && timeRemaining() <= SecondsToFrames(target)
)

MushroomXIIIAchievements(
    title1 = "VI.1 - Basic",
    title2 = "VI.2 - Ace",
    title3 = "VI.3 - Supreme",
    descriptionFormat = "Defeat all clones of No. 6 of Mushroom XIII within {0} seconds without leaving the room.",
    target1 = 45, target2 = 40, target3 = 31, points1 = 3, points2 = 5, points3 = 25, location = "UnderworldCavernsAtrium",
    trigger = (target) => Delta(battleStateFlag()) == 1 && battleStateFlag() == 0 && timeRemaining() <= SecondsToFrames(target)
)

MushroomXIIIAchievements(
    title1 = "VII.1 - Basic",
    title2 = "VII.2 - Ace",
    title3 = "VII.3 - Supreme",
    descriptionFormat = "Defeat No. 7 of Mushroom XIII within {0} seconds without leaving the room.",
    target1 = 10, target2 = 5, target3 = 3, points1 = 3, points2 = 10, points3 = 25, location = "Tunnelway",
    trigger = (target) => Delta(battleStateFlag()) == 1 && battleStateFlag() == 0 && timeRemaining() <= SecondsToFrames(target)
)

MushroomXIIIAchievements(
    title1 = "VIII.1 - Basic",
    title2 = "VIII.2 - Ace",
    title3 = "VIII.3 - Supreme",
    descriptionFormat = "Land {0} hits or more on No. 8 of Mushroom XIII without leaving the room.",
    target1 = 85, target2 = 95, target3 = 99, points1 = 10, points2 = 25, points3 = 50, location = "Tower",
    trigger = (target) => Delta(battleStateFlag()) == 1 && battleStateFlag() == 0 && currentScore() >= target
)

MushroomXIIIAchievements(
    title1 = "IX.1 - Basic",
    title2 = "IX.2 - Ace",
    title3 = "IX.3 - Supreme",
    descriptionFormat = "Land {0} hits or more on No. 9 of Mushroom XIII without leaving the room.",
    target1 = 75, target2 = 95, target3 = 99, points1 = 3, points2 = 4, points3 = 5, location = "CastleGate",
    trigger = (target) => Delta(battleStateFlag()) == 1 && battleStateFlag() == 0 && currentScore() >= target
)

MushroomXIIIAchievements(
    title1 = "X.1 - Basic",
    title2 = "X.2 - Ace",
    title3 = "X.3 - Supreme",
    descriptionFormat = "Defeat No. 10 of Mushroom XIII within {0} seconds without leaving the room.",
    target1 = 55, target2 = 39, target3 = 36, points1 = 3, points2 = 5, points3 = 10, location = "PortNook",
    trigger = (target) => Delta(battleStateFlag()) == 1 && battleStateFlag() == 0 && timeRemaining() <= SecondsToFrames(target)
)

MushroomXIIIAchievements(
    title1 = "XI.1 - Basic",
    title2 = "XI.2 - Ace",
    title3 = "XI.3 - Supreme",
    descriptionFormat = "Bring No. 11 of Mushroom XIII's counter to 0 within {0} seconds without leaving the room.",
    target1 = 19, target2 = 17, target3 = 15, points1 = 3, points2 = 10, points3 = 25, location = "RiverWaterway",
    trigger = (target) => Delta(battleStateFlag()) == 1 && battleStateFlag() == 0 && timeRemaining() <= SecondsToFrames(target)
)

MushroomXIIIAchievements(
    title1 = "XII.1 - Basic",
    title2 = "XII.2 - Ace",
    title3 = "XII.3 - Supreme",
    descriptionFormat = "Defeat {0} or more clones of No. 12 of Mushroom XIII without leaving the room.",
    target1 = 40, target2 = 44, target3 = 50, points1 = 3, points2 = 10, points3 = 25, location = "Courtyard",
    trigger = (target) => Delta(battleStateFlag()) == 1 && battleStateFlag() == 0 && currentScore() >= target
)

function proofsOfPeace() => byte(0x0032f1e4)
xachievement(title = "The 13th Appeasement", description = "Obtain the Proof of Peace from No. 13 of Mushroom XIII.", points = 10,
    trigger = WasValueSetInGame(proofsOfPeace(), 0, 1)
)

// /ungenned

// Here we define "cheese" as a first-order optimal strategy that trivializes a fight when used indefinitely. There are multiple different types of usable cheese in KH2, but for our purposes,
// each one centers around exploiting bosses' revenge mechanics. What normally happens is that a player will use a self-chaining attack, such as non-finisher Fire magic, in order to prevent
// a boss's revenge value from increasing, thus ensuring a combo-breaking counterattack never happens. Most optional boss achievements will forbid the use of cheese, and the following functions
// govern how cheese is detected in the first place.
//
// In general, cheese is being used when all of the following are true:
// 1. The player is chaining together a specific class of attacks within a short timeframe (i.e., spamming).
// 2. The boss is taking damage.
// 3. The boss's revenge value does not decrease (i.e., the boss is free to act as normal).

// Fire cheese is defined as a cheese strategy involving the use of non-finisher Fire magic. Only the finisher will increase a boss's revenge value.
// Every use of regular Fire will add to a hit counter. If the revenge value ever decreases, then we know no cheese is in effect, and so this hit counter is reset;
// however, if a given number of hits is landed on the boss while non-finisher Fire is active, then cheese is detected. Party members will contribute to this hit count,
// so it's imperative that the hit target is sufficient enough that random hits from Donald and Goofy are negligible.
function enemyPointer() => tbyte(0x01c6c274)
function revenge() => float(tbyte(0x0037f910) + 0x480 + 0x1000000)
function doomCounter() => float(enemyPointer() + 0x437f4 + 0x1000000)
function bossHp3() => dword(0x01c6c018)
function BossJustTookDamage(bossHp) => bossHp < Delta(bossHp)
function RevengeJustDecreased() => revenge() < Delta(revenge())

function UsedFireCheese(bossHp)
{
    return repeated(50, never(RevengeJustDecreased()) && BossJustTookDamage(bossHp) && IsUsingFire())
}

// Negative Combo cheese functions a bit differently from Fire cheese; unlike the latter, the former will continuously increase revenge like normal. The issue, however, lies with the fact
// that revenge will never decrease if the player keeps spamming the default aerial finisher, and so the end result of no counterattacks is the same. Fortunately, this can be detected even
// more easily: If the boss takes damage and has its revenge value increase by 28--the amount of revenge that the default aerial finisher adds to the value on hit--six times and if the
// boss's revenge is also ever at 150 or greater, which is roughly 50 more than the threshold at which it would normally counterattack, then cheese is detected.
function UsedNegativeComboCheese(bossHp)
{
    return repeated(6, never(RevengeJustDecreased()) && BossJustTookDamage(bossHp) && revenge() == Delta(revenge()) + 28.0) && revenge() >= 150.0
}

function UsedCheese(bossHp)
{
    return UsedFireCheese(bossHp) || UsedNegativeComboCheese(bossHp)
}

xachievement(title = "The Cloaked Schemer I", description = "Defeat Zexion's Absent Silhouette.", points = 5,
    trigger = GetCheckpointForRegisteredEvent("Zexion’s Absent Silhouette")
        && trigger_when(BonusObtained())
)

xachievement(title = "Bookburner [m]", description = "Defeat Zexion's Absent Silhouette without exploiting the game's revenge mechanics (Proud Mode or higher; Level 25 or below).",
    points = 10,
    trigger = GetCheckpointForRegisteredEvent("Zexion’s Absent Silhouette", when = level() <= 25 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(UsedCheese(dword(0x01c6c018)))
)

xachievement(title = "The Savage Nymph I", description = "Defeat Larxene's Absent Silhouette.", points = 5,
    trigger = GetCheckpointForRegisteredEvent("Larxene’s Absent Silhouette")
        && trigger_when(BonusObtained())
)

xachievement(title = "Miragebuster [m]", description = "Defeat Larxene's Absent Silhouette without exploiting the game's revenge mechanics (Proud Mode or higher; Level 32 or below).",
    points = 10,
    trigger = GetCheckpointForRegisteredEvent("Larxene’s Absent Silhouette", when = level() <= 32 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(UsedCheese(dword(0x01c6c018)))
)

xachievement(title = "The Silent Hero I", description = "Defeat Lexaeus's Absent Silhouette.", points = 5,
    trigger = GetCheckpointForRegisteredEvent("Lexaeus’s Absent Silhouette")
        && trigger_when(BonusObtained())
)

function megaImpactId() => 0x2c4
function IsUsingMegaImpact() => reactionCommandId() == megaImpactId()
xachievement(title = "Axebreaker [m]", description = "Finish off Lexaeus's Absent Silhouette with your first use of the Mega Impact reaction command (Proud Mode or higher; Level 40 or below;"
    + " no revenge exploits).",
    points = 10, id = 356950, badge = "402146",
    trigger = GetCheckpointForRegisteredEvent("Lexaeus’s Absent Silhouette", when = level() <= 40 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && trigger_when(IsUsingMegaImpact())
        && never(CreateHitTargetedAndNextChain([ IsUsingMegaImpact(), reactionCommandId() == 0 ]))
        && never(UsedCheese(dword(0x01c6c018)))
)

xachievement(title = "The Chilly Academic I", description = "Defeat Vexen's Absent Silhouette.", points = 5,
    trigger = GetCheckpointForRegisteredEvent("Vexen’s Absent Silhouette")
        && trigger_when(BonusObtained())
)

function vexenDataLevel() => dword(0x01d48efc)
xachievement(title = "Shieldshatterer [m]", description = "Defeat Vexen's Absent Silhouette before reaching Data Level 2 (Proud Mode or higher; Level 50 or below; no revenge exploits).",
    points = 10,
    trigger = GetCheckpointForRegisteredEvent("Vexen’s Absent Silhouette", when = level() <= 50 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(vexenDataLevel() >= 2)
        && never(UsedCheese(dword(0x01c6c018)))
)

xachievement(title = "The Graceful Assassin I", description = "Defeat Marluxia's Absent Silhouette.", points = 5,
    trigger = GetCheckpointForRegisteredEvent("Marluxia’s Absent Silhouette")
        && trigger_when(BonusObtained())
)

function doomCounter() => dword(enemyPointer() + 0x437f4 + 0x1000000)
function maxDoomCounter() => dword(enemyPointer() + 0x437f0 + 0x1000000)
xachievement(title = "Doomslayer [m]", description = "Defeat Marluxia's Absent Silhouette without your Doom counter reaching more than 15 below its maximum"
    + " (Proud Mode or higher; Level 60 or below; no revenge exploits).", points = 10,
    trigger = GetCheckpointForRegisteredEvent("Marluxia’s Absent Silhouette", when = level() <= 60 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(UsedCheese(dword(0x01c6c018)))
        // We do a delta check here because the Doom values aren't properly initialized until the end of the whisper cutscene, and these values are only relevant when Sora takes a hit.
        && never(doomCounter() < maxDoomCounter() - 15 && Delta(doomCounter()) == doomCounter() + 1)
)

xachievement(title = "Thousand-Yard Stare [m]", description = "Survive the final enemy wave in the Cavern of Remembrance (Proud Mode or higher; Level 50 or below).",
    points = 25,
    trigger = IsInLocation("CavernTransport") && IsAtLeastOnDifficulty("Proud") && level() <= 50
        && trigger_when(BonusObtained())
)

xachievement(title = "Vanilla-Flavored Suffering [m]", description = "Defeat Sephiroth without activating Limit Form or having Dodge Roll equipped (Proud Mode or higher; Level 70 or below).",
    points = 50, id = 356925, badge = "402121",
    trigger = GetCheckpointForRegisteredEvent("Sephiroth", when = level() <= 70 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(JustEnteredLimitForm())
        && never(BaseSoraHasAnyGivenAbilityEquipped(GetAbilitiesByCallback(x => x["name"] == "Dodge Roll LV1" || x["name"] == "Dodge Roll LV2" || x["name"] == "Dodge Roll LV3"
            || x["name"] == "Dodge Roll MAX")))
)

xachievement(title = "The Superior I", description = "Defeat Data Xemnas's first phase on Proud Mode or higher without exploiting revenge mechanics.", points = 25,
    trigger = GetCheckpointForRegisteredEvent("Data Xemnas 1", when = IsAtLeastOnDifficulty("Proud"))
        && trigger_when(JustWonBattle())
        && never(UsedCheese(dword(0x01c6c4e8)))
)

xachievement(title = "The Superior II", description = "Defeat Data Xemnas's second phase on Proud Mode or higher without exploiting revenge mechanics.", points = 50,
    trigger = GetCheckpointForRegisteredEvent("Data Xemnas 2", when = IsAtLeastOnDifficulty("Proud"))
        && trigger_when(JustWonBattle())
        && never(UsedCheese(dword(0x01c6c280)))
)

xachievement(title = "The Freeshooter", description = "Defeat Data Xigbar on Proud Mode or higher without exploiting revenge mechanics.", points = 50,
    trigger = GetCheckpointForRegisteredEvent("Data Xigbar", when = IsAtLeastOnDifficulty("Proud"))
        && trigger_when(JustWonBattle())
        && never(UsedCheese(dword(0x01c6c018)))
)

xachievement(title = "The Whirlwind Lancer", description = "Defeat Data Xaldin on Proud Mode or higher without exploiting revenge mechanics.", points = 50,
    trigger = GetCheckpointForRegisteredEvent("Data Xaldin", when = IsAtLeastOnDifficulty("Proud"))
        && trigger_when(JustWonBattle())
        && never(UsedCheese(dword(0x01c6c018)))
)

xachievement(title = "The Chilly Academic II", description = "Defeat Data Vexen on Proud Mode or higher without exploiting revenge mechanics.", points = 25,
    trigger = GetCheckpointForRegisteredEvent("Data Vexen", when = IsAtLeastOnDifficulty("Proud"))
        && trigger_when(JustWonBattle())
        && never(UsedCheese(dword(0x01c6c018)))
)

xachievement(title = "The Silent Hero II", description = "Defeat Data Lexaeus on Proud Mode or higher without exploiting revenge mechanics.", points = 25,
    trigger = GetCheckpointForRegisteredEvent("Data Lexaeus", when = IsAtLeastOnDifficulty("Proud"))
        && trigger_when(JustWonBattle())
        && never(UsedCheese(dword(0x01c6c018)))
)

xachievement(title = "The Cloaked Schemer II", description = "Defeat Data Zexion on Proud Mode or higher without exploiting revenge mechanics.", points = 25,
    trigger = GetCheckpointForRegisteredEvent("Data Zexion", when = IsAtLeastOnDifficulty("Proud"))
        && trigger_when(JustWonBattle())
        && never(UsedCheese(dword(0x01c6c018)))
)

xachievement(title = "The Lunar Diviner", description = "Defeat Data Saïx on Proud Mode or higher without summoning Peter Pan and exploiting revenge mechanics.", points = 25,
    trigger = GetCheckpointForRegisteredEvent("Data Saïx", when = IsAtLeastOnDifficulty("Proud"))
        && trigger_when(JustWonBattle())
        && never(UsedCheese(dword(0x01c6c018)))
        && never(IsUsingPeterPan())
)

xachievement(title = "The Flurry of Dancing Flames", description = "Defeat Data Axel on Proud Mode or higher without exploiting revenge mechanics.", points = 25,
    trigger = GetCheckpointForRegisteredEvent("Data Axel", when = IsAtLeastOnDifficulty("Proud"))
        && trigger_when(JustWonBattle())
        && never(UsedCheese(dword(0x01c6c4e8)))
)

xachievement(title = "The Melodious Nocturne", description = "Defeat Data Demyx on Proud Mode or higher without exploiting revenge mechanics.", points = 50,
    trigger = GetCheckpointForRegisteredEvent("Data Demyx", when = IsAtLeastOnDifficulty("Proud"))
        && trigger_when(JustWonBattle())
        && never(UsedCheese(dword(0x01c6c018)))
)

xachievement(title = "The Gambler of Fate", description = "Defeat Data Luxord on Proud Mode or higher without exploiting revenge mechanics.", points = 10,
    id = 357114, badge = "402314",
    trigger = GetCheckpointForRegisteredEvent("Data Luxord", when = IsAtLeastOnDifficulty("Proud"))
        && trigger_when(JustWonBattle())
        && never(UsedCheese(dword(0x01c6c4e8)))
        // Running out of time triggers the achievement because the battle state flickers from 0 to 1 (victory) before being set to 3 (nonstandard game over).
        && never(timeBattleTimeRemaining() <= 0.0)
)

xachievement(title = "The Graceful Assassin II", description = "Defeat Data Marluxia on Proud Mode or higher without exploiting revenge mechanics.", points = 25,
    trigger = GetCheckpointForRegisteredEvent("Data Marluxia", when = IsAtLeastOnDifficulty("Proud"))
        && trigger_when(JustWonBattle())
        && never(UsedCheese(dword(0x01c6c018)))
)

xachievement(title = "The Savage Nymph II", description = "Defeat Data Larxene on Proud Mode or higher without exploiting revenge mechanics.", points = 50,
    trigger = GetCheckpointForRegisteredEvent("Data Larxene", when = IsAtLeastOnDifficulty("Proud"))
        && trigger_when(JustWonBattle())
        && never(UsedCheese(dword(0x01c6c018)))
)

xachievement(title = "The Key of Destiny", description = "Defeat Data Roxas without Quick Run equipped (Proud Mode or higher; no revenge exploits).", points = 50,
    trigger = GetCheckpointForRegisteredEvent("Data Roxas", when = IsAtLeastOnDifficulty("Proud"))
        && trigger_when(JustWonBattle())
        && never(UsedCheese(dword(0x01c6c4ec)))
        && never(BaseSoraHasAnyGivenAbilityEquipped(quickRunAbilities))
)

function GetDataBattleCheckpoint(eventKey) => GetCheckpointForRegisteredEvent(eventKey = eventKey,
        overrideNever = true,
        neverOverride = never(!IsActiveInTheField()) && never(IsInLocation("CavernAssemblage")) && never(IsDead()))
xachievement(title = "Predator or Prey", description = "Defeat the data of a member of Organization XIII after having used Antiform in the fight.", points = 50,
    trigger = (GetDataBattleCheckpoint("Data Xigbar")
        || GetDataBattleCheckpoint("Data Xaldin")
        || GetDataBattleCheckpoint("Data Vexen")
        || GetDataBattleCheckpoint("Data Lexaeus")
        || GetDataBattleCheckpoint("Data Zexion")
        || GetDataBattleCheckpoint("Data Saïx")
        || GetDataBattleCheckpoint("Data Demyx")
        || GetDataBattleCheckpoint("Data Marluxia")
        || GetDataBattleCheckpoint("Data Larxene"))
        && trigger_when(JustWonBattle() && once(JustEnteredAntiForm()))
)

function proofOfNonexistence() => bit3(0x0032df0f)
xachievement(title = "Without a Trace", description = "Obtain the Proof of Nonexistence.", points = 25,
    trigger = WasBitflagSetInGame(proofOfNonexistence())
)

xachievement(title = "But a Shell", description = "Defeat the Lingering Will.", points = 50,
    trigger = (GetCheckpointForRegisteredEvent("Lingering Will") || GetCheckpointForRegisteredEvent("Lingering Will 2"))
        && trigger_when(JustWonBattle())
)

xachievement(title = "Witness of Mastery", description = "Defeat the Lingering Will without using summons (Proud Mode or higher; no revenge exploits).", points = 100,
    trigger = (GetCheckpointForRegisteredEvent("Lingering Will", when = IsAtLeastOnDifficulty("Proud"))
            || GetCheckpointForRegisteredEvent("Lingering Will 2", when = IsAtLeastOnDifficulty("Proud")))
        && trigger_when(JustWonBattle())
        && never(UsedCheese(dword(0x01c6c018)))
        && never(JustUsedAnySummon())
)

function maxClearAnimationTime() => dword(0x0035de28)
// An 0xf value is for the slowdown effect at the end of the round. It switches to 0x1f4 afterwards if it's the "Clear!" animation; otherwise, it would be set to -1.
function ClearAnimationStarted() => Delta(maxClearAnimationTime()) == 0xf && maxClearAnimationTime() == 0x1f4
function PainAndPanicCupCheckpointReached(when = always_true())
    => once(eventId() == 0xbd && IsActiveInTheField() && IsInLocation("ColiseumTourney1") && JustBecameActiveInTheField() && currentRound() == 1 && when)
    && never(IsDead()) && never(IsInLocation("UnderworldEntrance"))
function WonThePainAndPanicCup() => eventId() == 0xb4 && IsInLocation("ColiseumVictory") || ClearAnimationStarted()
xachievement(title = "Pain and Panic Champion", description = "Win the Pain and Panic Cup.", points = 3,
    id = 356881, badge = "402075",
    trigger = PainAndPanicCupCheckpointReached() && WonThePainAndPanicCup()
)

function underdromeCurrentScore() => dword(0x01d48efc)
xachievement(title = "Pain and Panic Recordsetter", description = "Win the Pain and Panic Cup with a score of 2000 or more.", points = 5,
    id = 356882, badge = "402076",
    trigger = PainAndPanicCupCheckpointReached() && trigger_when(underdromeCurrentScore() >= 2000)
        && trigger_when(WonThePainAndPanicCup())
)

xachievement(title = "Pain and Panic Title Defender [m]", description = "Win the Pain and Panic Cup without using Limits (Proud Mode or higher; Level 30 or below).", points = 25,
    id = 356883, badge = "402077",
    trigger = PainAndPanicCupCheckpointReached(when = level() <= 30 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(WonThePainAndPanicCup())
        && never(LimitIsBeingUsed())
)

function CerberusCupCheckpointReached(when = always_true())
    => once(eventId() == 0xbe && IsActiveInTheField() && IsInLocation("ColiseumTourney1") && JustBecameActiveInTheField() && currentRound() == 1 && when)
    && never(IsDead()) && never(IsInLocation("UnderworldEntrance"))
function WonTheCerberusCup() => eventId() == 0xb6 && IsInLocation("ColiseumVictory") || ClearAnimationStarted()
xachievement(title = "Cerberus Champion", description = "Win the Cerberus Cup.", points = 3,
    id = 356885, badge = "402079",
    trigger = CerberusCupCheckpointReached() && WonTheCerberusCup()
)

xachievement(title = "Cerberus Recordsetter", description = "Win the Cerberus Cup with a score of 1000 or more.", points = 5,
    id = 356886, badge = "402080",
    trigger = CerberusCupCheckpointReached() && trigger_when(underdromeCurrentScore() >= 1000)
        && trigger_when(WonTheCerberusCup())
)

function CurrentRoundHasChanged() => Delta(currentRound()) != currentRound()
function ViolatedCerberusCupRules(when = always_true()) => ConditionIsTrueMoreThanOncePerRound(JustEnteredValorForm() && when)
        || ConditionIsTrueMoreThanOncePerRound(JustEnteredWisdomForm())
        || ConditionIsTrueMoreThanOncePerRound(JustEnteredLimitForm())
        || ConditionIsTrueMoreThanOncePerRound(JustEnteredMasterForm())
        || ConditionIsTrueMoreThanOncePerRound(JustEnteredFinalForm())
        || ConditionIsTrueMoreThanOncePerRound(JustEnteredAntiForm())
// Checking for whether or not the player is active on the field is so that they can use the Retry option in the middle of Round 1 and not have their uses carry over.
function ConditionIsTrueMoreThanOncePerRound(condition) => repeated(2, condition && never(CurrentRoundHasChanged()) && never(!IsActiveInTheField()))
xachievement(title = "Cerberus Title Defender [m]", description = "Win the Cerberus Cup without activating the same Drive Form more than once per round (Proud Mode or higher; Level 33 or below).",
    points = 25, id = 356884, badge = "402078",
    trigger = CerberusCupCheckpointReached(when = level() <= 33 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(WonTheCerberusCup())
        && never(ViolatedCerberusCupRules())
)

function TitanCupCheckpointReached(when = always_true())
    => once(eventId() == 0xbf && IsActiveInTheField() && IsInLocation("ColiseumTourney1") && JustBecameActiveInTheField() && currentRound() == 1 && when)
    && never(IsDead()) && never(IsInLocation("UnderworldEntrance"))
function WonTheTitanCup() => eventId() == 0xb5 && IsInLocation("ColiseumVictory") || ClearAnimationStarted()
xachievement(title = "Titan Champion", description = "Win the Titan Cup.", points = 3,
    id = 356955, badge = "402152",
    trigger = TitanCupCheckpointReached() && WonTheTitanCup()
)

xachievement(title = "Titan Recordsetter", description = "Win the Titan Cup with a score of 5000 or more.", points = 5,
    id = 356956, badge = "402153",
    trigger = TitanCupCheckpointReached() && trigger_when(underdromeCurrentScore() >= 5000)
        && trigger_when(WonTheTitanCup())
)

function keyScore() => dword(0x01d48f6c)
xachievement(title = "Titan Title Defender [m]", description = "Win the Titan Cup with at least 125 points remaining (Proud Mode or higher; Level 45 or below).",
    points = 50, id = 356957, badge = "402154",
    trigger = TitanCupCheckpointReached(when = level() <= 45 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(WonTheTitanCup())
        && never(keyScore() < 125)
)

function GoddessOfFateCupCheckpointReached(when = always_true())
    => once(eventId() == 0xc0 && IsActiveInTheField() && IsInLocation("ColiseumTourney1") && JustBecameActiveInTheField() && currentRound() == 1 && when)
    && never(IsDead()) && never(IsInLocation("UnderworldEntrance"))
function WonTheGoddessOfFateCup() => eventId() == 0xb7 && IsInLocation("ColiseumVictory") || ClearAnimationStarted()
xachievement(title = "Goddess of Fate Champion", description = "Win the Goddess of Fate Cup.", points = 3,
    id = 356958, badge = "402155",
    trigger = GoddessOfFateCupCheckpointReached() && WonTheGoddessOfFateCup()
)

xachievement(title = "Goddess of Fate Recordsetter", description = "Win the Goddess of Fate Cup with a score of 3000 or more.", points = 5,
    id = 356959, badge = "402156",
    trigger = GoddessOfFateCupCheckpointReached() && trigger_when(underdromeCurrentScore() >= 3000)
        && trigger_when(WonTheGoddessOfFateCup())
)

xachievement(title = "Goddess of Fate Title Defender [m]", description = "Win the Goddess of Fate Cup without using Magnet magic (Proud Mode or higher; Level 50 or below).",
    points = 10, id = 356960, badge = "402157",
    trigger = GoddessOfFateCupCheckpointReached(when = level() <= 50 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(WonTheGoddessOfFateCup())
        && never(JustUsedMagnet())
)

// The Paradox Cups differ in the sense that there's no victory cutscene after winning a cup. Therefore, we're going to have to detect victory another way.
function IsTransitioningToOrFromBattle() => battleState() == 4
function PainAndPanicParadoxCupCheckpointReached(when = always_true())
    => once(eventId() == 0xc1 && IsActiveInTheField() && IsInLocation("ColiseumTourney1") && JustBecameActiveInTheField() && currentRound() == 1 && when)
    && never(IsDead()) && never(IsTransitioningToOrFromBattle())
function WonThePainAndPanicParadoxCup() => battleState() == 5 && Delta(battleState()) == 1 && IsInLocation("HadesChamber") || ClearAnimationStarted()
xachievement(title = "Pain and Panic Paradox Champion", description = "Win the Pain and Panic Paradox Cup.", points = 3,
    id = 356962, badge = "402159",
    trigger = PainAndPanicParadoxCupCheckpointReached() && WonThePainAndPanicParadoxCup()
)

function underdromeCurrentScore() => dword(0x01d48efc)
xachievement(title = "Pain and Panic Paradox Recordsetter", description = "Win the Pain and Panic Paradox Cup with a score of 2500 or more.", points = 5,
    id = 356963, badge = "402160",
    trigger = PainAndPanicParadoxCupCheckpointReached() && trigger_when(underdromeCurrentScore() >= 2500)
        && trigger_when(WonThePainAndPanicParadoxCup())
)

function ViolatedPainAndPanicParadoxCupRules() => LimitIsBeingUsed()
xachievement(title = "Pain and Panic Paradox Title Defender [m]", description = "Win the Pain and Panic Paradox Cup without using Limits (Proud Mode or higher; Level 50 or below).", points = 25,
    id = 356964, badge = "402161",
    trigger = PainAndPanicParadoxCupCheckpointReached(when = level() <= 50 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(WonThePainAndPanicParadoxCup())
        && never(ViolatedPainAndPanicParadoxCupRules())
)

function CerberusParadoxCupCheckpointReached(when = always_true())
    => once(eventId() == 0xc2 && IsActiveInTheField() && IsInLocation("ColiseumTourney1") && JustBecameActiveInTheField() && currentRound() == 1 && when)
    && never(IsDead()) && never(IsTransitioningToOrFromBattle())
function WonTheCerberusParadoxCup() => battleState() == 5 && Delta(battleState()) == 1 && IsInLocation("HadesChamber") || ClearAnimationStarted()
xachievement(title = "Cerberus Paradox Champion", description = "Win the Cerberus Paradox Cup.", points = 3,
    id = 356965, badge = "402162",
    trigger = CerberusParadoxCupCheckpointReached() && WonTheCerberusParadoxCup()
)

xachievement(title = "Cerberus Paradox Recordsetter", description = "Win the Cerberus Paradox Cup with a score of 1300 or more.", points = 5,
    id = 356966, badge = "402163",
    trigger = CerberusParadoxCupCheckpointReached() && trigger_when(underdromeCurrentScore() >= 1300)
        && trigger_when(WonTheCerberusParadoxCup())
)

xachievement(title = "Cerberus Paradox Title Defender [m]", description = "Win the Cerberus Paradox Cup without activating the same Drive Form more than once per round (Proud Mode or higher; Level 60 or below).",
    points = 25, id = 356967, badge = "402164",
    trigger = CerberusParadoxCupCheckpointReached(when = level() <= 60 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(WonTheCerberusParadoxCup())
        && never(ViolatedCerberusCupRules())
)

function TitanParadoxCupCheckpointReached(when = always_true())
    => once(eventId() == 0xc3 && IsActiveInTheField() && IsInLocation("ColiseumTourney1") && JustBecameActiveInTheField() && currentRound() == 1 && when)
    && never(IsDead()) && never(IsTransitioningToOrFromBattle())
function WonTheTitanParadoxCup() => battleState() == 5 && Delta(battleState()) == 1 && IsInLocation("HadesChamber") || ClearAnimationStarted()
xachievement(title = "Titan Paradox Champion", description = "Win the Titan Paradox Cup.", points = 3,
    id = 356968, badge = "402165",
    trigger = TitanParadoxCupCheckpointReached() && WonTheTitanParadoxCup()
)

xachievement(title = "Titan Paradox Recordsetter", description = "Win the Titan Paradox Cup with a score of 10000 or more.", points = 5,
    id = 356969, badge = "402166",
    trigger = TitanParadoxCupCheckpointReached() && trigger_when(underdromeCurrentScore() >= 10000)
        && trigger_when(WonTheTitanParadoxCup())
)

function chickenLittleUses() => word(0x0032fb12)
function genieUses() => word(0x0032fb14)
function stitchUses() => word(0x0032fb16)
function peterPanUses() => word(0x0032fb18)
function JustUsedChickenLittle() => Delta(chickenLittleUses()) != chickenLittleUses()
function JustUsedGenie() => Delta(genieUses()) != genieUses()
function JustUsedStitch() => Delta(stitchUses()) != stitchUses()
function JustUsedPeterPan() => Delta(peterPanUses()) != peterPanUses()

// `when` is needed here because the Hades Cup also uses these rules for a certain range of rounds, and we don't want the conditions for that achievement to count outside of those rounds.
// Without this, the OrNexts that would result if we put the round checks outside would be placed before the round checks instead of after.
function ViolatedTitanParadoxCupRules(when = always_true())
    => repeated(3, when && (JustUsedChickenLittle()) || repeated(3, JustUsedGenie()) || repeated(3, JustUsedStitch()) || repeated(3, JustUsedPeterPan()))
xachievement(title = "Titan Paradox Title Defender [m]", description = "Win the Titan Paradox Cup without using any individual summon more than twice each (Proud Mode or higher; Level 70 or below).",
    points = 10, id = 356970, badge = "402167",
    trigger = TitanParadoxCupCheckpointReached(when = level() <= 70 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(WonTheTitanParadoxCup())
        && never(ViolatedTitanParadoxCupRules())
)

function HadesParadoxCupCheckpointReached(when = always_true())
    => once(eventId() == 0xc4 && IsActiveInTheField() && IsInLocation("ColiseumTourney1") && JustBecameActiveInTheField() && currentRound() == 1 && when)
    && never(IsDead()) && never(IsInLocation("UnderworldEntrance"))
function WonTheHadesParadoxCup() => eventId() == 0xb8 && IsInLocation("ColiseumVictory") || ClearAnimationStarted()
xachievement(title = "Hades Paradox Champion", description = "Win the Hades Paradox Cup.", points = 5,
    id = 356971, badge = "402168",
    trigger = HadesParadoxCupCheckpointReached() && WonTheHadesParadoxCup()
)

xachievement(title = "Hades Paradox Recordsetter", description = "Win the Hades Paradox Cup with a score of 15000 or more.", points = 10,
    id = 356972, badge = "402169",
    trigger = HadesParadoxCupCheckpointReached() && trigger_when(underdromeCurrentScore() >= 15000)
        && trigger_when(WonTheHadesParadoxCup())
)

xachievement(title = "Hades Paradox Title Defender [m]", description = "Win the Hades Paradox Cup on Proud Mode or higher while adhering to the same achievement conditions for each Paradox Cup's "
    + "respective set of rounds.", points = 50,
    id = 356973, badge = "402170",
    trigger = HadesParadoxCupCheckpointReached(when = IsAtLeastOnDifficulty("Proud"))
        && trigger_when(WonTheHadesParadoxCup())
        && never(ViolatedTitanParadoxCupRules(currentRound() >= 11 && currentRound() <= 20))
        && never(ViolatedPainAndPanicParadoxCupRules() && currentRound() >= 21 && currentRound() <= 30)
        && never(ViolatedCerberusCupRules(currentRound() >= 31 && currentRound() <= 40))
)

function summonLevel() => byte(0x0032f056)
xachievement(title = "The Comrade", description = "Raise summons to the maximum level.", points = 5,
    trigger = WasValueSetInGame(summonLevel(), 6, 7) && measured(summonLevel() == 7)
)

function valorLevel() => byte(0x32ee26)
xachievement(title = "The Dauntless", description = "Raise Valor Form to the maximum level.", points = 5,
    trigger = WasValueSetInGame(valorLevel(), 6, 7) && measured(valorLevel() == 7)
)

function wisdomLevel() => byte(0x32ee5e)
xachievement(title = "The Erudite", description = "Raise Wisdom Form to the maximum level.", points = 5,
    trigger = WasValueSetInGame(wisdomLevel(), 6, 7) && measured(wisdomLevel() == 7)
)

function limitLevel() => byte(0x0032ee96)
xachievement(title = "The Renowned", description = "Raise Limit Form to the maximum level.", points = 5,
    trigger = WasValueSetInGame(limitLevel(), 6, 7) && measured(limitLevel() == 7)
)

function masterLevel() => byte(0x0032eece)
xachievement(title = "The Predominant", description = "Raise Master Form to the maximum level.", points = 5, id = 356911, badge = "402106",
    trigger = WasValueSetInGame(masterLevel(), 6, 7) && measured(masterLevel() == 7)
)

function finalLevel() => byte(0x0032ef06)
xachievement(title = "The Ultimate", description = "Raise Final Form to the maximum level.", points = 5,
    trigger = WasValueSetInGame(finalLevel(), 6, 7) && measured(finalLevel() == 7)
)

function antiUses() => word(0x32fb10)
xachievement(title = "The Corrupted", description = "Activate Antiform for the first time.", points = 1,
    trigger = WasValueSetInGame(antiUses(), 0, 1)
)

function worldGateId() => byte(0x0032ba7c)
function gummiMissionLevel() => byte(0x0032ba84)
function IsEXMission() => byte(0x0032ba88) == 1
function gummiGuiState() => byte(0x01f80d38)
function GummiMissionJustStarted() => gummiGuiState() == 0xa && Delta(gummiGuiState()) == 0x9
function GummiMissionComplete() => gummiGuiState() == 0x8 && Delta(gummiGuiState()) == 0x5
function gummiShipRank() => byte(0x01f8038c)
function gummiShipPointer() => tbyte(0x01f7de44)
function gummiShipScore() => dword(0x01f8039c)

gummiMissions = {
2: { "name": "Asteroid Sweep", "gateId": 0, "miss1BaseAddr": 0x0033bc10, "miss1EXBaseAddr": 0x0033c2d0, "mission1Score": 1, "mission2Score": 2, "mission3Score": 3, "exMission1Score": 5, "exMission2Score": 5, "exMission3Score": 10, "mission1Id": 357045, "badge1Id": 402244, "mission2Id": 357046, "badge2Id": 402245, "mission3Id": 357047, "badge3Id": 402246, "exMission1Id": 357048, "exBadge1Id": 402247, "exMission2Id": 357049, "exBadge2Id": 402248, "exMission3Id": 357050, "exBadge3Id": 402249 },3: { "name": "Stardust Sweep", "gateId": 1, "miss1BaseAddr": 0x0033bcd0, "miss1EXBaseAddr": 0x0033c390, "mission1Score": 1, "mission2Score": 2, "mission3Score": 3, "exMission1Score": 5, "exMission2Score": 5, "exMission3Score": 10, "mission1Id": 357051, "badge1Id": 402250, "mission2Id": 357053, "badge2Id": 402252, "mission3Id": 357055, "badge3Id": 402254, "exMission1Id": 357052, "exBadge1Id": 402251, "exMission2Id": 357054, "exBadge2Id": 402253, "exMission3Id": 357056, "exBadge3Id": 402255 },4: { "name": "Broken Highway", "gateId": 2, "miss1BaseAddr": 0x0033bd90, "miss1EXBaseAddr": 0x0033c450, "mission1Score": 1, "mission2Score": 2, "mission3Score": 3, "exMission1Score": 5, "exMission2Score": 5, "exMission3Score": 10, "mission1Id": 357057, "badge1Id": 402256, "mission2Id": 357059, "badge2Id": 402258, "mission3Id": 357061, "badge3Id": 402260, "exMission1Id": 357058, "exBadge1Id": 402257, "exMission2Id": 357060, "exBadge2Id": 402259, "exMission3Id": 357062, "exBadge3Id": 402261 },5: { "name": "Ancient Highway", "gateId": 3, "miss1BaseAddr": 0x0033be50, "miss1EXBaseAddr": 0x0033c510, "mission1Score": 1, "mission2Score": 2, "mission3Score": 3, "exMission1Score": 5, "exMission2Score": 5, "exMission3Score": 10, "mission1Id": 357063, "badge1Id": 402262, "mission2Id": 357065, "badge2Id": 402264, "mission3Id": 357067, "badge3Id": 402262, "exMission1Id": 357064, "exBadge1Id": 402263, "exMission2Id": 357066, "exBadge2Id": 402265, "exMission3Id": 357068, "exBadge3Id": 402267 },6: { "name": "Phantom Storm", "gateId": 4, "miss1BaseAddr": 0x0033bf10, "miss1EXBaseAddr": 0x0033c5d0, "mission1Score": 1, "mission2Score": 2, "mission3Score": 3, "exMission1Score": 5, "exMission2Score": 5, "exMission3Score": 10, "mission1Id": 357069, "badge1Id": 402268, "mission2Id": 357071, "badge2Id": 402270, "mission3Id": 357073, "badge3Id": 402272, "exMission1Id": 357070, "exBadge1Id": 402269, "exMission2Id": 357072, "exBadge2Id": 402271, "exMission3Id": 357074, "exBadge3Id": 402273 },7: { "name": "Sunlight Storm", "gateId": 5, "miss1BaseAddr": 0x0033bfd0, "miss1EXBaseAddr": 0x0033c690, "mission1Score": 1, "mission2Score": 2, "mission3Score": 3, "exMission1Score": 5, "exMission2Score": 5, "exMission3Score": 10, "mission1Id": 357075, "badge1Id": 402274, "mission2Id": 357077, "badge2Id": 402276, "mission3Id": 357079, "badge3Id": 402278, "exMission1Id": 357076, "exBadge1Id": 402275, "exMission2Id": 357078, "exBadge2Id": 402277, "exMission3Id": 357080, "exBadge3Id": 402279 },8: { "name": "Splash Island", "gateId": 6, "miss1BaseAddr": 0x0033c090, "miss1EXBaseAddr": 0x0033c750, "mission1Score": 1, "mission2Score": 2, "mission3Score": 3, "exMission1Score": 5, "exMission2Score": 5, "exMission3Score": 10, "mission1Id": 357081, "badge1Id": 402280, "mission2Id": 357083, "badge2Id": 402282, "mission3Id": 357085, "badge3Id": 402284, "exMission1Id": 357082, "exBadge1Id": 402281, "exMission2Id": 357084, "exBadge2Id": 402283, "exMission3Id": 357086, "exBadge3Id": 402285 },9: { "name": "Floating Island", "gateId": 7, "miss1BaseAddr": 0x0033c150, "miss1EXBaseAddr": 0x0033c810, "mission1Score": 1, "mission2Score": 2, "mission3Score": 3, "exMission1Score": 5, "exMission2Score": 5, "exMission3Score": 10, "mission1Id": 357087, "badge1Id": 402286, "mission2Id": 357089, "badge2Id": 402289, "mission3Id": 357091, "badge3Id": 402291, "exMission1Id": 357088, "exBadge1Id": 402287, "exMission2Id": 357090, "exBadge2Id": 402290, "exMission3Id": 357092, "exBadge3Id": 402292 },10: { "name": "Assault of the Dreadnought", "gateId": 8, "miss1BaseAddr": 0x0033c210, "miss1EXBaseAddr": 0x0033c8d0, "mission1Score": 1, "mission2Score": 2, "mission3Score": 3, "exMission1Score": 5, "exMission2Score": 5, "exMission3Score": 10, "mission1Id": 357093, "badge1Id": 402293, "mission2Id": 357095, "badge2Id": 402295, "mission3Id": 357097, "badge3Id": 402297, "exMission1Id": 357094, "exBadge1Id": 402294, "exMission2Id": 357096, "exBadge2Id": 402296, "exMission3Id": 357098, "exBadge3Id": 402298 },
}

for index in gummiMissions
{
    mission = gummiMissions[index]
    xachievement(title = mission["name"] + " - Gold Medalist", description = "Achieve an S rank in Mission 1 of " + mission["name"] + ".", points = mission["mission1Score"],
        id = mission["mission1Id"], badge = ToString(mission["badge1Id"]),
        trigger = once(gummiMissionLevel() == 1 && worldGateId() == mission["gateId"] && GummiMissionJustStarted() && !IsEXMission())
            && trigger_when(GummiMissionComplete())
            && trigger_when(gummiShipRank() >= 6)
            && never(!IsInLocation("WorldMap"))
            && never(gummiShipPointer() == 0)
    )
    
    xleaderboard(title = mission["name"] + " Mission 1", description = "Get the highest score you can in Mission 1 of " + mission["name"] + "!",
        start = gummiMissionLevel() == 1 && worldGateId() == mission["gateId"] && GummiMissionJustStarted() && !IsEXMission(),
        cancel = !IsInLocation("WorldMap") || gummiShipPointer() == 0,
        submit = GummiMissionComplete(),
        value = gummiShipScore()
    )
    
    xachievement(title = mission["name"] + " - Gold Medalist EX", description = "Achieve an S rank in EX Mission 1 of " + mission["name"] + ".", points = mission["exMission1Score"],
        id = mission["exMission1Id"], badge = ToString(mission["exBadge1Id"]),
        trigger = once(gummiMissionLevel() == 1 && worldGateId() == mission["gateId"] && GummiMissionJustStarted() && IsEXMission())
            && trigger_when(GummiMissionComplete())
            && trigger_when(gummiShipRank() >= 6)
            && never(!IsInLocation("WorldMap"))
            && never(gummiShipPointer() == 0)
    )
    
    xleaderboard(title = mission["name"] + " EX Mission 1", description = "Get the highest score you can in EX Mission 1 of " + mission["name"] + "!",
        start = gummiMissionLevel() == 1 && worldGateId() == mission["gateId"] && GummiMissionJustStarted() && IsEXMission(),
        cancel = !IsInLocation("WorldMap") || gummiShipPointer() == 0,
        submit = GummiMissionComplete(),
        value = gummiShipScore()
    )

    xachievement(title = mission["name"] + " - Ace Pilot", description = "Achieve an S rank in Mission 2 of " + mission["name"] + ".", points = mission["mission2Score"],
        id = mission["mission2Id"], badge = ToString(mission["badge2Id"]),
        trigger = once(gummiMissionLevel() == 2 && worldGateId() == mission["gateId"] && GummiMissionJustStarted() && !IsEXMission())
            && trigger_when(GummiMissionComplete())
            && trigger_when(gummiShipRank() >= 6)
            && never(!IsInLocation("WorldMap"))
            && never(gummiShipPointer() == 0)
    )
    
    xleaderboard(title = mission["name"] + " Mission 2", description = "Get the highest score you can in Mission 2 of " + mission["name"] + "!",
        start = gummiMissionLevel() == 2 && worldGateId() == mission["gateId"] && GummiMissionJustStarted() && !IsEXMission(),
        cancel = !IsInLocation("WorldMap") || gummiShipPointer() == 0,
        submit = GummiMissionComplete(),
        value = gummiShipScore()
    )
    
    xachievement(title = mission["name"] + " - Ace Pilot EX", description = "Achieve an S rank in EX Mission 2 of " + mission["name"] + ".", points = mission["exMission1Score"],
        id = mission["exMission2Id"], badge = ToString(mission["exBadge2Id"]),
        trigger = once(gummiMissionLevel() == 2 && worldGateId() == mission["gateId"] && GummiMissionJustStarted() && IsEXMission())
            && trigger_when(GummiMissionComplete())
            && trigger_when(gummiShipRank() >= 6)
            && never(!IsInLocation("WorldMap"))
            && never(gummiShipPointer() == 0)
    )
    
    xleaderboard(title = mission["name"] + " EX Mission 2", description = "Get the highest score you can in EX Mission 2 of " + mission["name"] + "!",
        start = gummiMissionLevel() == 2 && worldGateId() == mission["gateId"] && GummiMissionJustStarted() && IsEXMission(),
        cancel = !IsInLocation("WorldMap") || gummiShipPointer() == 0,
        submit = GummiMissionComplete(),
        value = gummiShipScore()
    )

    xachievement(title = mission["name"] + " - Scoresetter", description = "Achieve an S rank in Mission 3 of " + mission["name"] + ".", points = mission["mission3Score"],
        id = mission["mission3Id"], badge = ToString(mission["badge3Id"]),
        trigger = once(gummiMissionLevel() == 3 && worldGateId() == mission["gateId"] && GummiMissionJustStarted() && !IsEXMission())
            && trigger_when(GummiMissionComplete())
            && trigger_when(gummiShipRank() >= 6)
            && never(!IsInLocation("WorldMap"))
            && never(gummiShipPointer() == 0)
    )
    
    xleaderboard(title = mission["name"] + " Mission 3", description = "Get the highest score you can in Mission 3 of " + mission["name"] + "!",
        start = gummiMissionLevel() == 3 && worldGateId() == mission["gateId"] && GummiMissionJustStarted() && !IsEXMission(),
        cancel = !IsInLocation("WorldMap") || gummiShipPointer() == 0,
        submit = GummiMissionComplete(),
        value = gummiShipScore()
    )
    
    xachievement(title = mission["name"] + " - Scoresetter EX", description = "Achieve an S rank in EX Mission 3 of " + mission["name"] + ".", points = mission["exMission3Score"],
        id = mission["exMission3Id"], badge = ToString(mission["exBadge3Id"]),
        trigger = once(gummiMissionLevel() == 3 && worldGateId() == mission["gateId"] && GummiMissionJustStarted() && IsEXMission())
            && trigger_when(GummiMissionComplete())
            && trigger_when(gummiShipRank() >= 6)
            && never(!IsInLocation("WorldMap"))
            && never(gummiShipPointer() == 0)
    )
    
    xleaderboard(title = mission["name"] + " EX Mission 3", description = "Get the highest score you can in EX Mission 3 of " + mission["name"] + "!",
        start = gummiMissionLevel() == 3 && worldGateId() == mission["gateId"] && GummiMissionJustStarted() && IsEXMission(),
        cancel = !IsInLocation("WorldMap") || gummiShipPointer() == 0,
        submit = GummiMissionComplete(),
        value = gummiShipScore()
    )
    
    mission1Treasure = float(mission["miss1BaseAddr"] + 0x20)
    mission2Treasure = float(mission["miss1BaseAddr"] + 0x60)
    mission3Treasure = float(mission["miss1BaseAddr"] + 0xa0)
    gummiTreasureConditions = {
        1: { "countsWhen": (mission1Treasure >= 100.0), "recalculateWhen": (Delta(mission1Treasure) != mission1Treasure) },
        2: { "countsWhen": (mission2Treasure >= 100.0), "recalculateWhen": (Delta(mission2Treasure) != mission2Treasure) },
        3: { "countsWhen": (mission3Treasure >= 100.0), "recalculateWhen": (Delta(mission3Treasure) != mission3Treasure) }
    }
    
    GenerateCheevoFromConditions({
        "name": (mission["name"] + " - Treasure Hunter"),
        "description": ("Get 100% treasure in all missions for " + mission["name"] + "."),
        "points": 3,
        "badge": "00000",
        "threshold": length(gummiTreasureConditions)
    }, gummiTreasureConditions, always_true())
}

// This function allows the creation of achievements with built-in save protection that deal with a collection of values being set
// throughout the game. The schemas for both parameters are as follows:
//
// name: title
// description: self-explanatory
// points: self-explanatory
// threshold: how many values in the "conditions" dictionary must be set before this achievement is triggered
// addresses: a list of address accessors that need to have their bits summed (each address must have an "addr" and "bit" value in order to be properly aggregated)
// onlyAvailableWhen: a condition that must be true in all conditions for the achievement to trigger.
// id: self-explanatory
// badge: self-explanatory
function GenerateCheevoFromBits(name, description, points, threshold, addresses, onlyAvailableWhen = always_true(), id = 0, badge = "00000")
{
    bitcounts = GenerateBitcountFromCountableObjects(GetCountableAccessorArrayFromAddressBits(addresses))

    // This is the score when the game is loaded. If the loaded score is greater than or equal to the threshold--that is,
    // if the save file would satisfy enough conditions to trigger the achievement on load--this should trigger a
    // permanant pauselock to serve as save protection.
    shouldTriggerPauselock = once(bitcounts >= threshold && IsLoadingSaveFile())
    
    // We want both loaded and session counts here (that is, we don't care if we're loading a save file when these are tallied).
    // This way, loading a save doesn't invalidate the achievement outright if a player hasn't actually earned it yet.
    trigger = bitcounts >= threshold

    xachievement(title = name, description = description, points = points, badge = badge, id = id,
        trigger = IsAlwaysInGame() && measured(trigger) && unless(shouldTriggerPauselock) && onlyAvailableWhen
            && (always_false() || never(MenuIsActive())) // Reset any potential pauselock when changing save files.
    )
}

function GenerateBitcountFromCountableObjects(addresses)
{
    finalBitcount = 0
    for address in addresses
    {
        if (address["type"] == "byte")
        {
            finalBitcount = finalBitcount + bitcount(address["address"])
        }
        else
        {
            finalBitcount = finalBitcount + address["mem"]
        }
    }
    return finalBitcount
}

function GenerateConditionFromBitflag(bit)
{
    return { "countsWhen": (bit == 1), "recalculateWhen": (Delta(bit) != bit) }
}

// Dictionary elements must have "addr" and "bit" fields.
// Returns a result like the following:
// {
//    <address>: [ <bit indices> ]
// }
function AggregateBitsFromAddressBits(dict)
{
    ret = {}
    for i in dict
    {
        element = dict[i]
        
        if (element["addr"] != -1)
        {
            if (DictionaryKeyExists(ret, element["addr"]) == TRUE())
            {
                arr = ret[element["addr"]]
                array_push(arr, element["bit"])
                ret[element["addr"]] = arr
            }
            else
            {
                ret[element["addr"]] = [ element["bit"] ]
            }
        }
    }
    
    return ret
}

// BEGINNING OF BITFLAG AGGREGATION REGION

// Converts an aggregate dictionary to an array of objects like the following:
// {
//    "type": "bitX"/"byte"
//    "mem": <memory accessor>
//    "address": <memory address>
// }
function ConvertBitAggregatesToBitCountableMemoryAccessors(aggregates)
{
    accessors = []
    for address in aggregates
    {
        agg = aggregates[address]
        if (length(agg) == 8)
        {
            array_push(accessors, { "type": "byte", "mem": byte(address), "address": address })
        }
        else
        {
            // Simply return each bit instead, since we can't use bitcount() on anything but bytes.
            for bit in agg
            {
                if (bit != -1 && address != -1)
                {
                    array_push(accessors, { "type": "bit", "mem": bit(bit, address), "address": address })
                }
            }
        }
    }
    
    return accessors
}

function GetCountableAccessorArrayFromAddressBits(dict)
{
    return ConvertBitAggregatesToBitCountableMemoryAccessors(AggregateBitsFromAddressBits(dict))
}

function GenerateBitcountFromCountableObjects(addresses)
{
    finalBitcount = 0
    for address in addresses
    {
        if (address["type"] == "byte")
        {
            finalBitcount = finalBitcount + bitcount(address["address"])
        }
        else
        {
            finalBitcount = finalBitcount + address["mem"]
        }
    }
    return finalBitcount
}

// END OF BITFLAG AGGREGATION REGION

puzzlePieces = {
    2: { "addr": 0x0032dfd0, "bit": 0 },3: { "addr": 0x0032dfd0, "bit": 1 },4: { "addr": 0x0032dfd0, "bit": 2 },5: { "addr": 0x0032dfd0, "bit": 3 },6: { "addr": 0x0032dfd0, "bit": 4 },7: { "addr": 0x0032dfd0, "bit": 5 },8: { "addr": 0x0032dfd0, "bit": 6 },9: { "addr": 0x0032dfd0, "bit": 7 },10: { "addr": 0x0032dfd1, "bit": 0 },11: { "addr": 0x0032dfd1, "bit": 1 },12: { "addr": 0x0032dfd1, "bit": 2 },13: { "addr": 0x0032dfd1, "bit": 3 },14: { "addr": 0x0032dfd8, "bit": 0 },15: { "addr": 0x0032dfd8, "bit": 1 },16: { "addr": 0x0032dfd8, "bit": 2 },17: { "addr": 0x0032dfd8, "bit": 3 },18: { "addr": 0x0032dfd8, "bit": 4 },19: { "addr": 0x0032dfd8, "bit": 5 },20: { "addr": 0x0032dfd8, "bit": 6 },21: { "addr": 0x0032dfd8, "bit": 7 },22: { "addr": 0x0032dfd9, "bit": 0 },23: { "addr": 0x0032dfd9, "bit": 1 },24: { "addr": 0x0032dfd9, "bit": 2 },25: { "addr": 0x0032dfd9, "bit": 3 },26: { "addr": 0x0032dfe0, "bit": 0 },27: { "addr": 0x0032dfe0, "bit": 1 },28: { "addr": 0x0032dfe0, "bit": 2 },29: { "addr": 0x0032dfe0, "bit": 3 },30: { "addr": 0x0032dfe0, "bit": 4 },31: { "addr": 0x0032dfe0, "bit": 5 },32: { "addr": 0x0032dfe0, "bit": 6 },33: { "addr": 0x0032dfe0, "bit": 7 },34: { "addr": 0x0032dfe1, "bit": 0 },35: { "addr": 0x0032dfe1, "bit": 1 },36: { "addr": 0x0032dfe1, "bit": 2 },37: { "addr": 0x0032dfe1, "bit": 3 },38: { "addr": 0x0032dfe8, "bit": 0 },39: { "addr": 0x0032dfe8, "bit": 1 },40: { "addr": 0x0032dfe8, "bit": 2 },41: { "addr": 0x0032dfe8, "bit": 3 },42: { "addr": 0x0032dfe8, "bit": 4 },43: { "addr": 0x0032dfe8, "bit": 5 },44: { "addr": 0x0032dfe8, "bit": 6 },45: { "addr": 0x0032dfe8, "bit": 7 },46: { "addr": 0x0032dfe9, "bit": 0 },47: { "addr": 0x0032dfe9, "bit": 1 },48: { "addr": 0x0032dfe9, "bit": 2 },49: { "addr": 0x0032dfe9, "bit": 3 },50: { "addr": 0x0032dff0, "bit": 0 },51: { "addr": 0x0032dff0, "bit": 1 },52: { "addr": 0x0032dff0, "bit": 2 },53: { "addr": 0x0032dff0, "bit": 3 },54: { "addr": 0x0032dff0, "bit": 4 },55: { "addr": 0x0032dff0, "bit": 5 },56: { "addr": 0x0032dff0, "bit": 6 },57: { "addr": 0x0032dff0, "bit": 7 },58: { "addr": 0x0032dff1, "bit": 0 },59: { "addr": 0x0032dff1, "bit": 1 },60: { "addr": 0x0032dff1, "bit": 2 },61: { "addr": 0x0032dff1, "bit": 3 },62: { "addr": 0x0032dff1, "bit": 4 },63: { "addr": 0x0032dff1, "bit": 5 },64: { "addr": 0x0032dff1, "bit": 6 },65: { "addr": 0x0032dff1, "bit": 7 },66: { "addr": 0x0032dff2, "bit": 0 },67: { "addr": 0x0032dff2, "bit": 1 },68: { "addr": 0x0032dff2, "bit": 2 },69: { "addr": 0x0032dff2, "bit": 3 },70: { "addr": 0x0032dff2, "bit": 4 },71: { "addr": 0x0032dff2, "bit": 5 },72: { "addr": 0x0032dff2, "bit": 6 },73: { "addr": 0x0032dff2, "bit": 7 },74: { "addr": 0x0032dff3, "bit": 0 },75: { "addr": 0x0032dff3, "bit": 1 },76: { "addr": 0x0032dff3, "bit": 2 },77: { "addr": 0x0032dff3, "bit": 3 },78: { "addr": 0x0032dff3, "bit": 4 },79: { "addr": 0x0032dff3, "bit": 5 },80: { "addr": 0x0032dff3, "bit": 6 },81: { "addr": 0x0032dff3, "bit": 7 },82: { "addr": 0x0032dff4, "bit": 0 },83: { "addr": 0x0032dff4, "bit": 1 },84: { "addr": 0x0032dff4, "bit": 2 },85: { "addr": 0x0032dff4, "bit": 3 },86: { "addr": 0x0032dff4, "bit": 4 },87: { "addr": 0x0032dff4, "bit": 5 },88: { "addr": 0x0032dff4, "bit": 6 },89: { "addr": 0x0032dff4, "bit": 7 },90: { "addr": 0x0032dff5, "bit": 0 },91: { "addr": 0x0032dff5, "bit": 1 },92: { "addr": 0x0032dff5, "bit": 2 },93: { "addr": 0x0032dff5, "bit": 3 },94: { "addr": 0x0032dff5, "bit": 4 },95: { "addr": 0x0032dff5, "bit": 5 },96: { "addr": 0x0032dff5, "bit": 6 },97: { "addr": 0x0032dff5, "bit": 7 },98: { "addr": 0x0032dff8, "bit": 0 },99: { "addr": 0x0032dff8, "bit": 1 },100: { "addr": 0x0032dff8, "bit": 2 },101: { "addr": 0x0032dff8, "bit": 3 },102: { "addr": 0x0032dff8, "bit": 4 },103: { "addr": 0x0032dff8, "bit": 5 },104: { "addr": 0x0032dff8, "bit": 6 },105: { "addr": 0x0032dff8, "bit": 7 },106: { "addr": 0x0032dff9, "bit": 0 },107: { "addr": 0x0032dff9, "bit": 1 },108: { "addr": 0x0032dff9, "bit": 2 },109: { "addr": 0x0032dff9, "bit": 3 },110: { "addr": 0x0032dff9, "bit": 4 },111: { "addr": 0x0032dff9, "bit": 5 },112: { "addr": 0x0032dff9, "bit": 6 },113: { "addr": 0x0032dff9, "bit": 7 },114: { "addr": 0x0032dffa, "bit": 0 },115: { "addr": 0x0032dffa, "bit": 1 },116: { "addr": 0x0032dffa, "bit": 2 },117: { "addr": 0x0032dffa, "bit": 3 },118: { "addr": 0x0032dffa, "bit": 4 },119: { "addr": 0x0032dffa, "bit": 5 },120: { "addr": 0x0032dffa, "bit": 6 },121: { "addr": 0x0032dffa, "bit": 7 },122: { "addr": 0x0032dffb, "bit": 0 },123: { "addr": 0x0032dffb, "bit": 1 },124: { "addr": 0x0032dffb, "bit": 2 },125: { "addr": 0x0032dffb, "bit": 3 },126: { "addr": 0x0032dffb, "bit": 4 },127: { "addr": 0x0032dffb, "bit": 5 },128: { "addr": 0x0032dffb, "bit": 6 },129: { "addr": 0x0032dffb, "bit": 7 },130: { "addr": 0x0032dffc, "bit": 0 },131: { "addr": 0x0032dffc, "bit": 1 },132: { "addr": 0x0032dffc, "bit": 2 },133: { "addr": 0x0032dffc, "bit": 3 },134: { "addr": 0x0032dffc, "bit": 4 },135: { "addr": 0x0032dffc, "bit": 5 },136: { "addr": 0x0032dffc, "bit": 6 },137: { "addr": 0x0032dffc, "bit": 7 },138: { "addr": 0x0032dffd, "bit": 0 },139: { "addr": 0x0032dffd, "bit": 1 },140: { "addr": 0x0032dffd, "bit": 2 },141: { "addr": 0x0032dffd, "bit": 3 },142: { "addr": 0x0032dffd, "bit": 4 },143: { "addr": 0x0032dffd, "bit": 5 },144: { "addr": 0x0032dffd, "bit": 6 },145: { "addr": 0x0032dffd, "bit": 7 },
}

GenerateCheevoFromBits(name = "Rookie Puzzler", description = "Collect " + (length(puzzlePieces) / 10) + " Puzzle Pieces.", points = 3,
    addresses = puzzlePieces,
    threshold = length(puzzlePieces) / 10,
    onlyAvailableWhen = always_true())
    
GenerateCheevoFromBits(name = "Regular Puzzler", description = "Collect " + (length(puzzlePieces) / 4) + " Puzzle Pieces.", points = 5,
    addresses = puzzlePieces,
    threshold = length(puzzlePieces) / 4,
    onlyAvailableWhen = always_true())
    
GenerateCheevoFromBits(name = "Veteran Puzzler", description = "Collect " + (length(puzzlePieces) / 2) + " Puzzle Pieces.", points = 10,
    addresses = puzzlePieces,
    threshold = length(puzzlePieces) / 2,
    onlyAvailableWhen = always_true())
    
GenerateCheevoFromBits(name = "Legendary Puzzler", description = "Collect all " + length(puzzlePieces) + " Puzzle Pieces.", points = 25,
    addresses = puzzlePieces,
    threshold = length(puzzlePieces),
    onlyAvailableWhen = always_true())
    
GenerateCheevoFromBits(name = "Enigmatologist", description = "Solve all puzzles.", points = 5,
    addresses = {
        1: { "addr": 0x0033094c, "bit": 0 },
        2: { "addr": 0x0033094c, "bit": 1 },
        3: { "addr": 0x0033094c, "bit": 2 },
        4: { "addr": 0x0033094c, "bit": 3 },
        5: { "addr": 0x0033094c, "bit": 4 },
        6: { "addr": 0x0033094c, "bit": 5 }
    },
    threshold = 6
)

function moogleExp() => dword(0x00330560)
function JustReachedMaxMoogleLevel() => Delta(moogleExp()) < 0x7bc && measured(moogleExp() >= 0x7bc)
xachievement(title = "Master Synthesist", description = "Max out your Moogle LV in Item Synthesis.", points = 5,
    trigger = !IsLoadingSaveFile() && JustReachedMaxMoogleLevel()
)

function ultimaWeaponsEarned() => byte(0x0032f1bf)
function JustEarnedUltimaWeapon() => Delta(ultimaWeaponsEarned()) == 0 && ultimaWeaponsEarned() == 1
xachievement(title = "Speller of Endings", description = "Synthesize Ultima Weapon.", points = 10,
    trigger = !IsLoadingSaveFile() && JustEarnedUltimaWeapon()
)

if (generateBonusAchievements())
{
    for event in registeredEvents
    {
        dat = registeredEvents[event]
        
        if (dat["lv1"] == 1)
        {
            description = ""
            article = ""
            
            if (dat["isProper"] == 0)
            {
                article = "the "
            }
        
            if (dat["isBoss"] == 1)
            {
                description = "Defeat " + article + dat["eventKey"] + " at Level 1 on Critical Mode without dying."
            }
            else
            {
                description = "Complete the " + dat["eventKey"] + " at Level 1 on Critical Mode."
            }
        
            achievement(title = dat["eventKey"] + " [m]", description = description, points = dat["score"],
                trigger = GetCheckpointForRegisteredEvent(dat["eventKey"], when = level() <= 1 && IsAtLeastOnDifficulty("Critical"))
                    && trigger_when(BonusObtained())
            )   
        }
    }
    
    achievement(title = "Cavern of Remembrance Gauntlet [m]", description = "Survive the final enemy wave in the Cavern of Remembrance at Level 1 on Critical Mode.",
        points = 50,
        trigger = IsInLocation("CavernTransport") && IsAtLeastOnDifficulty("Critical") && level() <= 1
            && trigger_when(BonusObtained())
    )
    
    achievement(title = "Lingering Will [m]", description = "Defeat the Lingering Will at Level 1 on Critical Mode.", points = 100,
        trigger = (GetCheckpointForRegisteredEvent("Lingering Will", when = level() <= 1 && IsAtLeastOnDifficulty("Critical"))
                || GetCheckpointForRegisteredEvent("Lingering Will 2", when = level() <= 1 && IsAtLeastOnDifficulty("Critical")))
            && trigger_when(JustWonBattle())
    )
    
    achievement(title = "Pain and Panic Cup [m]", description = "Win the Pain and Panic Cup at Level 1 on Critical Mode.", points = 25,
        trigger = PainAndPanicCupCheckpointReached(when = level() <= 1 && IsAtLeastOnDifficulty("Critical"))
            && trigger_when(WonThePainAndPanicCup())
    )
    
    achievement(title = "Cerberus Cup [m]", description = "Win the Cerberus Cup at Level 1 on Critical Mode.",
        points = 25,
        trigger = CerberusCupCheckpointReached(when = level() <= 1 && IsAtLeastOnDifficulty("Critical"))
            && trigger_when(WonTheCerberusCup())
    )
    
    achievement(title = "Titan Cup [m]", description = "Win the Titan Cup at Level 1 on Critical Mode.",
        points = 25,
        trigger = TitanCupCheckpointReached(when = level() <= 1 && IsAtLeastOnDifficulty("Critical"))
            && trigger_when(WonTheTitanCup())
    )
    
    achievement(title = "Goddess of Fate Cup [m]", description = "Win the Goddess of Fate Cup at Level 1 on Critical Mode.",
        points = 25,
        trigger = GoddessOfFateCupCheckpointReached(when = level() <= 1 && IsAtLeastOnDifficulty("Critical"))
            && trigger_when(WonTheGoddessOfFateCup())
    )
    
    achievement(title = "Pain and Panic Paradox Cup [m]", description = "Win the Pain and Panic Paradox Cup at Level 1 on Critical Mode.", points = 50,
        trigger = PainAndPanicParadoxCupCheckpointReached(when = level() <= 1 && IsAtLeastOnDifficulty("Critical"))
            && trigger_when(WonThePainAndPanicParadoxCup())
    )
    
    achievement(title = "Cerberus Paradox Cup [m]", description = "Win the Cerberus Paradox Cup at Level 1 on Critical Mode.",
        points = 50,
        trigger = CerberusParadoxCupCheckpointReached(when = level() <= 1 && IsAtLeastOnDifficulty("Critical"))
            && trigger_when(WonTheCerberusParadoxCup())
    )
    
    achievement(title = "Titan Paradox Cup [m]", description = "Win the Titan Paradox Cup at Level 1 on Critical Mode.",
        points = 50,
        trigger = TitanParadoxCupCheckpointReached(when = level() <= 1 && IsAtLeastOnDifficulty("Critical"))
            && trigger_when(WonTheTitanParadoxCup())
    )
    
    achievement(title = "Hades Paradox Cup [m]", description = "Win the Hades Paradox Cup at Level 1 on Critical Mode.", points = 100,
        trigger = HadesParadoxCupCheckpointReached(when = level() <= 1 && IsAtLeastOnDifficulty("Critical"))
            && trigger_when(WonTheHadesParadoxCup())
    )
}

