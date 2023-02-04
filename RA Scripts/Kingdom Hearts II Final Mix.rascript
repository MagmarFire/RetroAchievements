// Kingdom Hearts II: Final Mix
// #ID = 2781

function Delta(mem) => prev(mem)

function LMeasured(condition) => measured(repeated(0, condition)) // Legacy `measured` polyfill. measured(A && B) is no longer supported as of v1.10.0.

areas = {
    65535: { "worldId": 255, "name": "Title", "display": "On the title screen…", "areaId": 255, "hideWorld": 1, },523: { "worldId": 2, "name": "SunsetStation", "display": "Sunset Station", "areaId": 11, "hideWorld": 0, },522: { "worldId": 2, "name": "SunsetTerrace", "display": "Sunset Terrace", "areaId": 10, "hideWorld": 0, },548: { "worldId": 2, "name": "Tunnelway", "display": "Tunnelway", "areaId": 36, "hideWorld": 0, },524: { "worldId": 2, "name": "SunsetHill", "display": "Sunset Hill", "areaId": 12, "hideWorld": 0, },520: { "worldId": 2, "name": "StationPlaza", "display": "Station Plaza", "areaId": 8, "hideWorld": 0, },518: { "worldId": 2, "name": "StationHeights", "display": "Market Street: Station Heights", "areaId": 6, "hideWorld": 0, },515: { "worldId": 2, "name": "BackAlley", "display": "Back Alley", "areaId": 3, "hideWorld": 0, },514: { "worldId": 2, "name": "UsualSpot", "display": "The Usual Spot", "areaId": 2, "hideWorld": 0, },516: { "worldId": 2, "name": "Sandlot", "display": "Sandlot", "areaId": 4, "hideWorld": 0, },519: { "worldId": 2, "name": "TramCommon", "display": "Market Street: Tram Common", "areaId": 7, "hideWorld": 0, },525: { "worldId": 2, "name": "Woods", "display": "The Woods", "areaId": 13, "hideWorld": 0, },513: { "worldId": 2, "name": "RoxasRoom", "display": "Roxas’s Room", "areaId": 1, "hideWorld": 0, },526: { "worldId": 2, "name": "Courtyard", "display": "Mansion: Courtyard", "areaId": 14, "hideWorld": 0, },527: { "worldId": 2, "name": "Foyer", "display": "Mansion: Foyer", "areaId": 15, "hideWorld": 0, },530: { "worldId": 2, "name": "WhiteRoom", "display": "Mansion: The White Room", "areaId": 18, "hideWorld": 0, },529: { "worldId": 2, "name": "Library", "display": "Mansion: Library", "areaId": 17, "hideWorld": 0, },533: { "worldId": 2, "name": "ComputerRoom", "display": "Mansion: Computer Room", "areaId": 21, "hideWorld": 0, },531: { "worldId": 2, "name": "BasementHall", "display": "Mansion: Basement Hall", "areaId": 19, "hideWorld": 0, },532: { "worldId": 2, "name": "BasementHallAxel", "display": "Mansion: Basement Hall", "areaId": 20, "hideWorld": 0, },534: { "worldId": 2, "name": "BasementCorridor", "display": "Mansion: Basement Corridor", "areaId": 22, "hideWorld": 0, },535: { "worldId": 2, "name": "PodRoom", "display": "Mansion: Pod Room", "areaId": 23, "hideWorld": 0, },544: { "worldId": 2, "name": "StationOfSerenity", "display": "Station of Serenity", "areaId": 32, "hideWorld": 1, },545: { "worldId": 2, "name": "StationOfCalling", "display": "Station of Calling", "areaId": 33, "hideWorld": 1, },546: { "worldId": 2, "name": "StationOfAwakening", "display": "Station of Awakening", "areaId": 34, "hideWorld": 1, },517: { "worldId": 2, "name": "SandlotBattlefield", "display": "Sandlot", "areaId": 5, "hideWorld": 0, },521: { "worldId": 2, "name": "CentralStation", "display": "Central Station", "areaId": 9, "hideWorld": 0, },537: { "worldId": 2, "name": "Tower", "display": "The Tower", "areaId": 25, "hideWorld": 1, },541: { "worldId": 2, "name": "StarChamber", "display": "Tower: Star Chamber", "areaId": 29, "hideWorld": 1, },543: { "worldId": 2, "name": "WaywardStairs", "display": "Tower: Wayward Stairs", "areaId": 31, "hideWorld": 1, },550: { "worldId": 2, "name": "WaywardStairs2", "display": "Tower: Wayward Stairs", "areaId": 38, "hideWorld": 1, },542: { "worldId": 2, "name": "MoonChamber", "display": "Tower: Moon Chamber", "areaId": 30, "hideWorld": 1, },551: { "worldId": 2, "name": "WaywardStairs3", "display": "Tower: Wayward Stairs", "areaId": 39, "hideWorld": 1, },539: { "worldId": 2, "name": "SorcererLoft", "display": "Tower: Sorcerer’s Loft", "areaId": 27, "hideWorld": 1, },540: { "worldId": 2, "name": "Wardrobe", "display": "Tower: Wardrobe", "areaId": 28, "hideWorld": 1, },3840: { "worldId": 15, "name": "WorldMap", "display": "World Map", "areaId": 0, "hideWorld": 1, },1024: { "worldId": 4, "name": "VillainVale", "display": "Villain’s Vale", "areaId": 0, "hideWorld": 0, },1034: { "worldId": 4, "name": "Marketplace", "display": "Marketplace", "areaId": 10, "hideWorld": 0, },1033: { "worldId": 4, "name": "Borough", "display": "Borough", "areaId": 9, "hideWorld": 0, },1037: { "worldId": 4, "name": "Merlin", "display": "Merlin’s House", "areaId": 13, "hideWorld": 0, },2048: { "worldId": 8, "name": "BambooGrove", "display": "Bamboo Grove", "areaId": 0, "hideWorld": 0, },2049: { "worldId": 8, "name": "Encampment", "display": "Encampment", "areaId": 1, "hideWorld": 0, },2050: { "worldId": 8, "name": "Checkpoint", "display": "Checkpoint", "areaId": 2, "hideWorld": 0, },2052: { "worldId": 8, "name": "Village", "display": "Village", "areaId": 4, "hideWorld": 0, },2051: { "worldId": 8, "name": "MountainTrail", "display": "Mountain Trail", "areaId": 3, "hideWorld": 0, },2053: { "worldId": 8, "name": "VillageCave", "display": "Village Cave", "areaId": 5, "hideWorld": 0, },2060: { "worldId": 8, "name": "RuinedVillage", "display": "Village", "areaId": 12, "hideWorld": 0, },2054: { "worldId": 8, "name": "Ridge", "display": "Ridge", "areaId": 6, "hideWorld": 0, },2055: { "worldId": 8, "name": "Summit", "display": "Summit", "areaId": 7, "hideWorld": 0, },2056: { "worldId": 8, "name": "ImperialSquare", "display": "Imperial Square", "areaId": 8, "hideWorld": 0, },2057: { "worldId": 8, "name": "PalaceGate", "display": "Palace Gate", "areaId": 9, "hideWorld": 0, },1280: { "worldId": 5, "name": "EntranceHall", "display": "Entrance Hall", "areaId": 0, "hideWorld": 0, },1281: { "worldId": 5, "name": "Parlor", "display": "Parlor", "areaId": 1, "hideWorld": 0, },1286: { "worldId": 5, "name": "BeastCourtyard", "display": "Courtyard", "areaId": 6, "hideWorld": 0, },1282: { "worldId": 5, "name": "BelleRoom", "display": "Belle’s Room", "areaId": 2, "hideWorld": 0, },1287: { "worldId": 5, "name": "EastWing", "display": "The East Wing", "areaId": 7, "hideWorld": 0, },1284: { "worldId": 5, "name": "Ballroom", "display": "Ballroom", "areaId": 4, "hideWorld": 0, },1288: { "worldId": 5, "name": "WestHall", "display": "The West Hall", "areaId": 8, "hideWorld": 0, },1291: { "worldId": 5, "name": "Undercroft", "display": "Undercroft", "areaId": 11, "hideWorld": 0, },1290: { "worldId": 5, "name": "Dungeon", "display": "Dungeon", "areaId": 10, "hideWorld": 0, },1292: { "worldId": 5, "name": "SecretPassage", "display": "Secret Passage", "areaId": 12, "hideWorld": 0, },1289: { "worldId": 5, "name": "WestWing", "display": "The West Wing", "areaId": 9, "hideWorld": 0, },1283: { "worldId": 5, "name": "BeastRoom", "display": "The Beast’s Room", "areaId": 3, "hideWorld": 0, },1285: { "worldId": 5, "name": "BallroomBattle", "display": "Ballroom", "areaId": 5, "hideWorld": 0, },2304: { "worldId": 9, "name": "Book", "display": "The Hundred Acre Wood", "areaId": 0, "hideWorld": 1, },2306: { "worldId": 9, "name": "PoohHouse", "display": "Pooh Bear’s House", "areaId": 2, "hideWorld": 0, },1542: { "worldId": 6, "name": "HadesChamber", "display": "Hades’ Chamber", "areaId": 6, "hideWorld": 0, },1541: { "worldId": 6, "name": "ValleyOfTheDead", "display": "Valley of the Dead", "areaId": 5, "hideWorld": 0, },1546: { "worldId": 6, "name": "CaveOfTheDeadInnerChamber", "display": "Cave of the Dead: Inner Chamber", "areaId": 10, "hideWorld": 0, },1551: { "worldId": 6, "name": "CaveOfTheDeadPassage", "display": "Cave of the Dead: Passage", "areaId": 15, "hideWorld": 0, },1539: { "worldId": 6, "name": "UnderworldEntrance", "display": "Underworld Entrance", "areaId": 3, "hideWorld": 0, },1543: { "worldId": 6, "name": "CaveOfTheDeadEntrance", "display": "Cave of the Dead: Entrance", "areaId": 7, "hideWorld": 0, },1537: { "worldId": 6, "name": "ColiseumGates", "display": "Coliseum Gates", "areaId": 1, "hideWorld": 0, },1540: { "worldId": 6, "name": "ColiseumFoyer", "display": "Coliseum Foyer", "areaId": 4, "hideWorld": 0, },1536: { "worldId": 6, "name": "Coliseum", "display": "The Coliseum", "areaId": 0, "hideWorld": 0, },1547: { "worldId": 6, "name": "UnderworldCavernsEntrance", "display": "Underworld Caverns: Entrance", "areaId": 11, "hideWorld": 0, },1552: { "worldId": 6, "name": "UnderworldCavernsLostRoad", "display": "Underworld Caverns: The Lost Road", "areaId": 16, "hideWorld": 0, },1553: { "worldId": 6, "name": "UnderworldCavernsAtrium", "display": "Underworld Caverns: Atrium", "areaId": 17, "hideWorld": 0, },1548: { "worldId": 6, "name": "UnderworldLock", "display": "The Lock", "areaId": 12, "hideWorld": 0, },1544: { "worldId": 6, "name": "UnderworldLock2", "display": "The Lock", "areaId": 8, "hideWorld": 0, },1554: { "worldId": 6, "name": "ColiseumGatesRuined", "display": "Coliseum Gates", "areaId": 18, "hideWorld": 0, },3075: { "worldId": 12, "name": "CastleCourtyard", "display": "Courtyard", "areaId": 3, "hideWorld": 0, },3074: { "worldId": 12, "name": "CastleColonnade", "display": "Colonnade", "areaId": 2, "hideWorld": 0, },3073: { "worldId": 12, "name": "CastleLibrary", "display": "Library", "areaId": 1, "hideWorld": 0, },3072: { "worldId": 12, "name": "CastleAudienceChamber", "display": "Audience Chamber", "areaId": 0, "hideWorld": 0, },3076: { "worldId": 12, "name": "CastleCornerstone", "display": "The Hall of the Cornerstone", "areaId": 4, "hideWorld": 0, },3328: { "worldId": 13, "name": "RiverCornerstoneHill", "display": "Cornerstone Hill", "areaId": 0, "hideWorld": 0, },3329: { "worldId": 13, "name": "RiverPier", "display": "Pier", "areaId": 1, "hideWorld": 0, },3335: { "worldId": 13, "name": "MickeyHouse", "display": "Mickey’s House", "areaId": 7, "hideWorld": 0, },3334: { "worldId": 13, "name": "Fire", "display": "Scene of the Fire", "areaId": 6, "hideWorld": 0, },3332: { "worldId": 13, "name": "Lilliput", "display": "Lilliput", "areaId": 4, "hideWorld": 0, },3333: { "worldId": 13, "name": "BuildingSite", "display": "Building Site", "areaId": 5, "hideWorld": 0, },3336: { "worldId": 13, "name": "VillainFlashback", "display": "Villain’s Vale", "areaId": 8, "hideWorld": 1, },3331: { "worldId": 13, "name": "RiverWharf", "display": "Wharf", "areaId": 3, "hideWorld": 0, },3330: { "worldId": 13, "name": "RiverWaterway", "display": "Waterway", "areaId": 2, "hideWorld": 0, },4104: { "worldId": 16, "name": "PortRockFace", "display": "Isla de Muerta: Rock Face", "areaId": 8, "hideWorld": 0, },4105: { "worldId": 16, "name": "PortCaveMouth", "display": "Isla de Muerta: Cave Mouth", "areaId": 9, "hideWorld": 0, },4097: { "worldId": 16, "name": "PortHarbor", "display": "Harbor", "areaId": 1, "hideWorld": 0, },4098: { "worldId": 16, "name": "PortTown", "display": "Town", "areaId": 2, "hideWorld": 0, },4096: { "worldId": 16, "name": "PortRampart", "display": "Rampart", "areaId": 0, "hideWorld": 0, },4099: { "worldId": 16, "name": "PortInterceptor", "display": "The Interceptor", "areaId": 3, "hideWorld": 0, },4100: { "worldId": 16, "name": "PortInterceptorHold", "display": "The Interceptor: Ship’s Hold", "areaId": 4, "hideWorld": 0, },4117: { "worldId": 16, "name": "PortInterceptorBattle", "display": "The Interceptor", "areaId": 21, "hideWorld": 0, },4103: { "worldId": 16, "name": "PortInterceptorDualBattle", "display": "The Interceptor", "areaId": 7, "hideWorld": 0, },4108: { "worldId": 16, "name": "PortPowderStore", "display": "Isla de Muerta: Powder Store", "areaId": 12, "hideWorld": 0, },4109: { "worldId": 16, "name": "PortNook", "display": "Isla de Muerta: Moonlight Nook", "areaId": 13, "hideWorld": 0, },4106: { "worldId": 16, "name": "PortHeap", "display": "Isla de Muerta: Treasure Heap", "areaId": 10, "hideWorld": 0, },3586: { "worldId": 14, "name": "HalloweenGraveyard", "display": "Graveyard", "areaId": 2, "hideWorld": 0, },3585: { "worldId": 14, "name": "HalloweenLab", "display": "Dr. Finkelstein’s Lab", "areaId": 1, "hideWorld": 0, },3584: { "worldId": 14, "name": "HalloweenSquare", "display": "Halloween Town Square", "areaId": 0, "hideWorld": 1, },3588: { "worldId": 14, "name": "HalloweenHinterlands", "display": "Hinterlands", "areaId": 4, "hideWorld": 0, },3589: { "worldId": 14, "name": "HalloweenYuletide", "display": "Christmas Town: Yuletide Hill", "areaId": 5, "hideWorld": 1, },3590: { "worldId": 14, "name": "HalloweenCandyCane", "display": "Christmas Town: Candy Cane Lane", "areaId": 6, "hideWorld": 1, },3592: { "worldId": 14, "name": "HalloweenSanta", "display": "Christmas Town: Santa’s House", "areaId": 8, "hideWorld": 1, },3587: { "worldId": 14, "name": "HalloweenHill", "display": "Curly Hill", "areaId": 3, "hideWorld": 0, },3593: { "worldId": 14, "name": "HalloweenFactory", "display": "Christmas Town: Toy Factory: Shipping and Receiving", "areaId": 9, "hideWorld": 1, },1794: { "worldId": 7, "name": "AgrabahShop", "display": "The Peddler’s Shop", "areaId": 2, "hideWorld": 0, },1792: { "worldId": 7, "name": "Agrabah", "display": "Agrabah", "areaId": 0, "hideWorld": 1, },1793: { "worldId": 7, "name": "AgrabahBazaar", "display": "Bazaar", "areaId": 1, "hideWorld": 0, },1798: { "worldId": 7, "name": "AgrabahWalls", "display": "Palace Walls", "areaId": 6, "hideWorld": 0, },1799: { "worldId": 7, "name": "AgrabahCaveEntrance", "display": "The Cave of Wonders: Entrance", "areaId": 7, "hideWorld": 0, },1804: { "worldId": 7, "name": "AgrabahCaveValley", "display": "The Cave of Wonders: Valley of Stone", "areaId": 12, "hideWorld": 0, },1801: { "worldId": 7, "name": "AgrabahCaveGuardians", "display": "The Cave of Wonders: Stone Guardians", "areaId": 9, "hideWorld": 0, },1805: { "worldId": 7, "name": "AgrabahCaveChasm", "display": "The Cave of Wonders: Chasm of Challenges", "areaId": 13, "hideWorld": 0, },1802: { "worldId": 7, "name": "AgrabahCaveTreasure", "display": "The Cave of Wonders: Treasure Room", "areaId": 10, "hideWorld": 0, },1795: { "worldId": 7, "name": "AgrabahPalace", "display": "The Palace", "areaId": 3, "hideWorld": 0, },2566: { "worldId": 10, "name": "PrideGorge", "display": "Gorge", "areaId": 6, "hideWorld": 0, },2565: { "worldId": 10, "name": "PrideGraveyard", "display": "Elephant Graveyard", "areaId": 5, "hideWorld": 0, },2564: { "worldId": 10, "name": "PrideSavannah", "display": "The Savannah", "areaId": 4, "hideWorld": 0, },2560: { "worldId": 10, "name": "PrideRock", "display": "Pride Rock", "areaId": 0, "hideWorld": 0, },2561: { "worldId": 10, "name": "PrideHollow", "display": "Stone Hollow", "areaId": 1, "hideWorld": 0, },2563: { "worldId": 10, "name": "PrideValley", "display": "Wildebeest Valley", "areaId": 3, "hideWorld": 0, },2567: { "worldId": 10, "name": "PrideWastelands", "display": "Wastelands", "areaId": 7, "hideWorld": 0, },2568: { "worldId": 10, "name": "PrideJungle", "display": "Jungle", "areaId": 8, "hideWorld": 0, },2569: { "worldId": 10, "name": "PrideOasis", "display": "Oasis", "areaId": 9, "hideWorld": 0, },2562: { "worldId": 10, "name": "PrideDen", "display": "The King’s Den", "areaId": 2, "hideWorld": 0, },2573: { "worldId": 10, "name": "PridePeak", "display": "Peak", "areaId": 13, "hideWorld": 0, },2574: { "worldId": 10, "name": "PridePeakBattle", "display": "Peak", "areaId": 14, "hideWorld": 0, },1545: { "worldId": 6, "name": "ColiseumTourney1", "display": "The Underdrome", "areaId": 9, "hideWorld": 0, },1549: { "worldId": 6, "name": "ColiseumVictory", "display": "The Underdrome", "areaId": 13, "hideWorld": 0, },4112: { "worldId": 16, "name": "PortRockFace2", "display": "Isla de Muerta: Rock Face", "areaId": 16, "hideWorld": 0, },1032: { "worldId": 4, "name": "Bailey", "display": "Bailey", "areaId": 8, "hideWorld": 0, },1031: { "worldId": 4, "name": "RestorationSite", "display": "Restoration Site", "areaId": 7, "hideWorld": 0, },1030: { "worldId": 4, "name": "Postern", "display": "Postern", "areaId": 6, "hideWorld": 0, },1035: { "worldId": 4, "name": "Corridors", "display": "Corridors", "areaId": 11, "hideWorld": 0, },1029: { "worldId": 4, "name": "AnsemStudy", "display": "Ansem’s Study", "areaId": 5, "hideWorld": 0, },4352: { "worldId": 17, "name": "SpaceCell", "display": "Pit Cell", "areaId": 0, "hideWorld": 0, },4353: { "worldId": 17, "name": "SpaceCanyon", "display": "Canyon", "areaId": 1, "hideWorld": 0, },4354: { "worldId": 17, "name": "SpaceGrid", "display": "Game Grid", "areaId": 2, "hideWorld": 0, },4355: { "worldId": 17, "name": "SpaceDataspace", "display": "Dataspace", "areaId": 3, "hideWorld": 0, },4356: { "worldId": 17, "name": "SpaceIOTowerHallway", "display": "I/O Tower: Hallway", "areaId": 4, "hideWorld": 0, },4357: { "worldId": 17, "name": "SpaceIOCommunications", "display": "I/O Tower: Communications Room", "areaId": 5, "hideWorld": 0, },1043: { "worldId": 4, "name": "RestorationSiteCutscene", "display": "Restoration Site", "areaId": 19, "hideWorld": 0, },1044: { "worldId": 4, "name": "CorridorsBattle", "display": "Corridors", "areaId": 20, "hideWorld": 0, },1045: { "worldId": 4, "name": "CavernDepths", "display": "Cavern of Remembrance: Depths", "areaId": 21, "hideWorld": 1, },1042: { "worldId": 4, "name": "RestorationSiteCutscene2", "display": "Restoration Site", "areaId": 18, "hideWorld": 0, },1028: { "worldId": 4, "name": "CastleGate", "display": "Castle Gate", "areaId": 4, "hideWorld": 0, },1040: { "worldId": 4, "name": "RavineTrail", "display": "Ravine Trail", "areaId": 16, "hideWorld": 0, },1027: { "worldId": 4, "name": "CrystalFissure", "display": "Crystal Fissure", "areaId": 3, "hideWorld": 0, },1026: { "worldId": 4, "name": "GreatMawCutscene", "display": "The Great Maw", "areaId": 2, "hideWorld": 0, },1039: { "worldId": 4, "name": "AnsemStudyCutscene", "display": "Ansem’s Study", "areaId": 15, "hideWorld": 0, },1041: { "worldId": 4, "name": "GreatMaw", "display": "The Great Maw", "areaId": 17, "hideWorld": 0, },2058: { "worldId": 8, "name": "DragonAntechamber", "display": "Antechamber", "areaId": 10, "hideWorld": 0, },2059: { "worldId": 8, "name": "DragonThrone", "display": "Throne Room", "areaId": 11, "hideWorld": 0, },1295: { "worldId": 5, "name": "BeastBridge", "display": "Bridge", "areaId": 15, "hideWorld": 0, },1555: { "worldId": 6, "name": "ColiseumTourneyHades", "display": "The Underdrome", "areaId": 19, "hideWorld": 0, },4101: { "worldId": 16, "name": "PortPearl", "display": "The Black Pearl", "areaId": 5, "hideWorld": 0, },4102: { "worldId": 16, "name": "PortPearlCaptain", "display": "The Black Pearl: Captain’s Stateroom", "areaId": 6, "hideWorld": 0, },4115: { "worldId": 16, "name": "PortPearlBattle", "display": "The Black Pearl", "areaId": 19, "hideWorld": 0, },4107: { "worldId": 16, "name": "PortGraveyardInterceptor", "display": "Ship Graveyard: The Interceptor’s Hold", "areaId": 11, "hideWorld": 0, },4111: { "worldId": 16, "name": "PortGraveyardRow", "display": "Ship Graveyard: Seadrift Row", "areaId": 15, "hideWorld": 0, },4110: { "worldId": 16, "name": "PortGraveyardKeep", "display": "Ship Graveyard: Seadrift Keep", "areaId": 14, "hideWorld": 0, },4120: { "worldId": 16, "name": "PortHarborCutscene", "display": "Harbor", "areaId": 24, "hideWorld": 0, },3594: { "worldId": 14, "name": "HalloweenWrapping", "display": "Christmas Town: The Wrapping Room", "areaId": 10, "hideWorld": 1, },3591: { "worldId": 14, "name": "HalloweenPlaza", "display": "Christmas Town: Christmas Tree Plaza", "areaId": 7, "hideWorld": 1, },1807: { "worldId": 7, "name": "AgrabahShop2", "display": "The Peddler’s Shop", "areaId": 15, "hideWorld": 0, },1806: { "worldId": 7, "name": "AgrabahSand", "display": "Sandswept Ruins", "areaId": 14, "hideWorld": 0, },1803: { "worldId": 7, "name": "AgrabahRuin", "display": "Ruined Chamber", "areaId": 11, "hideWorld": 0, },1797: { "worldId": 7, "name": "AgrabahAbove", "display": "Above the City", "areaId": 5, "hideWorld": 0, },2575: { "worldId": 10, "name": "PrideSavannahBattle", "display": "The Savannah", "areaId": 15, "hideWorld": 0, },
}

registeredEvents = {
"Twilight Thorn": { "locationCode": "StationOfAwakening", "eventId": 0x9d, "score": 5, "isBoss": 1, "lv1": 1 },"Axel": { "locationCode": "BasementHallAxel", "eventId": 0x89, "score": 5, "isBoss": 1, "lv1": 1 },"Shan-Yu": { "locationCode": "PalaceGate", "eventId": 0x4b, "score": 10, "isBoss": 1, "lv1": 1 },"Thresholder": { "locationCode": "Undercroft", "eventId": 0x48, "score": 10, "isBoss": 1, "lv1": 1 },"Dark Thorn": { "locationCode": "BallroomBattle", "eventId": 0x4f, "score": 10, "isBoss": 1, "lv1": 1 },"Cerberus": { "locationCode": "CaveOfTheDeadEntrance", "eventId": 0x72, "score": 10, "isBoss": 1, "lv1": 1 },"Olympus Pete": { "locationCode": "UnderworldLock2", "eventId": 0x74, "score": 5, "isBoss": 1, "lv1": 1 },"Timeless Pete": { "locationCode": "RiverWharf", "eventId": 0x35, "score": 10, "isBoss": 1, "lv1": 1 },"Hydra": { "locationCode": "ColiseumGatesRuined", "eventId": 0xab, "score": 10, "isBoss": 1, "lv1": 1 },"Barbossa": { "locationCode": "PortHeap", "eventId": 0x3c, "score": 25, "isBoss": 1, "lv1": 1 },"Prison Keeper": { "locationCode": "HalloweenHill", "eventId": 0x34, "score": 10, "isBoss": 1, "lv1": 1 },"Oogie Boogie": { "locationCode": "HalloweenFactory", "eventId": 0x37, "score": 10, "isBoss": 1, "lv1": 1 },"Volcano and Blizzard": { "locationCode": "AgrabahPalace", "eventId": 0x3b, "score": 5, "isBoss": 1, "lv1": 1 },"Scar": { "locationCode": "PridePeakBattle", "eventId": 0x37, "score": 25, "isBoss": 1, "lv1": 1 },"Pain and Panic Cup": { "locationCode": "ColiseumTourney1", "eventId": 0xbd, "score": 10, "isBoss": 0, "lv1": 0 },"Monitors": { "locationCode": "SpaceDataspace", "eventId": 0x36, "score": 0, "isBoss": 0, "lv1": 0 },"Hostile Program": { "locationCode": "SpaceIOTowerHallway", "eventId": 0x37, "score": 10, "isBoss": 1, "lv1": 1 },"Demyx": { "locationCode": "CastleGate", "eventId": 0x37, "score": 25, "isBoss": 1, "lv1": 1 },"Battle of 1000 Heartless": { "locationCode": "GreatMaw", "eventId": 0x42, "score": 10, "isBoss": 0, "lv1": 1 },"Storm Rider": { "locationCode": "ImperialSquare", "eventId": 0x4f, "score": 10, "isBoss": 1, "lv1": 1 },"Xaldin": { "locationCode": "BeastBridge", "eventId": 0x52, "score": 25, "isBoss": 1, "lv1": 1 },"Hades": { "locationCode": "ColiseumTourneyHades", "eventId": 0xca, "score": 10, "isBoss": 1, "lv1": 1 },"Grim Reaper II": { "locationCode": "PortHarbor", "eventId": 0x36, "score": 5, "isBoss": 1, "lv1": 1 },"Experiment": { "locationCode": "HalloweenPlaza", "eventId": 0x40, "score": 25, "isBoss": 1, "lv1": 1 },"Sandswept Ruins Escape": { "locationCode": "AgrabahSand", "eventId": 0x3d, "score": 0, "isBoss": 0, "lv1": 0 },"Jafar": { "locationCode": "AgrabahAbove", "eventId": 0x3e, "score": 10, "isBoss": 1, "lv1": 1 }, 
}

abilities = {
    0x5e: { "name": "High Jump LV1", "type": "Growth", "ap": 2, "id": 0x5e },0x5f: { "name": "High Jump LV2", "type": "Growth", "ap": 2, "id": 0x5f },0x60: { "name": "High Jump LV3", "type": "Growth", "ap": 2, "id": 0x60 },0x61: { "name": "High Jump MAX", "type": "Growth", "ap": 2, "id": 0x61 },0x62: { "name": "Quick Run LV1", "type": "Growth", "ap": 2, "id": 0x62 },0x63: { "name": "Quick Run LV2", "type": "Growth", "ap": 2, "id": 0x63 },0x64: { "name": "Quick Run LV3", "type": "Growth", "ap": 2, "id": 0x64 },0x65: { "name": "Quick Run MAX", "type": "Growth", "ap": 2, "id": 0x65 },0x66: { "name": "Aerial Dodge LV1", "type": "Growth", "ap": 3, "id": 0x66 },0x67: { "name": "Aerial Dodge LV2", "type": "Growth", "ap": 3, "id": 0x67 },0x68: { "name": "Aerial Dodge LV3", "type": "Growth", "ap": 3, "id": 0x68 },0x69: { "name": "Aerial Dodge MAX", "type": "Growth", "ap": 3, "id": 0x69 },0x6a: { "name": "Glide LV1", "type": "Growth", "ap": 3, "id": 0x6a },0x6b: { "name": "Glide LV2", "type": "Growth", "ap": 3, "id": 0x6b },0x6c: { "name": "Glide LV3", "type": "Growth", "ap": 3, "id": 0x6c },0x6d: { "name": "Glide MAX", "type": "Growth", "ap": 3, "id": 0x6d },0x234: { "name": "Dodge Roll LV1", "type": "Growth", "ap": 3, "id": 0x234 },0x235: { "name": "Dodge Roll LV2", "type": "Growth", "ap": 3, "id": 0x235 },0x236: { "name": "Dodge Roll LV3", "type": "Growth", "ap": 3, "id": 0x236 },0x237: { "name": "Dodge Roll MAX", "type": "Growth", "ap": 3, "id": 0x237 },
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
14: "Halloween Town",
15: "World Map",
16: "Port Royal",
17: "Space Paranoids",
19: "The World That Never Was"
}

function generateBonusAchievements() => false

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
    event = registeredEvents[eventKey]
    return BattleCheckpointReached(location = event["locationCode"], eventId = event["eventId"], when = when, overrideNever = overrideNever, neverOverride = neverOverride)
}

achievement(title = "Doing Everything I Can", description = "Perform all three different aerial skateboard tricks before touching the ground.", points = 1,
    trigger = IsActiveInTheField() && tally(3, [ DidMethodGrab(), Did360DegreeSpin(), DidAirWalk() ])
        && never(LandedWithSkateboard()) && never(JustDidGrind()) && never(IdleWithSkateboard()) && IsInWorld("Twilight Town")
)

achievement(title = "We Tech Those [m]", description = "Finish off the Twilight Thorn with the Break Raid reaction command.", points = 10,
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

// todo: deprecated; use AnyItemWasJustUsed instead
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
    trigger = GetCheckpointForRegisteredEvent("Axel", when = level() <= 4 && IsAtLeastOnDifficulty("Proud"))
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
    trigger = GetCheckpointForRegisteredEvent("Shan-Yu", when = level() <= 10 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(reactionCommandId() == redMeteorId() && BonusObtained())
)

function landOfDragonsFirstVisitComplete() => bit2(0x32d8c2)
achievement(title = "Unquestionable Honor", description = "Complete the first visit to the Land of Dragons.", points = 3,
    trigger = WasBitflagSetInGame(landOfDragonsFirstVisitComplete()) && IsInLocation("WorldMap")
)

function currentForm() => byte(0x32f054)
function JustEnteredValorForm() => currentForm() == 1 && Delta(currentForm()) != 1
achievement(title = "Pure of Mind [m]", description = "Defeat the Thresholder and Possessor without using items or Valor Form (Proud Mode or higher; Level 13 or below; no rescues).", points = 5,
    trigger = GetCheckpointForRegisteredEvent("Thresholder", when = level() <= 13 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(UsedAnyItem()) && never(JustEnteredValorForm())
)

function limitPointer() => dword(0x1d48cb0)
function LimitIsBeingUsed() => limitPointer() != 0
achievement(title = "Silence Is Golden [m]", description = "Defeat the Dark Thorn without using Limits (Proud Mode or higher; Level 16 or below; no rescues).", points = 25,
    trigger = GetCheckpointForRegisteredEvent("Dark Thorn", when = level() <= 16 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(LimitIsBeingUsed())
)

function beastCastleFirstVisitComplete() => bit7(0x32d861)
achievement(title = "Tending the Garden", description = "Complete the first visit to Beast's Castle.", points = 3,
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
achievement(title = "Tight Deadline [m]", description = "Escape from the Valley of the Dead with Auron within " + SecondsToFormat(hadesEscapeTimeLimit())
    + " (Proud Mode or higher; Level 18 or below).",
    points = 5,
    trigger = BattleCheckpointReached(location = "ValleyOfTheDead", eventId = 0x6f, when = level() <= 18 && IsAtLeastOnDifficulty("Proud"),
        overrideNever = true,
        neverOverride = never(!IsActiveInTheField() && unless(HadesEscapeBitflagFlipped())) && never(!IsInLocation("ValleyOfTheDead") && unless(HadesEscapeBitflagFlipped())) && never(IsDead()))
        && never(EscapeFromHadesTimeLimitReached())
        && EscapedFromHades()
)

leaderboard(title = "Tight Deadline", description = "Escape from the Valley of the Dead with Auron as quickly as possible.",
    start = BattleCheckpointReached(location = "ValleyOfTheDead", eventId = 0x6f, when = level() <= 18 && IsAtLeastOnDifficulty("Proud")),
    cancel = IsDead(),
    submit = EscapedFromHades(),
    value = LMeasured(FrameAdvanced()),
    format = "FRAMES"
)

achievement(title = "Way of the Pacifist [m]", description = "Defeat Cerberus without using Bushido (Proud Mode or higher; Level 18 or below; no rescues).", points = 5,
    trigger = GetCheckpointForRegisteredEvent("Cerberus", when = level() <= 18 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(LimitIsBeingUsed())
)

function SecondsToFrames(seconds) => seconds * 60
function timeRemaining() => dword(0x349df8)
function breakneckBreakdanceTimeLimit() => 50
function demyxITimeLimit() => 80
achievement(title = "Breakneck Breakdance [m]", description = "Defeat 100 of Demyx's water forms within " + breakneckBreakdanceTimeLimit() + " seconds.", points = 5,
    trigger = BattleCheckpointReached(location = "UnderworldCavernsAtrium", eventId = 0x7b)
        && trigger_when(BonusObtained())
        && never(timeRemaining() < SecondsToFrames(demyxITimeLimit() - breakneckBreakdanceTimeLimit()))
)

function petePinballTimeLimit() => 40
function peteHerculesOverallTimeLimit() => 90
achievement(title = "Skill Shot [m]", description = "Help Hercules defeat Pete at the Lock within " + petePinballTimeLimit() + " seconds (Proud Mode or higher; Level 18 or below; no rescues).",
    points = 5,
    trigger = GetCheckpointForRegisteredEvent("Olympus Pete", when = level() <= 18 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(timeRemaining() < SecondsToFrames(peteHerculesOverallTimeLimit() - petePinballTimeLimit()))
)

achievement(title = "Aerophobia [m]", description = "Defeat the Hydra without using the Pegasus Run reaction command (Proud Mode or higher; Level 18 or below; no rescues).",
    points = 5,
    trigger = GetCheckpointForRegisteredEvent("Hydra", when = level() <= 18 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(reactionCommandId() == 0x14f)
)

function olympusColiseumFirstVisitComplete() => bit2(0x32d884)
achievement(title = "Strength of Guilt", description = "Complete the first visit to Olympus Coliseum.", points = 3,
    trigger = WasBitflagSetInGame(olympusColiseumFirstVisitComplete()) && IsInLocation("WorldMap")
)

function faithLimit() => 3
achievement(title = "O Ye of Little Faith [m]", description = "Escort Queen Minnie through the audience chamber without using the Faith reaction command more than " + faithLimit() + " times "
    + "(Proud Mode or higher; Level 20 or below).",
    points = 5,
    trigger = BattleCheckpointReached(location = "CastleAudienceChamber", eventId = 0x33, when = level() <= 20 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(repeated(faithLimit() + 1, reactionCommandId() == 0x17d && Delta(reactionCommandId()) == 0))
)
        
function healBlockerLimit() => 50
function peteEnemySlotHP() => dword(0x1c6bdb0)
achievement(title = "Heal Blocker [m]", description = "Defeat Pete for the second time in Timeless River without letting him restore more than " + healBlockerLimit()
    + " HP (Proud Mode or higher; Level 21 or below).", points = 5,
    trigger = GetCheckpointForRegisteredEvent("Timeless Pete", when = level() <= 21 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(repeated(healBlockerLimit() + 1, Delta(peteEnemySlotHP()) < peteEnemySlotHP()))
)

function disneyCastleComplete() => bit2(0x32d942)
achievement(title = "Historic Preservation", description = "Complete Disney Castle.", points = 3,
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

function exp() => dword(0x32f210)
achievement(title = "Pacifism [m]", description = "Survive the one-minute pirate attack at the Isla de Muerta without defeating any of them and without items"
    + " (Proud Mode or higher; Level 23 or below; No Experience must not be equipped).",
    points = 5,
    trigger = BattleCheckpointReached(location = "PortCaveMouth", eventId = 0x3b, when = level() <= 23 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(timeRemaining() <= 0)
        && never(Delta(exp()) < exp())
        && never(HasAbilityWithGivenIdEquipped(0x194))
        && never(AnyItemWasJustUsed())
)

achievement(title = "Sticky Fingers [m]", description = "Protect the cursed medallion from the pirates without it getting stolen (Proud Mode or higher; Level 23 or below).", points = 10,
    trigger = BattleCheckpointReached(location = "PortInterceptorDualBattle", eventId = 0x3a, when = level() <= 23 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(timeRemaining() < Delta(timeRemaining()))
)

function fieldMp() => dword(0x1c6c8d0)
function JustUsedMagicWithId(id) => fieldActionId() == id && Delta(fieldMp()) > fieldMp()
function JustUsedFire() => JustUsedMagicWithId(0x38)
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
achievement(title = "Swashbuckler [m]", description = "Defeat Barbossa without using magic (Proud Mode or higher; Level 23 or below).", points = 25,
    trigger = GetCheckpointForRegisteredEvent("Barbossa", when = level() <= 23 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(UsedAnyMagic())
)

function portRoyalIComplete() => bit5(0x32d9c9)
achievement(title = "A Curse Lifted", description = "Complete the first visit to Port Royal.", points = 3,
    trigger = WasBitflagSetInGame(portRoyalIComplete()) && IsInLocation("WorldMap")
)

function prisonKeeperTimeLimit() => 123
function PrisonKeeperTimeLimitReached() => repeated(prisonKeeperTimeLimit() * 60, FrameAdvanced())
achievement(title = "Escape Artist [m]", description = "Defeat the Prison Keeper within " + SecondsToFormat(prisonKeeperTimeLimit()) + " (Proud Mode or higher; Level 24 or below).", points = 10,
    trigger = GetCheckpointForRegisteredEvent("Prison Keeper", when = level() <= 24 && IsAtLeastOnDifficulty("Proud"))
        && never(PrisonKeeperTimeLimitReached())
        && trigger_when(BonusObtained())
)

leaderboard(title = "Escape Artist", description = "Defeat the Prison Keeper as quickly as possible.",
    start = GetCheckpointForRegisteredEvent("Prison Keeper", when = level() <= 24 && IsAtLeastOnDifficulty("Proud")),
    cancel = IsDead(),
    submit = BonusObtained(),
    value = LMeasured(FrameAdvanced()),
    format = "FRAMES"
)

function currentDrivePoints() => byte(0x1c6c901)
achievement(title = "Sandbagging Clause [m]", description = "Defeat Oogie Boogie without using items or Drive Points (Proud Mode or higher; Level 24 or below).", points = 10,
    trigger = GetCheckpointForRegisteredEvent("Oogie Boogie", when = level() <= 24 && IsAtLeastOnDifficulty("Proud"))
        && never(AnyItemWasJustUsed())
        && never(Delta(currentDrivePoints()) > currentDrivePoints())
        && trigger_when(BonusObtained())
)

function halloweenTownIComplete() => bit4(0x32d986)
achievement(title = "Believe...and Dive In", description = "Complete the first visit to Halloween Town.", points = 3,
    trigger = WasBitflagSetInGame(halloweenTownIComplete()) && IsInLocation("WorldMap")
)

function chasmTimeLimit() => 85
function timerState() => byte(0x349dec)
function TimedEventEnded() => timerState() == 4 && Delta(timerState()) == 0
function TimerAdvanced() => Delta(timeRemaining()) > timeRemaining()
function SpeedfallerCheckpointReached() => BattleCheckpointReached(location = "AgrabahCaveChasm", eventId = 0x4f, when = level() <= 25 && IsAtLeastOnDifficulty("Proud"))
        || BattleCheckpointReached(location = "AgrabahCaveChasm", eventId = 0x50, when = level() <= 25 && IsAtLeastOnDifficulty("Proud"))
function SpeedfallerTriggered() => TimedEventEnded() && TimerAdvanced()
achievement(title = "Speedfaller [m]", description = "Complete the Chasm of Challenges in " + SecondsToFormat(chasmTimeLimit()) + " (Proud Mode or higher; Level 25 or below).", points = 5,
    trigger = SpeedfallerCheckpointReached()
        && never(timeRemaining() < SecondsToFrames(120 - chasmTimeLimit()) && TimerAdvanced())
        && trigger_when(SpeedfallerTriggered())
)

function GlobalTimerCanceled() => IsDead() || timeRemaining() == 0 && TimerAdvanced()
leaderboard(title = "Speedfaller", description = "Complete the Chasm of Challenges as quickly as you can.",
    start = SpeedfallerCheckpointReached() && never(GlobalTimerCanceled()), // Adding the cancelation code here to ensure all hit targets are cleared on subsequent retries.
    cancel = GlobalTimerCanceled(),
    submit = SpeedfallerTriggered(),
    value = SecondsToFrames(120) - timeRemaining(),
    format = "FRAMES",
    lower_is_better = true
)

function JustEnteredValorForm() => currentForm() == 1 && Delta(currentForm()) != 1
function JustEnteredWisdomForm() => currentForm() == 2 && Delta(currentForm()) != 2
function JustEnteredLimitForm() => currentForm() == 3 && Delta(currentForm()) != 3
function JustEnteredMasterForm() => currentForm() == 4 && Delta(currentForm()) != 4
function JustEnteredFinalForm() => currentForm() == 5 && Delta(currentForm()) != 5
function JustEnteredAntiForm() => currentForm() == 6 && Delta(currentForm()) != 6
function JustUsedDriveForm() => JustEnteredValorForm() && JustEnteredWisdomForm() && JustEnteredMasterForm() && JustEnteredLimitForm() && JustEnteredFinalForm() && JustEnteredAntiForm()
achievement(title = "Solo Heist [m]", description = "Defeat the Heartless ambush in the Cave of Wonders Treasure Room without using Drive Points or Limits (Proud Mode or higher; Level 25 or below).",
    points = 25,
    trigger = BattleCheckpointReached(location = "AgrabahCaveTreasure", eventId = 0x3a, when = level() <= 25 && IsAtLeastOnDifficulty("Proud"))
        && never(LimitIsBeingUsed())
        && never(Delta(currentDrivePoints()) > currentDrivePoints())
        && trigger_when(BonusObtained())
)

achievement(title = "Too Hot Inside, Too Cold Outside [m]", description = "Defeat the Volcano and Blizzard Lords without using magic or the Firagun or Blizzagun reaction commands "
    + "(Proud Mode or higher; Level 25 or below).", points = 5,
    trigger = GetCheckpointForRegisteredEvent("Volcano and Blizzard", when = level() <= 25 && IsAtLeastOnDifficulty("Proud"))
        && never(UsedAnyMagic())
        // Checking the field action ID is needed because the reaction command ID doesn't actually update until after the second part of the combo is active.
        && never(reactionCommandId() == 0x295 || fieldActionId() == 0xfc) // Firagun
        && never(reactionCommandId() == 0x296 || fieldActionId() == 0xfc) // Blizzagun
        && trigger_when(BonusObtained())
)

function agrabahIComplete() => bit4(0x32d8a3)
achievement(title = "Forever Sealed?", description = "Complete the first visit to Agrabah.", points = 3,
    trigger = WasBitflagSetInGame(agrabahIComplete())
)

achievement(title = "One-Trick Lion [m]", description = "Protect Timon and Pumbaa using only one type of non-Cure magic spell and no items (Proud Mode or higher; Level 27 or below).",
    points = 5,
    trigger = BattleCheckpointReached(location = "PrideDen", eventId = 0x33, when = level() <= 27 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(JustUsedCure())
        && never(AnyItemWasJustUsed())
        // We don't have to check for finishers here because Lion Form doesn't use them.
        && never(tally(2, [ once(JustUsedFire()), once(JustUsedBlizzard()), once(JustUsedThunder()), once(JustUsedReflect()), once(JustUsedMagnet()) ]))
)

// This fight sucks, and no number of challenges will make this any more fun or less frustrating, so I'm throwing players a bone here.
achievement(title = "Dull Claws [m]", description = "Defeat Scar on Proud Mode or higher at Level 27 or below.", points = 10,
    trigger = GetCheckpointForRegisteredEvent("Scar", when = level() <= 27 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
)

function prideLandsIComplete() => bit5(0x32d905)
achievement(title = "Return of the King", description = "Complete the first visit to the Pride Lands.", points = 3,
    trigger = WasBitflagSetInGame(prideLandsIComplete())
)

function forkBomberTimeLimit() => 60
function ForkBomberCheckpointReached() => GetCheckpointForRegisteredEvent("Monitors", when = level() <= 29 && IsAtLeastOnDifficulty("Proud"))
achievement(title = "Fork Bomber [m]", description = "Freeze all the security monitors in Space Paranoids within " + forkBomberTimeLimit() + " seconds (Proud Mode or higher; Level 29 or below).",
    points = 10,
    trigger = ForkBomberCheckpointReached()
        && never(timeRemaining() < SecondsToFrames(120 - forkBomberTimeLimit()) && TimerAdvanced())
        && trigger_when(BonusObtained())
)

achievement(title = "Resource Hog [m]", description = "Defeat the Hostile Program without using the Freeze reaction command more than once (Proud Mode or higher; Level 29 or below).",
    points = 10,
    trigger = GetCheckpointForRegisteredEvent("Hostile Program", when = level() <= 29 && IsAtLeastOnDifficulty("Proud"))
        && never(repeated(2, reactionCommandId() == 0x267 && Delta(reactionCommandId()) == 0))
        && trigger_when(BonusObtained())
)

leaderboard(title = "Fork Bomber", description = "Freeze all the security monitors in the Space Paranoids Dataspace as quickly as you can.",
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
achievement(title = "Two Left Feet [m]", description = "Defeat Demyx without any Growth Abilities equipped (Proud Mode or higher; Level 31 or below).", points = 25,
    trigger = GetCheckpointForRegisteredEvent("Demyx", when = level() <= 31 && IsAtLeastOnDifficulty("Proud"))
        && never(BaseSoraHasAnyGivenAbilityEquipped(growthAbilities))
        && trigger_when(BonusObtained())
)

function mpChargeTimeRemaining() => float(0x01c6c90c)
achievement(title = "Vampiricism [m]", description = "Survive the Battle of 1000 Heartless without ever using items or entering MP Charge (Proud Mode or higher; Level 32 or below).", points = 10,
    trigger = GetCheckpointForRegisteredEvent("Battle of 1000 Heartless", when = level() <= 32 && IsAtLeastOnDifficulty("Proud"))
        && never(Delta(mpChargeTimeRemaining()) == 0.0 && mpChargeTimeRemaining() > 0.0)
        && never(AnyItemWasJustUsed())
        && trigger_when(BonusObtained())
)

function hollowBastionIIComplete() => bit6(0x0032d84e)
achievement(title = "Three Pawns", description = "Complete the second visit to Hollow Bastion.", points = 3,
    trigger = WasBitflagSetInGame(hollowBastionIIComplete())
)

function IsInWisdomForm() => currentForm() == 2
function IsInAntiForm() => currentForm() == 6
achievement(title = "Spellblade [m]", description = "Defeat the Storm Rider while Wisdom Form or Anti-Form is active (Proud Mode or higher; Level 34 or below).", points = 10,
    trigger = GetCheckpointForRegisteredEvent("Storm Rider", when = level() <= 34 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && trigger_when(IsInWisdomForm() || IsInAntiForm())
)

function landOfDragonsIIComplete() => bit7(0x0032d8c1)
achievement(title = "Hand Clenched in Hand", description = "Complete the second visit to the Land of Dragons.", points = 3,
    trigger = WasBitflagSetInGame(landOfDragonsIIComplete())
)

function numberOfJumpsStored() => byte(0x01c5fdf8)
function StoredAJump() => Delta(numberOfJumpsStored()) + 1 == numberOfJumpsStored()
function jumpLimit() => 10
achievement(title = "Truancy [m]", description = "Defeat Xaldin without charging up more than " + jumpLimit() + " Jump commands (Proud Mode or higher; Level 37 or below; no rescues).", points = 50,
    trigger = GetCheckpointForRegisteredEvent("Xaldin", when = level() <= 37 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(repeated(jumpLimit() + 1, StoredAJump()))
)

// todo: WTF do I even name this achievement???
function beastCastleIIComplete() => bit2(0x0032d862)
achievement(title = "Blooming Love", description = "Complete the second visit to Beast's Castle.", points = 3,
    trigger = WasBitflagSetInGame(beastCastleIIComplete())
)

achievement(title = "Short of Godhood [m]", description = "Defeat Hades without using Aura Sphere or Aura Guard (Proud Mode or higher; Level 38 or below).", points = 5,
    trigger = GetCheckpointForRegisteredEvent("Hades", when = level() <= 38 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(reactionCommandId() == 0x13b) // Aura Guard
        && never(reactionCommandId() == 0x1cf) // Aura Sphere
)

function olympusColiseumIIComplete() => bit6(0x0032d884)
achievement(title = "Phil's Boys", description = "Complete the second visit to Olympus Coliseum.", points = 3,
    trigger = WasBitflagSetInGame(olympusColiseumIIComplete())
)

function ToxicGreedCheckpointReached() => GetCheckpointForRegisteredEvent("Grim Reaper II", when = level() <= 40 && IsAtLeastOnDifficulty("Proud"))
function medallionsBeingHeld() => dword(0x01d48efc) // Note that this is the same address as the one that holds the player's Underdrome score!
function SoraIsHoldingAMedallion() => medallionsBeingHeld() > 0
function toxicGreedTimeLimit() => 90
function FrameAdvancedWhileHoldingMedallion() => FrameAdvanced() && SoraIsHoldingAMedallion()

achievement(title = "Creeping Curse [m]", description = "Defeat the Grim Reaper before spending a total of " + SecondsToFormat(toxicGreedTimeLimit()) + " holding a medallion "
    + "(Proud Mode or higher; Level 40 or below).", points = 10,
    trigger = ToxicGreedCheckpointReached()
        && trigger_when(BonusObtained())
        && never(repeated(SecondsToFrames(toxicGreedTimeLimit()), FrameAdvancedWhileHoldingMedallion()))
)

leaderboard(title = "Creeping Curse", description = "Defeat the Grim Reaper while holding medallions for as little time as possible.",
    start = ToxicGreedCheckpointReached(),
    cancel = IsDead(),
    submit = BonusObtained(),
    value = LMeasured(FrameAdvancedWhileHoldingMedallion()),
    format = "FRAMES",
    lower_is_better = true
)

function portRoyalIIComplete() => bit0(0x0032d9ca)
achievement(title = "As Free as the Winds", description = "Complete the second visit to Port Royal.", points = 3,
    trigger = WasBitflagSetInGame(portRoyalIIComplete())
)

function currentSummon() => byte(0x0032f055)
function JustUsedAnySummon() => Delta(currentSummon()) == 0 && currentSummon() != 0
achievement(title = "Out of Harm's Way [m]", description = "Defeat the Experiment without using Summons (Proud Mode or higher; Level 41 or below).",
    points = 10,
    trigger = GetCheckpointForRegisteredEvent("Experiment", when = level() <= 41 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(JustUsedAnySummon())
)

function halloweenTownIIComplete() => bit7(0x0032d986)
achievement(title = "Presence Is the Best Gift", description = "Complete the second visit to Halloween Town.", points = 3,
    trigger = WasBitflagSetInGame(halloweenTownIIComplete())
)

function IsAttackingOnCarpet() => fieldActionId() == 0x97 || fieldActionId() == 0x98 || fieldActionId() == 0x9b
achievement(title = "Merciful Escapist [m]", description = "Escape from the Sandswept Ruins without attacking once (Proud Mode or higher; Level 42 or below).", points = 5,
    trigger = GetCheckpointForRegisteredEvent("Sandswept Ruins Escape", when = level() <= 42 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(TimedEventEnded())
        && never(IsAttackingOnCarpet())
)

achievement(title = "Fragile Rotor [m]", description = "Defeat Jafar without using the Spin Burst reaction command more than twice (Proud Mode or higher; Level 42 or below).", points = 10,
    trigger = GetCheckpointForRegisteredEvent("Jafar", when = level() <= 42 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(BonusObtained())
        && never(repeated(3, reactionCommandId() == 0x281 && Delta(reactionCommandId()) == 0))
)

function agrabahIIComplete() => bit0(0x0032d8a4)
achievement(title = "Measure of a Friend", description = "Complete the second visit to Agrabah.", points = 3,
    trigger = WasBitflagSetInGame(agrabahIIComplete())
)

function IsUsingFireCheese()
{
    
}

function PainAndPanicCupCheckpointReached(when = always_true())
    => once(eventId() == 0xbd && IsActiveInTheField() && IsInLocation("ColiseumTourney1") && JustBecameActiveInTheField() && currentRound() == 1 && when)
    && never(IsDead()) && never(IsInLocation("UnderworldEntrance"))
function WonThePainAndPanicCup() => eventId() == 0xb4 && IsInLocation("ColiseumVictory")
achievement(title = "Pain and Panic Champion", description = "Win the Pain and Panic Cup.", points = 3,
    trigger = PainAndPanicCupCheckpointReached() && WonThePainAndPanicCup()
)

function underdromeCurrentScore() => dword(0x01d48efc)
achievement(title = "Pain and Panic Recordsetter", description = "Win the Pain and Panic Cup with a score of 2000 or more.", points = 5,
    trigger = PainAndPanicCupCheckpointReached() && underdromeCurrentScore() >= 2000 && WonThePainAndPanicCup()
)

achievement(title = "Pain and Panic Title Defender [m]", description = "Win the Pain and Panic Cup without using Limits (Proud Mode or higher; Level 30 or below).", points = 25,
    trigger = PainAndPanicCupCheckpointReached(when = level() <= 30 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(WonThePainAndPanicCup())
        && never(LimitIsBeingUsed())
)

function CerberusCupCheckpointReached(when = always_true())
    => once(eventId() == 0xbe && IsActiveInTheField() && IsInLocation("ColiseumTourney1") && JustBecameActiveInTheField() && currentRound() == 1 && when)
    && never(IsDead()) && never(IsInLocation("UnderworldEntrance"))
function WonTheCerberusCup() => eventId() == 0xb6 && IsInLocation("ColiseumVictory")
achievement(title = "Cerberus Champion", description = "Win the Cerberus Cup.", points = 3,
    trigger = CerberusCupCheckpointReached() && WonTheCerberusCup()
)

achievement(title = "Cerberus Recordsetter", description = "Win the Cerberus Cup with a score of 1000 or more.", points = 5,
    trigger = CerberusCupCheckpointReached() && WonTheCerberusCup() && underdromeCurrentScore() >= 1000
)

function CurrentRoundHasChanged() => Delta(currentRound()) != currentRound()
// Checking for whether or not the player is active on the field is so that they can use the Retry option in the middle of Round 1 and not have their uses carry over.
function ConditionIsTrueMoreThanOncePerRound(condition) => repeated(2, condition && never(CurrentRoundHasChanged()) && never(!IsActiveInTheField()))
achievement(title = "Cerberus Title Defender [m]", description = "Win the Cerberus Cup without activating the same Drive Form more than once per round (Proud Mode or higher; Level 33 or below).",
    points = 25,
    trigger = CerberusCupCheckpointReached(when = level() <= 33 && IsAtLeastOnDifficulty("Proud"))
        && trigger_when(WonTheCerberusCup())
        && never(ConditionIsTrueMoreThanOncePerRound(JustEnteredValorForm()))
        && never(ConditionIsTrueMoreThanOncePerRound(JustEnteredWisdomForm()))
        && never(ConditionIsTrueMoreThanOncePerRound(JustEnteredLimitForm()))
        && never(ConditionIsTrueMoreThanOncePerRound(JustEnteredMasterForm()))
        && never(ConditionIsTrueMoreThanOncePerRound(JustEnteredFinalForm()))
        && never(ConditionIsTrueMoreThanOncePerRound(JustEnteredAntiForm()))
)

function valorLevel() => byte(0x32ee26)
achievement(title = "The Dauntless", description = "Raise Valor Form to the maximum level.", points = 5,
    trigger = WasValueSetInGame(valorLevel(), 6, 7) && measured(valorLevel() == 7)
)

function wisdomLevel() => byte(0x32ee5e)
achievement(title = "The Erudite", description = "Raise Wisdom Form to the maximum level.", points = 5,
    trigger = WasValueSetInGame(wisdomLevel(), 6, 7) && measured(wisdomLevel() == 7)
)

function limitLevel() => byte(0x0032ee96)
achievement(title = "The Renowned", description = "Raise Limit Form to the maximum level.", points = 5,
    trigger = WasValueSetInGame(limitLevel(), 6, 7) && measured(limitLevel() == 7)
)

function antiUses() => word(0x32fb10)
achievement(title = "The Corrupted", description = "Activate Anti-Form for the first time.", points = 1,
    trigger = WasValueSetInGame(antiUses(), 0, 1)
)

if (generateBonusAchievements())
{
    for event in registeredEvents
    {
        dat = registeredEvents[event]
        
        if (dat["lv1"] == 1)
        {
            description = ""
        
            if (dat["isBoss"] == 1)
            {
                description = "Defeat " + event + " at Level 1 on Critical Mode and without being rescued."
            }
            else
            {
                description = "Complete the " + event + " at Level 1 on Critical Mode."
            }
        
            achievement(title = event + " [m]", description = description, points = dat["score"],
                trigger = GetCheckpointForRegisteredEvent(event, when = level() <= 1 && IsAtLeastOnDifficulty("Critical"))
                    && trigger_when(BonusObtained())
            )   
        }
    }
}
